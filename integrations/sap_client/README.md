# SAP Client

## Overview

The SAP Client integration exposes SAP ECC and SAP S/4HANA operations as a unified REST API. It connects to **SAP ECC** via the JCo RFC/IDoc protocol for employee leave queries, customer master creation, and purchase order submission, and to **SAP S/4HANA Cloud** via the OData API for sales order creation.

## Endpoints

| Method | Path | Description |
|---|---|---|
| `GET` | `/sap/ecc/employees/{employeeId}/leaves` | Retrieve employee leave details from SAP ECC via RFC (BAPI_ABSENCE_GETDETAILEDLIST). Query params: `dateFrom`, `dateTo`, `absenceType` |
| `POST` | `/sap/ecc/cutomers` | Create a customer master record in SAP ECC via IDoc (DEBMAS06) |
| `POST` | `/sap/ecc/orders` | Create a purchase order in SAP ECC via IDoc (ORDERS05) |
| `POST` | `/sap/s4hana/sales-orders` | Create a sales order in SAP S/4HANA via OData API |

## Prerequisites

- Access to an **SAP ECC** system with RFC and IDoc enabled
- Access to an **SAP S/4HANA Cloud** tenant with the Sales Order OData API enabled
- SAP JCo native libraries present in `resources/` (`sapjco3.jar`, `sapidoc3.jar`, `libsapjco3.dylib`)

## Configuration

Open `Config.toml` and provide the following values:

### SAP ECC Connection

| Key | Description | Example |
|---|---|---|
| `sapEccHost` | Hostname or IP address of the SAP ECC application server | `<host>` |
| `sapEccSysnr` | SAP system number (two digits) | `00` |
| `sapEccClientNum` | SAP client (Mandant) number | `800` |
| `sapEccUser` | SAP logon username | `<username>` |
| `sapEccPasswd` | SAP logon password | `<password>` |

### SAP S/4HANA Connection

| Key | Description | Example |
|---|---|---|
| `sapS4hanaHostName` | Hostname of the SAP S/4HANA Cloud tenant | `<tenant>.s4hana.cloud.sap` |
| `sapS4hanaUserName` | SAP S/4HANA username | `<username>` |
| `sapS4hanaPassword` | SAP S/4HANA password | `••••••••` |

### IDoc Control Records

Both `idocDebmasControlRecord` and `idocOrdersControlRecord` are inline records that identify the logical system names for IDoc routing:

| Key | Field | Description | Example |
|---|---|---|---|
| `idocDebmasControlRecord` | `SNDPRN` | Sending logical system (partner number) for DEBMAS IDocs | `TESTLS` |
| `idocDebmasControlRecord` | `RCVPRN` | Receiving logical system (partner number) for DEBMAS IDocs | `ABAPCLNT800` |
| `idocOrdersControlRecord` | `SNDPRN` | Sending logical system (partner number) for ORDERS IDocs | `TESTLS` |
| `idocOrdersControlRecord` | `RCVPRN` | Receiving logical system (partner number) for ORDERS IDocs | `ABAPCLNT800` |

**Example `Config.toml`:**
```toml
[wso2.sap_client]
sapEccHost = "<ECC host>"
sapEccSysnr = "00"
sapEccClientNum = "800"
sapEccUser = "<username>"
sapEccPasswd = "<password>"
sapS4hanaHostName = "<s4hana host>"
sapS4hanaUserName = "<username>"
sapS4hanaPassword = "<password>"
idocDebmasControlRecord = {SNDPRN = "<sender>", RCVPRN = "<receiver>"}
idocOrdersControlRecord = {SNDPRN = "<sender>", RCVPRN = "<receiver>"}
```

## Running the Integration

1. Open the `sap_client` folder in **WSO2 Integrator**
2. Edit `Config.toml` and fill in all required values
3. Click **Run** in the WSO2 Integrator toolbar
4. The integration starts and the REST API is accessible on the configured host and port

---

## Appendix: Sample Config.toml

Copy this file, replace all `<...>` placeholders with your actual values. Values shown without a placeholder are fixed and should remain as-is unless noted.

```toml
[wso2.sap_client]
sapEccHost      = "<SAP ECC application server hostname or IP>"
sapEccSysnr     = "<SAP system number e.g. 00>"
sapEccClientNum = "<SAP client/Mandant number e.g. 800>"
sapEccUser      = "<SAP logon username>"
sapEccPasswd    = "<SAP logon password>"
sapS4hanaHostName = "<SAP S/4HANA Cloud hostname e.g. my123456.s4hana.cloud.sap>"
sapS4hanaUserName = "<SAP S/4HANA username>"
sapS4hanaPassword = "<SAP S/4HANA password>"

[wso2.sap_client.idocDebmasControlRecord]
SNDPRN = "<sending logical system name for DEBMAS IDocs>"
RCVPRN = "<receiving logical system name for DEBMAS IDocs>"

[wso2.sap_client.idocOrdersControlRecord]
SNDPRN = "<sending logical system name for ORDERS IDocs>"
RCVPRN = "<receiving logical system name for ORDERS IDocs>"

[wso2.icp.runtime.bridge]
environment = "dev"          # match your ICP environment name
project     = "<icp project name>"
integration = "SAP Client"   # must match the integration name registered in ICP
runtime     = "<unique name for this runtime instance e.g. hostname>"
secret      = "<secret generated from ICP console>"

# ── Fixed values — do not change unless you have a specific reason ──

[ballerina.http]
defaultListenerPort = 9091   # HTTP port this integration listens on; change only if there is a port conflict

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
