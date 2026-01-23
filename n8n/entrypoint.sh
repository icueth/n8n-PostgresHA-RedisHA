#!/bin/sh
set -e

echo "========================================="
echo "  n8n Enterprise-Ready Stack"
echo "  Powered by PostgreSQL HA + Redis"
echo "========================================="

echo ""
echo "Configuration Summary:"
echo "  - Execution Mode: ${EXECUTIONS_MODE:-regular}"
echo "  - Database Host: ${DB_POSTGRESDB_HOST:-postgres-18-primary.railway.internal}"
echo "  - Database Name: ${DB_POSTGRESDB_DATABASE:-n8n}"
echo "  - Redis Host: ${QUEUE_BULL_REDIS_HOST:-redis-n8n.railway.internal}"
echo "  - Timezone: ${GENERIC_TIMEZONE:-UTC}"
echo ""

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting n8n (will retry DB connection automatically)..."

# Execute n8n with any passed arguments
exec n8n "$@"
