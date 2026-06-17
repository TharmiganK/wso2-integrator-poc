# PostgreSQL Database

## Overview

A Docker-based PostgreSQL 16 instance containing the same HR schema as the [Oracle Database](../oracle-db/README.md). This is an alternative database backend for environments where Oracle is not available. The schema and sample data are applied automatically on first start via Docker's `docker-entrypoint-initdb.d` mechanism.

## Schema

The database runs as `hr_user` in the `acme_hr` database and contains the following tables:

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

The container is ready when `docker compose ps` shows `healthy`.

### Check logs

```bash
docker logs -f acme_hr_postgres
```

### Connect with psql

```bash
docker exec -it acme_hr_postgres psql -U hr_user -d acme_hr
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
| `sql/01_schema.sql` | Creates all tables, views, and indexes |
| `sql/02_sample_data.sql` | Inserts sample employee records for development and testing |
