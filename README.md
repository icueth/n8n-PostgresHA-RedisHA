# n8n Enterprise-Ready Stack on Railway

<div align="center">

![n8n](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)

**Self-hosted Zapier Alternative with Infinite Scaling**

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/TEMPLATE_ID)

_n8n + PostgreSQL HA + Redis HA = Enterprise-Grade Automation_

</div>

---

## 🎯 Why This Template?

Most n8n deployments use SQLite which **cannot handle production workloads**. This template provides:

| Feature          | Basic n8n                  | This Template                          |
| ---------------- | -------------------------- | -------------------------------------- |
| Database         | SQLite (single-file)       | PostgreSQL HA (Primary + Replica)      |
| Caching          | None                       | Redis HA (Master + Replica + Sentinel) |
| Scaling          | ❌ None                    | ✅ Horizontal (Queue Mode + Workers)   |
| Failover         | ❌ Manual                  | ✅ Automatic                           |
| Data Safety      | ⚠️ Single point of failure | ✅ Replicated + Persistent             |
| Production Ready | ❌                         | ✅                                     |

### 💰 Target Market

- **Marketing Agencies**: Build client automation without per-task fees
- **SMEs**: Enterprise automation at self-hosted prices
- **Startups**: Scale from 0 to millions of executions
- **Enterprises**: Replace Zapier/Make.com and save thousands monthly

---

## 📊 Architecture

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                           Railway Project                                      │
├───────────────────────────────────────────────────────────────────────────────┤
│                                                                                │
│    ┌─────────────────────────────────────────────────────────────────────┐    │
│    │                         n8n Layer                                    │    │
│    │                                                                      │    │
│    │   ┌─────────────┐         ┌─────────────┐    ┌─────────────┐       │    │
│    │   │    n8n      │         │ n8n-worker  │    │ n8n-worker  │       │    │
│    │   │  (Main UI)  │         │     #1      │    │     #2      │       │    │
│    │   │  Port 5678  │         │  (Queue)    │    │  (Queue)    │       │    │
│    │   └──────┬──────┘         └──────┬──────┘    └──────┬──────┘       │    │
│    │          │                       │                  │               │    │
│    └──────────┼───────────────────────┼──────────────────┼───────────────┘    │
│               │                       │                  │                     │
│    ┌──────────┼───────────────────────┼──────────────────┼───────────────┐    │
│    │          ▼                       ▼                  ▼               │    │
│    │   ┌─────────────────────────────────────────────────────────────┐  │    │
│    │   │                     Redis HA Layer                           │  │    │
│    │   │                                                              │  │    │
│    │   │  ┌──────────────┐    ┌──────────────┐   ┌────────────────┐  │  │    │
│    │   │  │ redis-master │───▶│ redis-replica│   │ redis-sentinel │  │  │    │
│    │   │  │ (Read/Write) │    │  (Read-Only) │   │  (Monitoring)  │  │  │    │
│    │   │  │  Port 6379   │    │  Port 6379   │   │  Port 26379    │  │  │    │
│    │   │  └──────────────┘    └──────────────┘   └────────────────┘  │  │    │
│    │   │                                                              │  │    │
│    │   └─────────────────────────────────────────────────────────────┘  │    │
│    └─────────────────────────────────────────────────────────────────────┘    │
│                                                                                │
│    ┌─────────────────────────────────────────────────────────────────────┐    │
│    │                     PostgreSQL HA Layer                              │    │
│    │                                                                      │    │
│    │   ┌──────────────┐    ┌──────────────┐    ┌──────────────────────┐  │    │
│    │   │   Primary    │───▶│   Replica    │    │       Proxy          │  │    │
│    │   │ (Read/Write) │    │ (Read-Only)  │◀───│ (Load Balancing)     │  │    │
│    │   │  PostgreSQL  │    │  PostgreSQL  │    │     pgpool2          │  │    │
│    │   └──────────────┘    └──────────────┘    └──────────────────────┘  │    │
│    │                                                                      │    │
│    └─────────────────────────────────────────────────────────────────────┘    │
│                                                                                │
└───────────────────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### 1. Deploy with One Click

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/TEMPLATE_ID)

### 2. Set Required Variables

During deployment, you'll be prompted to set:

| Variable                         | Description           | Auto-Generated |
| -------------------------------- | --------------------- | -------------- |
| `POSTGRES_PASSWORD`              | PostgreSQL password   | ✅ Yes         |
| `REDIS_PASSWORD`                 | Redis password        | ✅ Yes         |
| `N8N_ENCRYPTION_KEY`             | Credential encryption | ✅ Yes         |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | JWT authentication    | ✅ Yes         |

### 3. Access n8n

After deployment (~3-5 minutes), access your n8n instance at:

```
https://n8n-production-xxxx.up.railway.app
```

Create your admin account on first visit.

---

## ⚙️ Configuration

### Environment Variables

#### n8n Service

| Variable                  | Default        | Description                     |
| ------------------------- | -------------- | ------------------------------- |
| `EXECUTIONS_MODE`         | `queue`        | Use `regular` for simple setups |
| `GENERIC_TIMEZONE`        | `Asia/Bangkok` | Your timezone                   |
| `N8N_METRICS`             | `true`         | Enable Prometheus metrics       |
| `EXECUTIONS_DATA_MAX_AGE` | `168`          | Hours to keep execution data    |
| `N8N_LOG_LEVEL`           | `info`         | Log verbosity                   |

#### Scaling (n8n-worker)

| Variable                           | Default | Description                        |
| ---------------------------------- | ------- | ---------------------------------- |
| `N8N_CONCURRENCY_PRODUCTION_LIMIT` | `10`    | Max parallel executions per worker |

