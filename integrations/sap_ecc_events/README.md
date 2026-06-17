# SAP ECC Events

## Overview

The SAP ECC Events integration registers as a JCo server on the **SAP ECC** gateway to receive inbound events from SAP. It handles two types of inbound communications:

- **IDoc events** — receives ORDERS05 (purchase order) IDocs sent from SAP ECC
- **RFC calls** — handles RFC function module calls from SAP ECC (currently supports `STFC_CONNECTION` for connectivity testing)

## Event Handlers

### IDoc Service

| IDoc Type | Description |
|---|---|
| `ORDERS05` | Inbound purchase order IDoc — extracts the PO number, line item count, and sender, then logs the details |

### RFC Service

| Function Module | Description |
|---|---|
| `STFC_CONNECTION` | SAP connectivity test — echoes back the `REQUTEXT` input and returns `"Responded by Integrator"` as `RESPTEXT` |

## Prerequisites

- An **SAP ECC** system with:
  - A configured RFC destination pointing to this integration (program ID must match `progid`)
  - Port definition for the gateway (`gwhost`, `gwserv`)
  - An IDoc partner profile configured to route ORDERS05 IDocs to this program ID
- SAP JCo native libraries present in `resources/` (`sapjco3.jar`, `sapidoc3.jar`, `libsapjco3.dylib`)

## Configuration

Open `Config.toml` and provide the following values under the `sapConfig` record:

### SAP JCo Server

| Key | Description | Example |
|---|---|---|
| `sapConfig.gwhost` | Hostname or IP of the SAP ECC gateway | `54.205.90.79` |
| `sapConfig.gwserv` | SAP gateway service name or port | `sapgw00` |
| `sapConfig.progid` | Program ID registered in the SAP RFC destination | `TEST_LISTENER` |
| `sapConfig.connectionCount` | Number of concurrent JCo server connections | `2` |

### SAP Repository Destination (used to fetch metadata from SAP)

| Key | Description | Example |
|---|---|---|
| `sapConfig.repositoryDestination.ashost` | SAP application server hostname | `54.205.90.79` |
| `sapConfig.repositoryDestination.sysnr` | SAP system number | `00` |
| `sapConfig.repositoryDestination.jcoClient` | SAP client number | `800` |
| `sapConfig.repositoryDestination.user` | SAP logon username | `TEST_USER` |
| `sapConfig.repositoryDestination.passwd` | SAP logon password | `••••••••` |

**Example `Config.toml`:**
```toml
[tharmigank.sap_ecc_events.sapConfig]
gwhost = "<gateway host>"
gwserv = "sapgw00"
progid = "<program id>"
connectionCount = 2

[tharmigank.sap_ecc_events.sapConfig.repositoryDestination]
ashost = "<sap host>"
sysnr = "00"
jcoClient = "800"
user = "<username>"
passwd = "<password>"
```

## Running the Integration

1. Ensure the SAP ECC RFC destination and partner profile are configured to point to this program ID
2. Open the `sap_ecc_events` folder in **WSO2 Integrator**
3. Edit `Config.toml` and fill in all required values
4. Click **Run** in the WSO2 Integrator toolbar
5. The integration registers with the SAP gateway and starts listening for inbound IDocs and RFC calls

---

## Appendix: Sample Config.toml

Copy this file, replace all `<...>` placeholders with your actual values. Values shown without a placeholder are fixed and should remain as-is unless noted.

```toml
[tharmigank.sap_ecc_events.sapConfig]
gwhost          = "<SAP ECC gateway hostname or IP>"
gwserv          = "sapgw00"   # standard SAP gateway service name; change only if your system uses a different service
progid          = "<program ID registered in the SAP RFC destination>"
connectionCount = 2           # number of concurrent JCo server connections; increase for higher throughput

[tharmigank.sap_ecc_events.sapConfig.repositoryDestination]
ashost    = "<SAP ECC application server hostname or IP>"
sysnr     = "<SAP system number e.g. 00>"
jcoClient = "<SAP client/Mandant number e.g. 800>"
user      = "<SAP logon username>"
passwd    = "<SAP logon password>"

[wso2.icp.runtime.bridge]
environment = "dev"            # match your ICP environment name
project     = "<icp project name>"
integration = "SAP ECC Events" # must match the integration name registered in ICP
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
