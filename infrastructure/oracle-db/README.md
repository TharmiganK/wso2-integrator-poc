# Oracle Database

## Overview

A Docker-based Oracle Database instance that provides the HR data store for the [MCP Server](../mcp_server/README.md) and [HubSpot to Oracle DB](../hubspot_to_oracledb/README.md) integrations. It uses the `gvenzl/oracle-free` image (no Docker Hub login required) and automatically provisions the HR schema and sample data on first start.

## Schema

The database runs inside the `FREEPDB1` pluggable database as the `hr_user` user and contains the following tables:

| Table | Description |
|---|---|
| `department` | Organisational departments |
| `emp_master` | Core employee records (status, join date, etc.) |
| `emp_job` | Current and historical job assignments (title, grade, manager) |
| `emp_contact` | Employee contact and bank details |
| `payroll` | Monthly payroll records with salary components and EPF/ETF totals |
| `leave_balance` | Per-employee, per-type, per-year leave entitlements and balances |
| `leave_request` | Leave request history and approval status |
| `performance` | Quarterly and annual performance review records |
| `training` | Training course completions and certifications |
| `disciplinary` | Disciplinary action records |

A convenience view `v_employee_context` joins all relevant tables to return full employee context in a single query.

## Prerequisites

- Docker and Docker Compose

## Running

### Start the database

```bash
docker compose up -d
```

The first start takes a few minutes while Oracle initialises and the schema scripts run. The container is healthy when `docker compose ps` shows `healthy`.

### Check logs

```bash
docker logs -f acme_hr_oracle
```

### Connect with SQL*Plus

```bash
docker exec -it acme_hr_oracle sqlplus hr_user/HrUser_2025!@//localhost:1521/FREEPDB1
```

### Stop and remove (data preserved)

```bash
docker compose down
```

### Wipe all data and start fresh

```bash
docker compose down -v
```

## SQL Scripts

| File | Description |
|---|---|
| `sql/00_setup.sh` | Entrypoint script that runs the schema and data scripts inside the container |
| `sql/01_schema.sql` | Creates all tables, views, and indexes |
| `sql/02_sample_data.sql` | Inserts sample employee records for development and testing |
