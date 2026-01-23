# Deploy and Host n8n Enterprise-Ready Stack on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/YOUR_TEMPLATE_ID)

**n8n Enterprise-Ready Stack** is a production-grade, self-hosted workflow automation platform that combines n8n with PostgreSQL High Availability and Redis for queue management. This template provides infinite horizontal scaling, automatic failover, and enterprise-level reliability—all deployed with a single click on Railway.

---

## ✨ About Hosting n8n Enterprise-Ready Stack

Deploying n8n in production requires more than just the base application. You need a robust database that won't lose your workflow data, a queue system for handling high-volume executions, and the ability to scale workers as your automation needs grow.

This template solves all of these challenges by providing a complete, pre-configured infrastructure stack:

- **PostgreSQL HA** with Primary-Replica replication for data redundancy
- **Redis** for queue-based execution enabling horizontal scaling
- **n8n Main Instance** serving the web UI and handling webhooks
- **n8n Workers** processing workflow executions in parallel

The entire stack deploys automatically on Railway with proper networking, health checks, and restart policies configured out of the box.

---

## 🎯 Common Use Cases

### 1. Marketing Automation at Scale

- Sync leads between CRM, email marketing, and ad platforms in real-time
- Process thousands of webhook events from landing pages and forms
- Automate multi-channel campaign workflows across Mailchimp, HubSpot, and Salesforce
- Build custom integrations that Zapier doesn't offer

### 2. E-Commerce Operations

- Automate order processing, inventory updates, and shipping notifications
- Sync product data across Shopify, WooCommerce, and marketplace platforms
- Process customer support tickets and automate response workflows
- Build custom checkout automation with payment provider integrations

### 3. Data Pipeline & ETL

- Extract data from APIs, databases, and file sources on schedule
- Transform and clean data using built-in functions or custom code
- Load processed data into data warehouses, dashboards, or reporting tools
- Monitor pipeline health with error notifications and retry logic

### 4. DevOps & IT Automation

- Automate deployment notifications to Slack, Discord, or Teams
- Process GitHub/GitLab webhooks for CI/CD orchestration
- Monitor server health and trigger alerts or auto-remediation
- Sync issues across Jira, Linear, Notion, and project management tools

### 5. AI & LLM Workflows

- Build RAG (Retrieval Augmented Generation) pipelines with vector databases
- Automate content generation with OpenAI, Anthropic, or local LLMs
- Create chatbots and AI agents that integrate with your existing tools
- Process documents with OCR, summarization, and classification

### 6. Internal Tools & Business Processes

- Automate employee onboarding workflows across HR systems
- Build approval workflows for purchase orders and expense reports
- Sync data between Google Workspace, Microsoft 365, and internal databases
- Create custom dashboards and reporting automation

---

## 📦 Dependencies for n8n Enterprise-Ready Stack Hosting

### Core Dependencies

| Dependency     | Version | Purpose                          |
| -------------- | ------- | -------------------------------- |
| **n8n**        | Latest  | Workflow automation engine       |
| **PostgreSQL** | 18      | Primary database with extensions |
| **Redis**      | 7.4     | Queue management for workers     |

### PostgreSQL Extensions Included

This template comes with powerful PostgreSQL extensions pre-installed:

- **PostGIS** - Geospatial data types and functions
- **pgvector** - Vector similarity search for AI/ML workloads
- **pg_cron** - Schedule jobs directly in PostgreSQL
- **pg_partman** - Automatic table partitioning for large datasets
- **uuid-ossp** - Native UUID generation
- **pg_stat_statements** - Query performance monitoring
- **pg_trgm** - Fuzzy text search and similarity matching

### Deployment Dependencies

This template requires Railway's infrastructure with the following configuration:

