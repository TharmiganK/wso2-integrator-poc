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
| `sharepointClientId` | Entra ID app registration client ID | `<client-id>` |
| `sharepointClientSecret` | Entra ID app registration client secret | `<client-secret>` |
| `sharepointTokenUrl` | OAuth 2.0 token endpoint for the tenant | `https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token` |
| `sharepointClientScope` | Microsoft Graph API scope | `https://graph.microsoft.com/.default` |
| `sharepointSiteId` | SharePoint site identifier | `<tenant>.sharepoint.com:/sites/<site-name>` |
| `sharepointFilePath` | Path to the document within the SharePoint site | `<folder>/<document.pdf>` |

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
[wso2.rag_ingestion]
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

---

## Appendix: Sample Config.toml

Copy this file, replace all `<...>` placeholders with your actual values. Values shown without a placeholder are fixed and should remain as-is unless noted.

```toml
[ballerina.ai.wso2ProviderConfig]
serviceUrl  = "<WSO2 AI API endpoint URL>"
accessToken = "<JWT access token for the WSO2 AI API>"

[wso2.rag_ingestion_with_sharepoint]
sharepointClientId     = "<Entra ID app registration client ID>"
sharepointClientSecret = "<Entra ID app registration client secret>"
sharepointTokenUrl     = "https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token"
sharepointClientScope  = "https://graph.microsoft.com/.default"   # keep as-is — standard Microsoft Graph scope
sharepointSiteId       = "<SharePoint site identifier e.g. tenant.sharepoint.com:/sites/site-name>"
sharepointFilePath     = "<path to the document within the SharePoint site e.g. Folder/SubFolder/document.pdf>"
pineconeApiKey         = "<Pinecone API key>"
pineconeSvcUrl         = "<Pinecone index service URL e.g. https://<index>.svc.<env>.pinecone.io>"

[wso2.icp.runtime.bridge]
environment = "dev"           # match your ICP environment name
project     = "<icp project name>"
integration = "RAG Ingestion" # must match the integration name registered in ICP
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
