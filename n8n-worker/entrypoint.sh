#!/bin/bash
set -e

echo "========================================="
echo "  n8n Worker - Queue Mode"
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

# Wait for Redis to be ready (required for queue mode)
wait_for_redis() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for Redis to be ready..."
    
    local max_attempts=60
    local attempt=1
    local host="${QUEUE_BULL_REDIS_HOST:-redis-master.railway.internal}"
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
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Redis connection timeout!"
    exit 1
}

# Wait for main n8n to initialize (gives time for DB migrations)
wait_for_n8n() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting for n8n main instance to be ready..."
    sleep 10
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Proceeding with worker start..."
}

# Print configuration summary
print_config() {
    echo ""
    echo "📊 Worker Configuration:"
    echo "  - Worker Mode: worker"
    echo "  - Database Host: ${DB_POSTGRESDB_HOST:-postgres-18-proxy.railway.internal}"
    echo "  - Database Name: ${DB_POSTGRESDB_DATABASE:-n8n}"
    echo "  - Redis Host: ${QUEUE_BULL_REDIS_HOST:-redis-master.railway.internal}"
    echo "  - Timezone: ${GENERIC_TIMEZONE:-UTC}"
    echo "  - Concurrency: ${N8N_CONCURRENCY_PRODUCTION_LIMIT:-10}"
    echo ""
}

# Main execution
main() {
    # Wait for dependencies
    wait_for_postgres
    wait_for_redis
    
    # Wait for n8n main to initialize
    wait_for_n8n
    
    # Print configuration
    print_config
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting n8n worker..."
    
    # Execute n8n in worker mode
    exec n8n worker "$@"
}

main "$@"
