# WSO2 Integrator PoC

## Overview

This project is a proof-of-concept built with **WSO2 Integrator** demonstrating a suite of enterprise integrations. It connects internal HR systems, SAP ERP platforms, HubSpot CRM, and AI-powered services into a unified integration landscape.

The project includes the following integration capabilities:

- Exposing SAP ECC and SAP S/4HANA operations as REST APIs
- Synchronising HubSpot CRM contact data with an Oracle database
- An AI-powered HR chat assistant backed by a vector knowledge base
- An MCP (Model Context Protocol) server providing structured HR data to AI agents
- RAG (Retrieval-Augmented Generation) ingestion of HR policy documents from SharePoint
- Inbound event handling for SAP ECC IDocs and RFC calls
- Centralised log aggregation and observability via Fluent Bit and OpenSearch

## Project Structure

```
integrations/       WSO2 Integrator integration packages
infrastructure/     Supporting services (databases, UI, observability)
```

## Integrations

| Integration | Description | Type |
|---|---|---|
| [SAP Client](./integrations/sap_client/README.md) | REST API facade over SAP ECC (RFC/IDoc) and SAP S/4HANA OData | REST API |
| [HR Chat Assistant](./integrations/hr_chat_assistant/README.md) | AI-powered conversational agent for HR queries | REST API |
| [HubSpot to Oracle DB](./integrations/hubspot_to_oracledb/README.md) | Syncs HubSpot contact lifecycle events to Oracle DB | Event-driven (Webhook) |
| [MCP Server](./integrations/mcp_server/README.md) | Structured HR data provider for AI agents via MCP protocol | MCP Server |
| [RAG Ingestion](./integrations/rag_ingestion/README.md) | Ingests HR policy documents from SharePoint into Pinecone | Automation |
| [SAP ECC Events](./integrations/sap_ecc_events/README.md) | Inbound IDoc and RFC listener for SAP ECC | Event-driven (JCo) |

## Infrastructure

| Component | Description |
|---|---|
| [Fluent Bit](./infrastructure/fluent-bit/README.md) | Log aggregation and metrics forwarding to OpenSearch |
| [Oracle DB](./infrastructure/oracle-db/README.md) | Oracle Database setup scripts for HR data |
| [PostgreSQL](./infrastructure/postgres-db/README.md) | PostgreSQL setup scripts |
| [HR Chat UI](./infrastructure/hr-chat-ui/README.md) | Frontend UI for the HR Chat Assistant |

## External Systems

| System | Used By |
|---|---|
| SAP ECC (on-premise) | SAP Client, SAP ECC Events |
| SAP S/4HANA Cloud | SAP Client |
| HubSpot CRM | HubSpot to Oracle DB |
| Oracle Database | HubSpot to Oracle DB, MCP Server |
| Microsoft SharePoint | RAG Ingestion |
| Pinecone (vector DB) | RAG Ingestion, HR Chat Assistant |
| WSO2 AI API | HR Chat Assistant, RAG Ingestion |
| OpenSearch | Fluent Bit (log output) |

## Prerequisites

- **WSO2 Integrator** installed
- Access credentials for the external systems used by each integration (see individual READMEs)

## Setup

Refer to each integration's README for configuration and run instructions:

1. [SAP Client](./integrations/sap_client/README.md)
2. [HR Chat Assistant](./integrations/hr_chat_assistant/README.md)
3. [HubSpot to Oracle DB](./integrations/hubspot_to_oracledb/README.md)
4. [MCP Server](./integrations/mcp_server/README.md)
5. [RAG Ingestion](./integrations/rag_ingestion/README.md)
6. [SAP ECC Events](./integrations/sap_ecc_events/README.md)
7. [Fluent Bit](./infrastructure/fluent-bit/README.md)