| Service            | Recommended RAM | Recommended CPU |
| ------------------ | --------------- | --------------- |
| n8n (Main)         | 1GB             | 0.5 vCPU        |
| n8n-worker (x2)    | 512MB each      | 0.25 vCPU       |
| PostgreSQL Primary | 1GB             | 0.5 vCPU        |
| PostgreSQL Replica | 512MB           | 0.25 vCPU       |
| Redis              | 256MB           | 0.1 vCPU        |

**Estimated Monthly Cost**: $25-45/month (varies by usage)

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Railway Project                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │                    n8n Layer                             │   │
│   │                                                          │   │
│   │   ┌─────────────┐    ┌─────────────┐  ┌─────────────┐   │   │
│   │   │    n8n      │    │ n8n-worker  │  │ n8n-worker  │   │   │
│   │   │  (Main UI)  │    │     #1      │  │     #2      │   │   │
│   │   │ Port 5678   │    │   (Queue)   │  │   (Queue)   │   │   │
│   │   └──────┬──────┘    └──────┬──────┘  └──────┬──────┘   │   │
│   └──────────┼──────────────────┼─────────────────┼─────────┘   │
│              │                  │                 │              │
│              ▼                  ▼                 ▼              │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │                    Redis Layer                           │   │
│   │                                                          │   │
│   │                    ┌──────────────┐                      │   │
│   │                    │    Redis     │                      │   │
│   │                    │   (Queue)    │                      │   │
│   │                    │  Port 6379   │                      │   │
│   │                    └──────────────┘                      │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │                PostgreSQL HA Layer                       │   │
│   │                                                          │   │
│   │   ┌──────────────┐    ┌──────────────┐                  │   │
│   │   │   Primary    │───▶│   Replica    │                  │   │
│   │   │ (Read/Write) │    │ (Read-Only)  │                  │   │
│   │   │  PostgreSQL  │    │  PostgreSQL  │                  │   │
│   │   └──────────────┘    └──────────────┘                  │   │
│   │                                                          │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### How It Works

1. **n8n Main Instance** handles the web UI, webhook endpoints, and orchestrates workflow executions
2. **n8n Workers** pull jobs from Redis queue and execute workflows in parallel
3. **PostgreSQL Primary** stores all workflow definitions, credentials, and execution data
4. **PostgreSQL Replica** provides read-only access and data redundancy
5. **Redis** manages the job queue for distributed execution across workers

---

## � Configuration

### Environment Variables

The template automatically generates secure values for sensitive configuration. You can customize these in Railway's Variables panel:

| Variable                         | Description                    | Auto-Generated |
| -------------------------------- | ------------------------------ | -------------- |
| `POSTGRES_PASSWORD`              | PostgreSQL database password   | ✅ Yes         |
| `REDIS_PASSWORD`                 | Redis authentication password  | ✅ Yes         |
| `N8N_ENCRYPTION_KEY`             | Encryption key for credentials | ✅ Yes         |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | JWT secret for user auth       | ✅ Yes         |

### Customizable Settings

| Variable                           | Default | Description                        |
| ---------------------------------- | ------- | ---------------------------------- |
| `EXECUTIONS_MODE`                  | `queue` | Use `regular` for simple setups    |
| `GENERIC_TIMEZONE`                 | `UTC`   | Your preferred timezone            |
| `N8N_CONCURRENCY_PRODUCTION_LIMIT` | `10`    | Max parallel executions per worker |
| `EXECUTIONS_DATA_MAX_AGE`          | `168`   | Hours to keep execution history    |

---

## 📈 Scaling Guide

### Vertical Scaling (More Power per Instance)

Increase RAM and CPU for each service in Railway's settings panel when you need more processing power per execution.

### Horizontal Scaling (More Workers)

Add more n8n-worker instances to handle higher execution volumes:

| Daily Executions | Recommended Workers |
| ---------------- | ------------------- |
| < 1,000          | 1 worker            |
| 1,000 - 10,000   | 2-3 workers         |
| 10,000 - 100,000 | 5-10 workers        |
| 100,000+         | 10+ workers         |

