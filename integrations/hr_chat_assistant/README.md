# HR Chat Assistant

## Overview

The HR Chat Assistant is an AI-powered conversational integration that allows employees to query HR policies and retrieve their personal HR data through natural language. It is backed by:

- **Pinecone** — a vector database storing embeddings of HR policy documents (ingested by the RAG Ingestion integration)
- **MCP Server** — a structured data provider for live employee HR records (leave, payslip, performance)
- **WSO2 AI API** — the LLM used to generate responses

Each conversation is scoped to the authenticated employee identified by the `user` request header.

## Endpoints

| Method | Path | Description |
|---|---|---|
| `POST` | `/chatAssistant/chat` | Send a chat message and receive an AI-generated response |

### Request

**Header:**

| Name | Type | Description |
|---|---|---|
| `user` | `integer` | The employee ID of the logged-in user |

**Body:**

```json
{
  "message": "How many annual leave days do I have remaining?",
  "sessionId": "optional-session-id-for-multi-turn-conversation"
}
```

**Response:**

```json
{
  "message": "You have 8 annual leave days remaining as of today."
}
```

## Prerequisites

- **MCP Server** integration running and accessible (see [MCP Server README](../mcp_server/README.md))
- A **Pinecone** index populated with HR policy embeddings (see [RAG Ingestion README](../rag_ingestion/README.md))
- Access to the **WSO2 AI API** with a valid access token

## Configuration

Open `Config.toml` and provide the following values:

### Pinecone

| Key | Description | Example |
|---|---|---|
| `pineconeAPIKey` | API key for the Pinecone project | `pcsk_...` |
| `pineconeSvcURL` | Pinecone index service URL | `https://<index>.svc.<env>.pinecone.io` |

### MCP Server

| Key | Description | Example |
|---|---|---|
| `mcpServerURL` | Base URL of the running MCP Server integration | `http://localhost:9092/mcp` |

### WSO2 AI API

| Key | Description | Example |
|---|---|---|
| `ballerina.ai.wso2ProviderConfig.serviceUrl` | WSO2 AI API endpoint URL | `https://<host>/openai` |
| `ballerina.ai.wso2ProviderConfig.accessToken` | JWT access token for the WSO2 AI API | `eyJ...` |

**Example `Config.toml`:**
```toml
[tharmigank.hr_chat_assistant]
pineconeAPIKey = "<pinecone api key>"
pineconeSvcURL = "https://<index>.svc.<env>.pinecone.io"
mcpServerURL = "http://localhost:9092/mcp"

[ballerina.ai.wso2ProviderConfig]
serviceUrl = "<wso2 ai api url>"
accessToken = "<jwt access token>"
```

## Running the Integration

1. Ensure the **MCP Server** is already running
2. Open the `hr_chat_assistant` folder in **WSO2 Integrator**
3. Edit `Config.toml` and fill in all required values
4. Click **Run** in the WSO2 Integrator toolbar
5. The chat API is accessible at `POST /chatAssistant/chat` on the configured host and port

---

## Appendix: Sample Config.toml

Copy this file, replace all `<...>` placeholders with your actual values. Values shown without a placeholder are fixed and should remain as-is unless noted.

```toml
[tharmigank.hr_chat_assistant]
pineconeAPIKey = "<Pinecone API key>"
pineconeSvcURL = "<Pinecone index service URL e.g. https://<index>.svc.<env>.pinecone.io>"
mcpServerURL   = "http://localhost:9092/mcp"   # keep as-is if MCP Server runs on the default port

[ballerina.ai.wso2ProviderConfig]
serviceUrl  = "<WSO2 AI API endpoint URL>"
accessToken = "<JWT access token for the WSO2 AI API>"

[wso2.icp.runtime.bridge]
environment = "dev"               # match your ICP environment name
project     = "<icp project name>"
integration = "HR Chat Assistant" # must match the integration name registered in ICP
runtime     = "<unique name for this runtime instance e.g. hostname>"
secret      = "<secret generated from ICP console>"

# ── Fixed values — do not change unless you have a specific reason ──

[ballerina.observe]
metricsLogsEnabled = true

[ballerina.log]
format = "logfmt"            # must be logfmt — required for Fluent Bit log parsing

[[ballerina.log.destinations]]
path = "./logs/app.log"      # must match the path configured in infrastructure/fluent-bit/fluent-bit.conf

[[ballerina.log.destinations]]
type = "stdout"

[ballerinax.metrics.logs]
logFilePath = "./logs/metrics.log"   # must match the path configured in infrastructure/fluent-bit/fluent-bit.conf
```
