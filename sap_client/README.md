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
| `sapEccHost` | Hostname or IP address of the SAP ECC application server | `54.205.90.79` |
| `sapEccSysnr` | SAP system number (two digits) | `00` |
| `sapEccClientNum` | SAP client (Mandant) number | `800` |
| `sapEccUser` | SAP logon username | `TEST_USER` |
| `sapEccPasswd` | SAP logon password | `User@123` |

### SAP S/4HANA Connection

| Key | Description | Example |
|---|---|---|
| `sapS4hanaHostName` | Hostname of the SAP S/4HANA Cloud tenant | `my401785.s4hana.cloud.sap` |
| `sapS4hanaUserName` | SAP S/4HANA username | `THARMI` |
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
[tharmigank.sap_client]
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