To add more workers, duplicate the `n8n-worker` service in Railway and it will automatically connect to the same queue.

---

## 💰 Cost Comparison

| Solution          | Monthly Cost | Executions    | Limitations           |
| ----------------- | ------------ | ------------- | --------------------- |
| Zapier Team       | $73.50       | 2,000 tasks   | Per-task pricing      |
| Make.com Pro      | $16          | 10,000 ops    | Per-operation pricing |
| n8n Cloud Pro     | $50          | 10,000 exec   | Vendor lock-in        |
| **This Template** | ~$35         | **Unlimited** | Self-hosted control   |

**Save thousands annually** while maintaining full control over your data and automation infrastructure.

---

## 🚀 Getting Started

### 1. One-Click Deploy

Click the button below to deploy the entire stack to Railway:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/YOUR_TEMPLATE_ID)

### 2. Configure Variables

Railway will prompt you to set the required variables. Secure values are auto-generated for you.

### 3. Wait for Deployment

The stack takes approximately 3-5 minutes to fully deploy. PostgreSQL needs to initialize before n8n can connect.

### 4. Access n8n

Once deployed, access your n8n instance at:

```
https://n8n-production-xxxx.up.railway.app
```

Create your admin account on first login.

---

## 🛡️ Security Features

- **Encrypted Credentials**: All sensitive data encrypted at rest with your unique encryption key
- **HTTPS Enforced**: All traffic encrypted in transit via Railway's SSL
- **Secure Cookies**: HTTP-only, secure cookies for session management
- **Private Networking**: Internal services communicate over Railway's private network
- **No Public Database Access**: PostgreSQL and Redis are not exposed to the internet

---

## 🔍 Monitoring & Observability

### Built-in Metrics

n8n exposes Prometheus-compatible metrics at `/metrics`:

```
https://your-n8n-domain.railway.app/metrics
```

### Health Endpoints

| Service    | Health Check   |
| ---------- | -------------- |
| n8n        | `GET /healthz` |
| PostgreSQL | `pg_isready`   |
| Redis      | `PING`         |

---

## 🐛 Troubleshooting

### n8n won't start

1. Check Railway deploy logs for error messages
2. Verify `N8N_ENCRYPTION_KEY` is set
3. Ensure PostgreSQL is healthy before n8n starts

### Workers not processing

1. Verify `EXECUTIONS_MODE=queue` is set
2. Check Redis connection in worker logs
3. Ensure workers have the same `N8N_ENCRYPTION_KEY`

### Database connection errors

1. Wait 2-3 minutes for PostgreSQL to fully initialize
2. Check `POSTGRES_PASSWORD` matches across services
3. Verify PostgreSQL service is healthy in Railway

---

## � Resources

- **n8n Documentation**: [docs.n8n.io](https://docs.n8n.io)
- **Railway Documentation**: [docs.railway.app](https://docs.railway.app)
- **n8n Community**: [community.n8n.io](https://community.n8n.io)
- **Template Source**: [GitHub Repository](https://github.com/your-repo)

---

## Why Deploy n8n Enterprise-Ready Stack on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying n8n Enterprise-Ready Stack on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.

### Railway Benefits for n8n

- **One-Click Deployment**: No DevOps knowledge required
- **Automatic SSL**: HTTPS enabled out of the box
- **Private Networking**: Services communicate securely
- **Instant Scaling**: Add resources or workers in seconds
- **Pay-as-you-go**: Only pay for what you use
- **Global Regions**: Deploy close to your users

---

## 📝 License

This template is released under the MIT License. n8n Community Edition is fair-source licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).

---

<div align="center">

**Built with ❤️ for the Railway and n8n communities**

⭐ Star this template if it helped you!

[Deploy Now](https://railway.app/template/YOUR_TEMPLATE_ID) | [Report Issues](https://github.com/your-repo/issues) | [Contribute](https://github.com/your-repo)

</div>
