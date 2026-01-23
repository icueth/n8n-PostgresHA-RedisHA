FROM n8nio/n8n:latest

# Switch to root for system configuration
USER root

# Copy custom entrypoint
COPY entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# Switch back to node user for security
USER node

# Workers check by trying to reach main n8n or just run
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD ps aux | grep -v grep | grep -q n8n || exit 1

ENTRYPOINT ["/custom-entrypoint.sh"]
