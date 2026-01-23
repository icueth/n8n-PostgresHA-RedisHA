# Ollama for n8n AI Integration
# Lightweight setup for Railway (CPU mode)

FROM ollama/ollama:latest

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/root/.ollama
ENV OLLAMA_KEEP_ALIVE=24h

# Expose Ollama API port
EXPOSE 11434

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
