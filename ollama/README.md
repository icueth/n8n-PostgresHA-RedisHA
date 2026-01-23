# Ollama Service for n8n AI Integration

🤖 **Local AI powered by Qwen 2.5** - Run AI workflows in n8n without external API costs!

## Overview

This service provides a self-hosted LLM (Large Language Model) that integrates directly with n8n for:

- 💬 AI-powered chatbots
- 🔍 Natural language database queries
- 📝 Text summarization and generation
- 🏷️ Content classification

---

## Default Configuration

| Setting          | Value                                  |
| ---------------- | -------------------------------------- |
| **Model**        | `qwen2.5:3b`                           |
| **API Endpoint** | `http://ollama.railway.internal:11434` |
| **RAM Required** | 4GB                                    |

### Why Qwen 2.5:3b?

- ✅ **Optimized for coding** - Great for SQL generation
- ✅ **Multilingual** - Supports Thai, English, Chinese, and more
- ✅ **Balanced size** - Good performance on CPU
- ✅ **Apache 2.0 License** - Free for commercial use

---

## Connecting to n8n

### Step 1: Add Ollama Credentials

1. Open n8n UI
2. Go to **Settings** → **Credentials**
3. Click **Add Credential**
4. Search for **Ollama API**
5. Configure:

```
Base URL: http://ollama.railway.internal:11434
```

6. Click **Save**

### Step 2: Test Connection

Create a simple workflow to test:

1. Add **Manual Trigger** node
2. Add **Ollama Model** node
3. Configure:
   - **Credential**: Select your Ollama credential
   - **Model**: `qwen2.5:3b`
   - **Prompt**: `Say hello in Thai`
4. Execute workflow

Expected response: `สวัสดีครับ/ค่ะ!`

---

## Use Cases

### 🔍 1. Chat with Database

Create an AI that queries your PostgreSQL database using natural language.

**Workflow:**

```
[Chat Trigger] → [AI Agent] → [PostgreSQL Tool] → [Respond to Webhook]
```

**Setup:**

1. Add **Chat Trigger** node
2. Add **AI Agent** node:
   - Chat Model: **Ollama Chat Model**
   - Model: `qwen2.5:3b`
3. Add **Tool** → **PostgreSQL**:
   - Configure your database credentials
   - Allow: `SELECT` queries only (for safety)
4. Add **Respond to Webhook** node

**Example conversation:**

```
User: Show me top 5 customers by revenue
AI: [Generates SQL] → [Queries DB] → Returns formatted results
```

### 📝 2. Text Summarization

Summarize long documents or emails.

**Workflow:**

```
[Webhook] → [Ollama Model] → [Respond to Webhook]
```

**Prompt template:**

```
Summarize the following text in 3 bullet points:

{{ $json.text }}
```

### 🏷️ 3. Content Classification

Classify support tickets, feedback, or content.

**Workflow:**

```
[Webhook] → [Ollama Model] → [Switch] → [Different Actions]
```

**Prompt template:**

```
Classify this customer message into one category:
- billing
- technical
- general

Message: {{ $json.message }}

Reply with only the category name.
```

### 🌐 4. Translation

Translate content between languages.

**Prompt template:**

```
Translate the following Thai text to English:

{{ $json.thai_text }}
```

---

## API Reference

### Chat Completion

```bash
curl http://ollama.railway.internal:11434/api/chat \
  -d '{
    "model": "qwen2.5:3b",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

### Generate Text

```bash
curl http://ollama.railway.internal:11434/api/generate \
  -d '{
    "model": "qwen2.5:3b",
    "prompt": "Explain AI in one sentence",
    "stream": false
  }'
```

### List Models

```bash
curl http://ollama.railway.internal:11434/api/tags
```

---

## Changing Models

To use a different model, update the `OLLAMA_MODEL` environment variable in Railway:

| Model          | Size  | Best For                       |
| -------------- | ----- | ------------------------------ |
| `qwen2.5:1.5b` | 1GB   | Fast, simple tasks             |
| `qwen2.5:3b`   | 2GB   | **Default - balanced**         |
| `qwen2.5:7b`   | 4.5GB | Better quality (needs 8GB RAM) |
| `llama3.2:3b`  | 2GB   | General purpose                |
| `codellama:7b` | 4GB   | Code-focused                   |

After changing, redeploy the service. First start will download the new model.

---

## Resource Requirements

| RAM     | Cost/mo  | Performance         |
| ------- | -------- | ------------------- |
| 2GB     | ~$10     | Slow, may timeout   |
| **4GB** | **~$20** | **Recommended**     |
| 8GB     | ~$40     | Fast, larger models |

---

## Troubleshooting

### ❌ Connection refused

**Cause:** Ollama is still starting or downloading model.

**Fix:** Wait 3-5 minutes on first deploy. Check logs in Railway.

### ❌ Model not found

**Cause:** Model hasn't been pulled yet.

**Fix:** SSH into container or wait for entrypoint to complete.

### ❌ Slow responses

**Cause:** Running on CPU (no GPU on Railway).

**Fix:**

- Use smaller model (`qwen2.5:1.5b`)
- Increase RAM allocation
- Keep prompts concise

### ❌ Out of memory

**Cause:** Model too large for allocated RAM.

**Fix:**

- Increase RAM in Railway settings
- Use smaller model

---

## n8n Node Reference

| Node                    | Use Case                     |
| ----------------------- | ---------------------------- |
| **Ollama Chat Model**   | Chat conversations           |
| **Ollama Model**        | Text generation              |
| **AI Agent**            | Complex workflows with tools |
| **Text Classifier**     | Categorization               |
| **Summarization Chain** | Summarize content            |

---

## Security Notes

- 🔒 Ollama runs on Railway's **private network**
- 🔒 No external API keys needed
- 🔒 Data stays within your Railway project
- ⚠️ For database tools, use **read-only** PostgreSQL credentials

---

## Support

If this template saves you time, consider supporting the project!

[![Support Me](https://img.shields.io/badge/Support%20Me-Stripe-blue?style=for-the-badge&logo=stripe)](https://buy.stripe.com/14A28sbLa5mJ8SM5qY2VG01)
