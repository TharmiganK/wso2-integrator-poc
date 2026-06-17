# MCP Server

## Overview

The MCP Server integration exposes structured employee HR data via the **Model Context Protocol (MCP)**, making it available to AI agents such as the [HR Chat Assistant](../hr_chat_assistant/README.md). It reads from an **Oracle Database** and provides four callable functions covering employee profiles, leave and payroll, performance reviews, and leave request management.

The MCP service listens on port **9092** at the path `/mcp`.

## MCP Functions

| Function | Description |
|---|---|
| `getMyProfile(empId)` | Returns the employee's identity, job title, grade, department, manager, service length, and employment status |
| `getLeaveAndPayslip(empId)` | Returns current-year leave balances, the 10 most recent leave requests, and the latest payslip with salary components |
| `getPerformanceAndTraining(empId)` | Returns performance reviews from the current and previous year, all training records and certifications, and total L&D spend for the current year |
| `submitOrCancelLeave(empId, action, ...)` | Submits a new leave request (`action: SUBMIT`) or cancels a pending one (`action: CANCEL`) after validating leave balances |

### `submitOrCancelLeave` Parameters

| Parameter | Required for | Description |
|---|---|---|
| `empId` | Both | Employee ID |
| `action` | Both | `SUBMIT` or `CANCEL` |
| `leave_type` | SUBMIT | Leave type (e.g. `ANNUAL`, `SICK`) |
| `start_date` | SUBMIT | Start date in `YYYY-MM-DD` format |
| `end_date` | SUBMIT | End date in `YYYY-MM-DD` format |
| `days_count` | SUBMIT | Number of days requested |
| `reason` | SUBMIT | Reason for the leave |
| `request_id` | CANCEL | ID of the pending leave request to cancel |

## Prerequisites

- An **Oracle Database** instance with the HR schema provisioned (views: `v_employee_context`; tables: `leave_balance`, `leave_request`, `payroll`, `performance`, `training`)

## Configuration

Open `Config.toml` and provide the following values:

### Oracle Database

| Key | Description | Example |
|---|---|---|
| `oracleDbHost` | Hostname of the Oracle DB instance | `localhost` |
| `oracleDbPort` | Port of the Oracle DB instance | `1521` |
| `oracleDbName` | Oracle DB service name or PDB name | `FREEPDB1` |
| `oracleDbUser` | Oracle DB username | `hr_user` |
| `oracleDbPassword` | Oracle DB password | `••••••••` |

**Example `Config.toml`:**
```toml
[tharmigank.mcp_server]
oracleDbHost = "localhost"
oracleDbPort = 1521
oracleDbName = "FREEPDB1"
oracleDbUser = "<db username>"
oracleDbPassword = "<db password>"
```

## Running the Integration

1. Ensure the Oracle Database is running and the HR schema is set up
2. Open the `mcp_server` folder in **WSO2 Integrator**
3. Edit `Config.toml` and fill in all required values
4. Click **Run** in the WSO2 Integrator toolbar
5. The MCP service starts and is accessible at `http://<host>:9092/mcp`

---

## Appendix: Sample Config.toml

Copy this file, replace all `<...>` placeholders with your actual values. Values shown without a placeholder are fixed and should remain as-is unless noted.

```toml
oracleDbHost     = "localhost"   # keep as-is if using the bundled oracle-db Docker setup
oracleDbPort     = 1521          # keep as-is if using the bundled oracle-db Docker setup
oracleDbName     = "FREEPDB1"    # keep as-is if using the bundled oracle-db Docker setup
oracleDbUser     = "hr_user"     # keep as-is if using the bundled oracle-db Docker setup
oracleDbPassword = "<Oracle DB password — HrUser_2025! if using the bundled setup>"

[wso2.icp.runtime.bridge]
environment = "dev"          # match your ICP environment name
project     = "<icp project name>"
integration = "MCP Server"   # must match the integration name registered in ICP
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
