# ใช้ Image เฉพาะสำหรับ Unified Task Runner (Python, JS)
FROM ollama/ollama:latest

# ติดตั้ง curl เพื่อใช้ตรวจสอบสถานะ API
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

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
