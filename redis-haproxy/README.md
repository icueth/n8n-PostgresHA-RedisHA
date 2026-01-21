# Redis HAProxy - Sentinel-Aware Proxy

This service provides a Sentinel-aware proxy for Redis, enabling n8n to connect to a single endpoint while getting automatic failover when the Redis master changes.

## How It Works

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│    n8n      │────▶│ Redis HAProxy│────▶│ Redis Master │
│  (clients)  │     │  (proxy)     │     │  (current)   │
└─────────────┘     └──────┬───────┘     └──────────────┘
                           │
                           │ Queries for current master
                           ▼
                    ┌──────────────┐
                    │   Sentinel   │
                    │ (monitoring) │
                    └──────────────┘
```

## Features

1. **Sentinel Integration**: Discovers current master from Sentinel
2. **Auto-Failover**: Detects master changes and updates routing
3. **Health Checks**: TCP-based Redis PING/PONG verification
4. **Stats Dashboard**: Available at port 8404

## Environment Variables

| Variable               | Required | Default  | Description                   |
| ---------------------- | -------- | -------- | ----------------------------- |
| `SENTINEL_HOST`        | Yes      | -        | Sentinel service hostname     |
| `SENTINEL_PORT`        | No       | 26379    | Sentinel port                 |
| `SENTINEL_MASTER_NAME` | No       | mymaster | Sentinel master name          |
| `REDIS_PASSWORD`       | Yes      | -        | Redis authentication password |
| `HAPROXY_PORT`         | No       | 6379     | HAProxy listen port           |

## Connection

### From n8n:

```env
QUEUE_BULL_REDIS_HOST=redis-haproxy.railway.internal
QUEUE_BULL_REDIS_PORT=6379
QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
```

### Stats Dashboard:

```
http://redis-haproxy.railway.internal:8404/stats
```

## Failover Process

1. Sentinel detects master failure
2. Sentinel promotes replica to new master
3. HAProxy background monitor detects change
4. HAProxy config is regenerated with new master
5. HAProxy reloads (graceful, no connection drop)
6. n8n continues without knowing failover happened ✅
