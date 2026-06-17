# RAG Ingestion

## Overview

The RAG Ingestion integration reads HR policy documents from **Microsoft SharePoint**, generates vector embeddings using the **WSO2 AI API**, and stores them in a **Pinecone** vector database. This populates the knowledge base that the [HR Chat Assistant](../hr_chat_assistant/README.md) uses to answer HR policy questions.

## Prerequisites

- A **Microsoft SharePoint** site containing the HR policy documents, with an Entra ID (Azure AD) app registration that has `Files.Read` permissions on the site
- A **Pinecone** project and index to store the embeddings
- Access to the **WSO2 AI API** for generating embeddings

## Configuration

Open `Config.toml` and provide the following values:

### Microsoft SharePoint

| Key | Description | Example |
|---|---|---|
| `sharepointClientId` | Entra ID app registration client ID | `75b2b93c-...` |
| `sharepointClientSecret` | Entra ID app registration client secret | `08H8Q~...` |
| `sharepointTokenUrl` | OAuth 2.0 token endpoint for the tenant | `https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token` |
| `sharepointClientScope` | Microsoft Graph API scope | `https://graph.microsoft.com/.default` |
| `sharepointSiteId` | SharePoint site identifier | `globalsubs.sharepoint.com:/sites/connector-test` |
| `sharepointFilePath` | Path to the document within the SharePoint site | `ACME/HR/ACME_HR_Policy_Manual.pdf` |

### Pinecone

| Key | Description | Example |
|---|---|---|
| `pineconeApiKey` | API key for the Pinecone project | `pcsk_...` |
| `pineconeSvcUrl` | Pinecone index service URL | `https://<index>.svc.<env>.pinecone.io` |

### WSO2 AI API

| Key | Description | Example |
|---|---|---|
| `ballerina.ai.wso2ProviderConfig.serviceUrl` | WSO2 AI API endpoint URL | `https://<host>/openai` |
| `ballerina.ai.wso2ProviderConfig.accessToken` | JWT access token for the WSO2 AI API | `eyJ...` |

**Example `Config.toml`:**
```toml
[tharmigank.rag_ingestion]
sharepointClientId = "<client id>"
sharepointClientSecret = "<client secret>"
sharepointTokenUrl = "https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token"
sharepointClientScope = "https://graph.microsoft.com/.default"
sharepointSiteId = "<sharepoint site id>"
sharepointFilePath = "<path to document>"
pineconeApiKey = "<pinecone api key>"
pineconeSvcUrl = "https://<index>.svc.<env>.pinecone.io"

[ballerina.ai.wso2ProviderConfig]
serviceUrl = "<wso2 ai api url>"
accessToken = "<jwt access token>"
```

## Running the Integration

1. Ensure the Pinecone index exists and the SharePoint document is accessible
2. Open the `rag_ingestion` folder in **WSO2 Integrator**
3. Edit `Config.toml` and fill in all required values
4. Click **Run** in the WSO2 Integrator toolbar
5. The integration fetches the document, generates embeddings, and upserts them into Pinecone
