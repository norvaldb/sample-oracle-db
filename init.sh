#!/bin/bash

# Environment variables like ORACLE_SID and ORACLE_PWD should be available from the Dockerfile or docker-compose.yml

# Construct the connection string
# Using EZCONNECT syntax: sys/<password>@//<hostname>:<port>/<service_name> as sysdba
# Alternatively, use sqlplus sys/$ORACLE_PWD as sysdba and then use @script_name.sql
# The base image's entrypoint often handles waiting for the DB to be ready.
# If not, you might need a wait loop here.

echo "Starting SQL script execution..."

# Execute SQL scripts using sqlplus
sqlplus sys/$ORACLE_PWD as sysdba <<EOF
  -- Ensure PDB is open if using CDB (adjust PDB name if needed, ORCLPDB1 is common default)
  ALTER PLUGGABLE DATABASE ${ORACLE_SID}PDB1 OPEN READ WRITE;
  ALTER SESSION SET CONTAINER=${ORACLE_SID}PDB1;

  -- Execute scripts
  @/opt/oracle/scripts/startup/01_create_user.sql
  @/opt/oracle/scripts/startup/02_create_table.sql
  @/opt/oracle/scripts/startup/03_create_data.sql
  @/opt/oracle/scripts/startup/04_create_index.sql

  EXIT;
EOF

echo "SQL script execution finished."

# Optional: Keep container running if needed, though the base image entrypoint usually handles this.
# tail -f /dev/null
