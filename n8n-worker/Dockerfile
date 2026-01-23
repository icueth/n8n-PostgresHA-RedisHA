FROM n8nio/n8n:latest

# Switch to root for system configuration
USER root

# Install additional dependencies for better compatibility
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    jq \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint
COPY entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# Switch back to node user for security
USER node

# Workers don't need healthcheck on HTTP
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD pgrep -x "n8n" > /dev/null || exit 1

ENTRYPOINT ["/custom-entrypoint.sh"]
