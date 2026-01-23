#!/bin/bash
set -e

echo "🚀 Starting Ollama server..."
ollama serve &

# รอจนกว่า Ollama API จะตอบกลับ (ใช้ ollama list เช็คความพร้อม)
echo "⏳ Waiting for Ollama server to be ready..."
while ! ollama list > /dev/null 2>&1; do
    echo "..."
    sleep 3
done

echo "✅ Ollama server is up!"

MODEL_NAME="${OLLAMA_MODEL:-qwen2.5:3b}"

echo "📦 Checking model: $MODEL_NAME"
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
