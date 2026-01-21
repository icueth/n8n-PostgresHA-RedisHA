# n8n Worker Service

n8n Worker processes workflow executions in Queue mode, enabling horizontal scaling.

## Features

- **Queue Processing**: Consumes jobs from Redis Bull queue
- **Horizontal Scaling**: Add more workers for more throughput
- **Independent Processing**: Each worker operates independently
- **No Web UI**: Workers only process executions, no HTTP endpoints

## Environment Variables

| Variable                           | Required | Default  | Description         |
| ---------------------------------- | -------- | -------- | ------------------- |
| `DB_POSTGRESDB_HOST`               | Yes      | -        | PostgreSQL host     |
| `DB_POSTGRESDB_DATABASE`           | Yes      | n8n      | Database name       |
| `DB_POSTGRESDB_USER`               | Yes      | postgres | Database user       |
| `DB_POSTGRESDB_PASSWORD`           | Yes      | -        | Database password   |
| `QUEUE_BULL_REDIS_HOST`            | Yes      | -        | Redis host          |
| `QUEUE_BULL_REDIS_PASSWORD`        | Yes      | -        | Redis password      |
| `N8N_ENCRYPTION_KEY`               | Yes      | -        | Must match main n8n |
| `N8N_CONCURRENCY_PRODUCTION_LIMIT` | No       | 10       | Parallel executions |
| `GENERIC_TIMEZONE`                 | No       | UTC      | Timezone            |

## Scaling

Increase the number of workers based on your execution volume:

| Daily Executions | Recommended Workers |
| ---------------- | ------------------- |
| < 1,000          | 1                   |
| 1,000 - 10,000   | 2-3                 |
| 10,000 - 100,000 | 5-10                |
| 100,000+         | 10+                 |

## Important Notes

1. Workers must use the **same** `N8N_ENCRYPTION_KEY` as the main n8n instance
2. Workers require Redis - they don't function in `regular` mode
3. Each worker processes jobs concurrently up to `N8N_CONCURRENCY_PRODUCTION_LIMIT`
