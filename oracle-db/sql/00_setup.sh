#!/bin/bash
# =============================================================================
#  00_setup.sh — ACME HR schema initialisation
#
#  Runs inside the gvenzl/oracle-free container on first start.
#  Explicitly connects to FREEPDB1 for every step so that all objects are
#  created in the correct PDB under hr_user, not in CDB$ROOT.
# =============================================================================

echo ">>> [1/3] Granting extra privileges to hr_user..."
sqlplus -s system/"${ORACLE_PASSWORD}"@//localhost:1521/FREEPDB1 << 'SQL'
GRANT CREATE VIEW TO hr_user;
ALTER USER hr_user QUOTA UNLIMITED ON USERS;
EXIT;
SQL

echo ">>> [2/3] Creating schema as hr_user..."
sqlplus -s hr_user/"${APP_USER_PASSWORD}"@//localhost:1521/FREEPDB1 @/opt/oracle/hr_scripts/01_schema.sql

echo ">>> [3/3] Loading sample data as hr_user..."
sqlplus -s hr_user/"${APP_USER_PASSWORD}"@//localhost:1521/FREEPDB1 << 'SQL'
SET DEFINE OFF
@/opt/oracle/hr_scripts/02_sample_data.sql
EXIT;
SQL

echo ">>> HR schema setup complete."
