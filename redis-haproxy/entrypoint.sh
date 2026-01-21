#!/bin/bash
set -e

echo "========================================="
echo "  Redis HAProxy - Sentinel-Aware Proxy"
echo "========================================="

# Required environment variables
if [ -z "$SENTINEL_HOST" ]; then
    echo "[ERROR] SENTINEL_HOST is required!"
    exit 1
fi

if [ -z "$REDIS_PASSWORD" ]; then
    echo "[ERROR] REDIS_PASSWORD is required!"
    exit 1
fi

# Set defaults
export SENTINEL_PORT=${SENTINEL_PORT:-26379}
export SENTINEL_MASTER_NAME=${SENTINEL_MASTER_NAME:-mymaster}
export HAPROXY_PORT=${HAPROXY_PORT:-6379}
export REDIS_MASTER_PORT=${REDIS_MASTER_PORT:-6379}

echo "[INFO] Configuration:"
echo "  - Sentinel Host: $SENTINEL_HOST"
echo "  - Sentinel Port: $SENTINEL_PORT"
echo "  - Master Name: $SENTINEL_MASTER_NAME"
echo "  - HAProxy Port: $HAPROXY_PORT"

# Wait for Sentinel to be ready
echo "[INFO] Waiting for Sentinel to be ready..."
MAX_RETRIES=60
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if redis-cli -h "$SENTINEL_HOST" -p "$SENTINEL_PORT" -a "$REDIS_PASSWORD" ping 2>/dev/null | grep -q "PONG"; then
        echo "[OK] Sentinel is ready!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "[INFO] Waiting for Sentinel... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "[ERROR] Sentinel not responding after $MAX_RETRIES attempts!"
    exit 1
fi

# Get current master from Sentinel
get_master() {
    redis-cli -h "$SENTINEL_HOST" -p "$SENTINEL_PORT" -a "$REDIS_PASSWORD" \
        SENTINEL get-master-addr-by-name "$SENTINEL_MASTER_NAME" 2>/dev/null | head -1
}

CURRENT_MASTER=$(get_master)
if [ -z "$CURRENT_MASTER" ]; then
    echo "[ERROR] Could not get master address from Sentinel!"
    exit 1
fi

export REDIS_MASTER_HOST="$CURRENT_MASTER"
echo "[INFO] Current Redis Master: $REDIS_MASTER_HOST:$REDIS_MASTER_PORT"

# Generate HAProxy configuration
envsubst < /usr/local/etc/haproxy/haproxy.cfg.template > /usr/local/etc/haproxy/haproxy.cfg

echo "[INFO] HAProxy configuration generated"
cat /usr/local/etc/haproxy/haproxy.cfg

# Start HAProxy with master monitoring in background
echo "[INFO] Starting HAProxy..."

# Background master monitor
(
    while true; do
        sleep 5
        NEW_MASTER=$(get_master)
        if [ -n "$NEW_MASTER" ] && [ "$NEW_MASTER" != "$REDIS_MASTER_HOST" ]; then
            echo "[FAILOVER] Master changed from $REDIS_MASTER_HOST to $NEW_MASTER"
            export REDIS_MASTER_HOST="$NEW_MASTER"
            envsubst < /usr/local/etc/haproxy/haproxy.cfg.template > /usr/local/etc/haproxy/haproxy.cfg
            # Signal HAProxy to reload
            kill -USR2 $(cat /var/run/haproxy.pid) 2>/dev/null || true
        fi
    done
) &

exec haproxy -f /usr/local/etc/haproxy/haproxy.cfg -W -db
