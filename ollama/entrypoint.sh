#!/bin/bash
set -e

echo "🚀 Starting Ollama server..."

# Start Ollama in the background
ollama serve &

# Wait for Ollama to be ready
echo "⏳ Waiting for Ollama to be ready..."
sleep 10

# Check if model is already pulled, if not pull it
MODEL_NAME="${OLLAMA_MODEL:-llama3.2:3b}"

echo "📦 Checking model: $MODEL_NAME"
if ! ollama list | grep -q "$MODEL_NAME"; then
    echo "📥 Pulling model: $MODEL_NAME (this may take a few minutes)..."
    ollama pull "$MODEL_NAME"
    echo "✅ Model $MODEL_NAME pulled successfully!"
else
    echo "✅ Model $MODEL_NAME already exists"
fi

echo "🎉 Ollama is ready!"
echo "📡 API available at: http://0.0.0.0:11434"
echo "🤖 Default model: $MODEL_NAME"

# Keep container running
wait
