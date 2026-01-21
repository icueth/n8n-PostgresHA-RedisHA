#!/bin/bash
# Sentinel check script for HAProxy external-check
# This script queries Sentinel to verify the current master

SENTINEL_HOST="${SENTINEL_HOST:-redis-sentinel.railway.internal}"
SENTINEL_PORT="${SENTINEL_PORT:-26379}"
SENTINEL_MASTER_NAME="${SENTINEL_MASTER_NAME:-mymaster}"
REDIS_PASSWORD="${REDIS_PASSWORD}"

# Get master info from Sentinel
MASTER_INFO=$(redis-cli -h "$SENTINEL_HOST" -p "$SENTINEL_PORT" -a "$REDIS_PASSWORD" \
    SENTINEL master "$SENTINEL_MASTER_NAME" 2>/dev/null)

if [ -z "$MASTER_INFO" ]; then
    exit 1
fi

# Check if master is up
MASTER_STATUS=$(echo "$MASTER_INFO" | grep -A1 "^flags" | tail -1)
if [[ "$MASTER_STATUS" == *"master"* ]] && [[ "$MASTER_STATUS" != *"s_down"* ]] && [[ "$MASTER_STATUS" != *"o_down"* ]]; then
    exit 0
else
    exit 1
fi
