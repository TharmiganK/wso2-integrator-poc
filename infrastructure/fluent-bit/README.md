# Fluent Bit — Log Aggregation

## Overview

The Fluent Bit configuration collects structured application logs and metrics from all WSO2 Integrator integrations in this project and forwards them to **OpenSearch** for centralised observability. Each integration writes logs to a local file; Fluent Bit tails those files, parses the Ballerina logfmt format, and indexes them into OpenSearch.

Two log streams are handled:

- **Application logs** — indexed into `ballerina-application-logs`
- **Metrics logs** — indexed into `ballerina-metrics-logs`

## Integrations Monitored

| Integration | App Log Path | Metrics Log Path |
|---|---|---|
| SAP Client | `integrations/sap_client/logs/app.log` | `integrations/sap_client/logs/metrics.log` |
| HR Chat Assistant | `integrations/hr_chat_assistant/logs/app.log` | `integrations/hr_chat_assistant/logs/metrics.log` |
| HubSpot to Oracle DB | `integrations/hubspot_to_oracledb/logs/app.log` | `integrations/hubspot_to_oracledb/logs/metrics.log` |
| MCP Server | `integrations/mcp_server/logs/app.log` | `integrations/mcp_server/logs/metrics.log` |
| RAG Ingestion | `integrations/rag_ingestion/logs/app.log` | `integrations/rag_ingestion/logs/metrics.log` |
| SAP ECC Events | `integrations/sap_ecc_events/logs/app.log` | `integrations/sap_ecc_events/logs/metrics.log` |

## Prerequisites

- **Fluent Bit** installed on the same host as the integrations
- A running **OpenSearch** instance accessible from the host

## Configuration

Edit `fluent-bit/fluent-bit.conf` to update the OpenSearch connection settings:

| Setting | Description | Default |
|---|---|---|
| `Host` | OpenSearch hostname | `localhost` |
| `Port` | OpenSearch port | `9200` |
| `HTTP_User` | OpenSearch username | `admin` |
| `HTTP_Passwd` | OpenSearch password | `YourStrong@Pass2026` |
| `tls.verify` | TLS certificate verification | `Off` |

Log file paths in the `[INPUT]` sections default to paths relative to the project root. Update these if the project is located in a different directory.

## Running Fluent Bit

1. Ensure all integrations are running and writing to their respective `logs/` directories
2. From the `fluent-bit/` directory, run Fluent Bit with the provided configuration:

   ```
   fluent-bit -c fluent-bit.conf
   ```

3. Logs from all integrations will begin flowing into OpenSearch under the configured indices