### Mode Comparison

| Mode        | Best For                     | Services Needed     |
| ----------- | ---------------------------- | ------------------- |
| **Regular** | < 100 workflows, low traffic | n8n only            |
| **Queue**   | 100+ workflows, high traffic | n8n + n8n-worker(s) |

---

## 🔧 Services Breakdown

### n8n (Main Application)

- Serves the web UI
- Handles webhook triggers
- Manages workflow definitions
- **Port**: 5678

### n8n-worker (Queue Processor)

- Processes workflow executions
- Horizontally scalable (add more replicas!)
- Does NOT serve web UI
- **Note**: Only needed in Queue mode

### PostgreSQL HA

- **Primary**: Read/Write operations
- **Replica**: Read-only (data redundancy)
- **Proxy** (pgpool2): Load balancing & connection pooling

### Redis HA

- **Master**: Job queue storage
- **Replica**: Read scaling
- **Sentinel**: Automatic failover monitoring

---

## 📈 Scaling Guide

### Vertical Scaling (More Power)

Increase resources in Railway dashboard for each service.

### Horizontal Scaling (More Instances)

1. **Add more workers**:
   - Duplicate `n8n-worker` service
   - Each worker processes jobs independently

2. **Recommended worker count**:
   | Daily Executions | Workers |
   |-----------------|---------|
   | < 1,000 | 1 |
   | 1,000 - 10,000 | 2-3 |
   | 10,000 - 100,000 | 5-10 |
   | 100,000+ | 10+ |

---

## 🔌 Connecting to Services

### Internal Connection (Recommended)

For apps in the same Railway project:

```javascript
// PostgreSQL
const pgConfig = {
  host: "postgres-18-proxy.railway.internal",
  port: 5432,
  database: "n8n",
  user: "postgres",
  password: process.env.POSTGRES_PASSWORD,
};

// Redis
const redisConfig = {
  host: "redis-master.railway.internal",
  port: 6379,
  password: process.env.REDIS_PASSWORD,
};
```

### External Connection

For local development or external tools:

1. Go to the service in Railway dashboard
2. **Settings** → **Public Networking** → **TCP Proxy**
3. Use the generated domain and port

---

## 🛡️ Security Best Practices

1. **Never expose databases publicly** unless absolutely necessary
2. **Use strong passwords** (auto-generated ones are fine)
3. **Enable HTTPS** (automatic on Railway)
4. **Set up 2FA** in n8n after first login
5. **Regular backups**: Use Railway's volume snapshots

---

## 🔍 Monitoring

### n8n Metrics

Access Prometheus metrics at:

```
https://your-n8n-domain.railway.app/metrics
```

### Health Checks

| Service    | Endpoint   |
| ---------- | ---------- |
| n8n        | `/healthz` |
| PostgreSQL | pg_isready |
| Redis      | PING       |

---

## 🐛 Troubleshooting

### n8n won't start

1. Check if PostgreSQL is ready:

   ```bash
   # In n8n logs, look for:
   # "PostgreSQL is ready!"
   ```

2. Verify database connection:
   - Check `DB_POSTGRESDB_*` variables
   - Ensure n8n database exists

### Workers not processing jobs

1. Verify Redis connection
2. Check `EXECUTIONS_MODE=queue` is set
3. Verify workers are running

### Database connection issues

1. Check if proxy (pgpool) is healthy
2. Verify password matches across services
3. Check Railway internal networking

---

## 💡 Tips & Best Practices

### For Production

- ✅ Use Queue mode with 2+ workers
- ✅ Enable execution data pruning
- ✅ Set up monitoring/alerting
- ✅ Regular credential backups
- ✅ Test failover periodically

### Performance

- Use sub-workflows for complex logic
- Batch operations when possible
- Keep execution data retention reasonable
- Monitor database size

---

## 📊 Cost Estimation

| Component          | Recommended Size | ~Cost/Month       |
| ------------------ | ---------------- | ----------------- |
| n8n                | 1GB RAM          | $5-10             |
| n8n-worker x2      | 512MB each       | $5-10             |
| PostgreSQL Primary | 1GB RAM          | $10-15            |
| PostgreSQL Replica | 512MB RAM        | $5-8              |
| PostgreSQL Proxy   | 256MB RAM        | $3-5              |
| Redis Master       | 256MB RAM        | $3-5              |
| Redis Replica      | 256MB RAM        | $3-5              |
| Redis Sentinel     | 128MB RAM        | $2-3              |
| **Total**          |                  | **~$36-61/month** |

Compare to:

- Zapier Team: $73.50/month (limited)
- Make.com Pro: $16/month (10,000 ops)
- **This Stack**: Unlimited executions! 🚀

---

## 🙋 FAQ

### Can I use this without workers?

Yes! Set `EXECUTIONS_MODE=regular` and don't deploy `n8n-worker`.

### How do I backup my workflows?

1. Use n8n's built-in export
2. Railway volume snapshots
3. pg_dump for database

### Can I add more replicas?

Absolutely! Duplicate services in Railway dashboard.

### Is this production-ready?

Yes! This stack is designed for enterprise workloads with:

- Automatic failover
- Data replication
- Horizontal scaling
- Professional monitoring

---

## 🤝 Support

- **n8n Documentation**: [docs.n8n.io](https://docs.n8n.io)
- **Railway Docs**: [docs.railway.app](https://docs.railway.app)
- **Community**: [community.n8n.io](https://community.n8n.io)

---

## 📝 License

MIT License - Use freely for personal and commercial projects.

---

<div align="center">

**Built with ❤️ by iCue**

_Star ⭐ this template if it helped you!_

</div>
