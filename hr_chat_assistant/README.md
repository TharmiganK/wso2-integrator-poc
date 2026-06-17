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
