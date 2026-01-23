FROM n8nio/n8n:latest

# Switch to root for system configuration
USER root

# Copy custom entrypoint
COPY entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# Switch back to node user for security
USER node

ENTRYPOINT ["/custom-entrypoint.sh"]
