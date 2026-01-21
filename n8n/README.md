# n8n Service

n8n is the core workflow automation engine in this stack.

## Features

- **Web UI**: Access workflows at port 5678
- **Webhook Receiver**: Handles incoming webhooks
- **Queue Mode**: Scalable execution with Redis Bull
- **PostgreSQL Backend**: Enterprise-grade data storage

## Environment Variables

| Variable                         | Required   | Default  | Description               |
| -------------------------------- | ---------- | -------- | ------------------------- |
| `DB_POSTGRESDB_HOST`             | Yes        | -        | PostgreSQL host           |
| `DB_POSTGRESDB_PORT`             | No         | 5432     | PostgreSQL port           |
| `DB_POSTGRESDB_DATABASE`         | Yes        | n8n      | Database name             |
| `DB_POSTGRESDB_USER`             | Yes        | postgres | Database user             |
| `DB_POSTGRESDB_PASSWORD`         | Yes        | -        | Database password         |
| `EXECUTIONS_MODE`                | No         | regular  | `regular` or `queue`      |
| `QUEUE_BULL_REDIS_HOST`          | Queue mode | -        | Redis host                |
| `QUEUE_BULL_REDIS_PORT`          | No         | 6379     | Redis port                |
| `QUEUE_BULL_REDIS_PASSWORD`      | Queue mode | -        | Redis password            |
| `N8N_ENCRYPTION_KEY`             | Yes        | -        | Credential encryption key |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | Yes        | -        | JWT secret                |
| `GENERIC_TIMEZONE`               | No         | UTC      | Timezone                  |

## Health Check

The service exposes a health endpoint at `/healthz`.

## Scaling

For horizontal scaling, use Queue mode with n8n-worker instances.
