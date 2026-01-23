# Ollama Service for n8n AI Integration

This service provides Ollama LLM capabilities for n8n workflows.

## Features

- 🤖 Local LLM running on Railway
- 🔗 Direct integration with n8n AI nodes
- 💾 Persistent model storage
- 🚀 Auto-pulls model on first start

## Configuration

| Variable       | Default       | Description                      |
| -------------- | ------------- | -------------------------------- |
| `OLLAMA_MODEL` | `llama3.2:3b` | Model to use (see options below) |

## Recommended Models for Railway (CPU)

| Model         | Size  | RAM Required | Best For                     |
| ------------- | ----- | ------------ | ---------------------------- |
| `llama3.2:1b` | 1.3GB | 2GB          | Fast responses, simple tasks |
| `llama3.2:3b` | 2.0GB | 4GB          | **Balanced (recommended)**   |
| `qwen2.5:3b`  | 1.9GB | 4GB          | Good for coding              |
| `gemma2:2b`   | 1.6GB | 3GB          | Fast, Google's model         |

## n8n Integration

### 1. Add Ollama Credentials in n8n

1. Go to **Credentials** → **Add Credential**
2. Search for **Ollama**
3. Set **Base URL**: `http://ollama.railway.internal:11434`

### 2. Use in AI Workflows

n8n nodes that support Ollama:

- **AI Agent** - Create conversational agents
- **Chat Model** - Use as LLM in chains
- **Text Classifier** - Classify text
- **Summarization Chain** - Summarize content

### 3. Example: Chat with Database

```
[Chat Trigger] → [AI Agent] → [PostgreSQL Tool] → [Response]
```

The AI Agent can:

- Understand natural language queries
- Generate SQL queries
- Return formatted results

## Resource Requirements

| Config      | RAM | Monthly Cost |
| ----------- | --- | ------------ |
| Minimum     | 2GB | ~$10         |
| Recommended | 4GB | ~$20         |

## Troubleshooting

**Model won't load**: Increase RAM in Railway service settings.

**Slow responses**: This is expected on CPU. Consider smaller model.

**Connection refused**: Wait 2-3 minutes for model to download on first start.
