# Deploy and Host n8n Enterprise-Ready Stack on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/YOUR_TEMPLATE_ID)

**n8n Enterprise-Ready Stack** is a production-grade, self-hosted workflow automation platform combining n8n with PostgreSQL HA and Redis for queue management. Deploy with a single click and get infinite horizontal scaling, automatic failover, and enterprise reliability.

---

## About Hosting n8n Enterprise-Ready Stack

Deploying n8n in production requires a robust database, a queue system for high-volume executions, and the ability to scale workers. This template provides:

- **PostgreSQL HA** with Primary-Replica replication
- **Redis** for queue-based execution and scaling
- **n8n Main Instance** serving web UI and webhooks
- **n8n Workers** processing executions in parallel
- **External Task Runner** for secure, isolated code execution (Python/JS)

Everything deploys automatically with proper networking, health checks, and restart policies.

---

## Common Use Cases

### Marketing Automation

- Sync leads between CRM, email marketing, and ad platforms
- Process webhooks from landing pages and forms
- Build custom integrations that Zapier doesn't offer

### E-Commerce Operations

- Automate order processing and shipping notifications
- Sync products across Shopify, WooCommerce, marketplaces
- Build checkout automation with payment integrations

### Data Pipeline & ETL

- Extract data from APIs, databases, and files on schedule
- Transform and load data into warehouses or dashboards
- Monitor pipeline health with error notifications

### DevOps & IT Automation

- Automate deployment notifications to Slack/Discord
- Process GitHub/GitLab webhooks for CI/CD
- Sync issues across Jira, Linear, Notion

### AI & LLM Workflows

- Build RAG pipelines with vector databases
- Automate content generation with OpenAI, Anthropic
- Create AI chatbots integrated with existing tools

---

## Dependencies for n8n Enterprise-Ready Stack Hosting

| Dependency      | Version | Purpose                            |
| --------------- | ------- | ---------------------------------- |
| **n8n**         | Latest  | Workflow automation engine         |
| **Task Runner** | Latest  | Unified Python/JS execution engine |
| **PostgreSQL**  | 18      | Primary database with extensions   |
| **Redis**       | 7.4     | Queue management for workers       |

### PostgreSQL Extensions Included

- **PostGIS** - Geospatial data types
- **pgvector** - Vector search for AI/ML
- **pg_cron** - Scheduled jobs in PostgreSQL
- **pg_partman** - Table partitioning

### Deployment Dependencies

| Service            | RAM   | Est. Cost/mo |
| ------------------ | ----- | ------------ |
| n8n                | 1GB   | $5-10        |
| n8n-worker x2      | 512MB | $5-10        |
| PostgreSQL Primary | 1GB   | $10-15       |
| PostgreSQL Replica | 512MB | $5-8         |
| Redis              | 256MB | $3-5         |
| **Total**          |       | **$28-48**   |

---

## Architecture Overview

```
┌────────────────────────────────────────────────────┐
│                 Railway Project                     │
├────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  n8n    │  │ worker-1 │  │ worker-2 │  │  Task    │  │
│  │  (UI)   │  │ (queue)  │  │ (queue)  │  │  Runner  │  │
│  └────┬────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
│       │            │             │             │         │
│       ▼            ▼             ▼             ▼         │
│  ┌────────────────────────────────────────────────────┐  │
│  │                   Redis (Queue)                    │  │
│  └────────────────────────────────────────────────────┘  │
│                        │                                 │
│  ┌─────────────────────┴──────────────────────┐          │
│  │                PostgreSQL HA               │          │
│  │        ┌─────────┐      ┌─────────┐        │          │
│  │        │ Primary │────▶ │ Replica │        │          │
│  │        └─────────┘      └─────────┘        │          │
│  └─────────────────────────────────────────────┘          │
└────────────────────────────────────────────────────┘
```

---

## Configuration

### Auto-Generated Variables

| Variable                         | Description                  |
| -------------------------------- | ---------------------------- |
| `POSTGRES_PASSWORD`              | PostgreSQL password          |
| `REDIS_PASSWORD`                 | Redis password               |
| `N8N_ENCRYPTION_KEY`             | Credentials encryption       |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | User auth JWT                |
| `N8N_TASKS_RUNNER_AUTH_TOKEN`    | Secure token for Task Runner |

### Customizable Settings

| Variable                           | Default | Description                     |
| ---------------------------------- | ------- | ------------------------------- |
| `EXECUTIONS_MODE`                  | `queue` | Use `regular` for simple setups |
| `GENERIC_TIMEZONE`                 | `UTC`   | Your timezone                   |
| `N8N_CONCURRENCY_PRODUCTION_LIMIT` | `10`    | Max parallel executions/worker  |

---

## Scaling Guide

### Horizontal Scaling

| Daily Executions | Workers |
| ---------------- | ------- |
| < 1,000          | 1       |
| 1,000 - 10,000   | 2-3     |
| 10,000 - 100,000 | 5-10    |
| 100,000+         | 10+     |

Duplicate `n8n-worker` service to add more workers.

---

## Cost Comparison

| Solution          | Monthly  | Executions    |
| ----------------- | -------- | ------------- |
| Zapier Team       | $73.50   | 2,000         |
| Make.com Pro      | $16      | 10,000        |
| **This Template** | **~$35** | **Unlimited** |

---

## Getting Started

1. **Deploy** - Click the Railway button above
2. **Configure** - Set variables (auto-generated)
3. **Wait** - 3-5 minutes for full deployment
4. **Access** - Visit your n8n URL and create admin account

---

## Troubleshooting

**n8n won't start**: Check `N8N_ENCRYPTION_KEY` is set, wait for PostgreSQL to initialize.

**Workers not processing**: Verify `EXECUTIONS_MODE=queue` and Redis connection.

**Database errors**: Wait 2-3 minutes for PostgreSQL, check passwords match.

---

## Why Deploy n8n Enterprise-Ready Stack on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying n8n Enterprise-Ready Stack on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.

---

## Resources

- [n8n Documentation](https://docs.n8n.io)
- [Railway Documentation](https://docs.railway.app)
- [n8n Community](https://community.n8n.io)

---

**MIT License** | Built with ❤️ for Railway and n8n communities
