#!/bin/bash
set -e

echo "🚀 Starting Ollama server..."
ollama serve &

# รอจนกว่า Ollama API จะตอบกลับ (Port 11434 พร้อมใช้งาน)
echo "⏳ Waiting for Ollama API to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 2
done

MODEL_NAME="${OLLAMA_MODEL:-qwen2.5:3b}"

echo "📦 Checking model: $MODEL_NAME"
# ใช้ grep -w เพื่อเช็คชื่อ model ให้แม่นยำขึ้น
if ! ollama list | grep -q "$MODEL_NAME"; then
    echo "📥 Pulling model: $MODEL_NAME (This may take a few minutes)..."
    if ollama pull "$MODEL_NAME"; then
        echo "✅ Model $MODEL_NAME pulled successfully!"
    else
        echo "❌ Failed to pull model $MODEL_NAME"
        exit 1
    fi
else
    echo "✅ Model $MODEL_NAME already exists"
fi

echo "🎉 Ollama is ready and model $MODEL_NAME is loaded!"
wait
