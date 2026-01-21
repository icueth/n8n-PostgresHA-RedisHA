FROM haproxy:2.9-alpine

# Install required tools for Sentinel discovery
RUN apk add --no-cache \
    bash \
    redis \
    curl \
    gettext

# Copy configuration files
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.template
COPY entrypoint.sh /entrypoint.sh
COPY sentinel-check.sh /usr/local/bin/sentinel-check.sh

RUN chmod +x /entrypoint.sh /usr/local/bin/sentinel-check.sh

EXPOSE 6379

ENTRYPOINT ["/entrypoint.sh"]
