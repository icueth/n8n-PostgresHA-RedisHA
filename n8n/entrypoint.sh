#!/bin/bash
set -e

echo "========================================="
echo "  n8n Enterprise-Ready Stack"
echo "  Powered by PostgreSQL HA + Redis HA"
echo "========================================="

# Wait for PostgreSQL to be ready using TCP check
wait_for_postgres() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for PostgreSQL to be ready..."
    
    local max_attempts=60
    local attempt=1
    local host="${DB_POSTGRESDB_HOST:-postgres-18-proxy.railway.internal}"
    local port="${DB_POSTGRESDB_PORT:-5432}"
    
    while [ $attempt -le $max_attempts ]; do
        if timeout 2 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] PostgreSQL is ready!"
            return 0
        fi
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for PostgreSQL at $host:$port... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: PostgreSQL connection timeout!"
    exit 1
}

# Wait for Redis to be ready using TCP check
wait_for_redis() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for Redis to be ready..."
    
    local max_attempts=30
    local attempt=1
    local host="${QUEUE_BULL_REDIS_HOST:-redis.railway.internal}"
    local port="${QUEUE_BULL_REDIS_PORT:-6379}"
    
    while [ $attempt -le $max_attempts ]; do
        if timeout 2 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis is ready!"
            return 0
        fi
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for Redis at $host:$port... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: Redis connection timeout - continuing without Redis queue mode"
}

# Determine execution mode
determine_mode() {
    if [ -n "$EXECUTIONS_MODE" ] && [ "$EXECUTIONS_MODE" = "queue" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running in QUEUE mode (scalable)"
        export N8N_SCALING_ENABLED=true
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running in REGULAR mode"
        export EXECUTIONS_MODE=regular
    fi
}

# Print configuration summary
print_config() {
    echo ""
    echo "📊 Configuration Summary:"
    echo "  - Execution Mode: ${EXECUTIONS_MODE:-regular}"
    echo "  - Database Host: ${DB_POSTGRESDB_HOST:-postgres-18-proxy.railway.internal}"
    echo "  - Database Name: ${DB_POSTGRESDB_DATABASE:-n8n}"
    echo "  - Redis Host: ${QUEUE_BULL_REDIS_HOST:-redis.railway.internal}"
    echo "  - Timezone: ${GENERIC_TIMEZONE:-UTC}"
    echo ""
}

# Main execution
main() {
    # Wait for dependencies
    wait_for_postgres
    
    # Only wait for Redis if queue mode is enabled
    if [ "$EXECUTIONS_MODE" = "queue" ]; then
        wait_for_redis
    fi
    
    # Determine execution mode
    determine_mode
    
    # Print configuration
    print_config
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting n8n..."
    
    # Execute n8n with any passed arguments
    exec n8n "$@"
}

main "$@"
