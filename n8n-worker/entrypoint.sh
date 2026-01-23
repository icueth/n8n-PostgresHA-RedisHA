#!/bin/sh
set -e

echo "========================================="
echo "  n8n Worker - Queue Mode"
echo "  Powered by PostgreSQL HA + Redis"
echo "========================================="

# Wait for n8n main to initialize and database migrations
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting 3.5 minutes for n8n main instance and database..."
sleep 210

echo ""
echo "Worker Configuration:"
echo "  - Worker Mode: worker"
echo "  - Database Host: ${DB_POSTGRESDB_HOST:-postgres-18-primary.railway.internal}"
echo "  - Database Name: ${DB_POSTGRESDB_DATABASE:-n8n}"
echo "  - Redis Host: ${QUEUE_BULL_REDIS_HOST:-redis-n8n.railway.internal}"
echo "  - Timezone: ${GENERIC_TIMEZONE:-UTC}"
echo "  - Concurrency: ${N8N_CONCURRENCY_PRODUCTION_LIMIT:-10}"
echo ""

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting n8n worker..."

# Execute n8n in worker mode
exec n8n worker "$@"
