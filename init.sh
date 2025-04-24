#!/bin/bash

# Environment variables like ORACLE_SID and ORACLE_PWD should be available from the Dockerfile or docker-compose.yml
# Define the application user password (matches 01_create_user.sql)
BOOKLIB_PWD=booklib_password
PDB_NAME=${ORACLE_SID}PDB1
CONNECT_STRING=//localhost:1521/$PDB_NAME

# Construct the connection string
# Using EZCONNECT syntax: sys/<password>@//<hostname>:<port>/<service_name> as sysdba
# Alternatively, use sqlplus sys/$ORACLE_PWD as sysdba and then use @script_name.sql
# The base image's entrypoint often handles waiting for the DB to be ready.
# If not, you might need a wait loop here.

echo "Starting SQL script execution as SYS..."

# Execute user creation script as SYS
sqlplus sys/$ORACLE_PWD as sysdba <<EOF
  -- Ensure PDB is open if using CDB
  ALTER PLUGGABLE DATABASE $PDB_NAME OPEN READ WRITE;
  ALTER SESSION SET CONTAINER=$PDB_NAME;

  -- Execute user creation script
  @/opt/oracle/scripts/startup/01_create_user.sql

  EXIT;
EOF

echo "Finished user creation."
echo "Starting SQL script execution as booklib_user..."

# Execute schema, data, and index scripts as booklib_user
# Note: We might need a small delay or check to ensure the PDB is fully ready for user connections after opening.
# Adding a simple sleep, but a proper health check loop would be more robust.
sleep 5

sqlplus booklib_user/$BOOKLIB_PWD@$CONNECT_STRING <<EOF
  -- Session is already in the PDB via connect string

  -- Execute schema, data, index scripts
  @/opt/oracle/scripts/startup/02_create_table.sql
  @/opt/oracle/scripts/startup/03_create_data.sql
  @/opt/oracle/scripts/startup/04_create_index.sql

  EXIT;
EOF

echo "SQL script execution finished."

# Optional: Keep container running if needed, though the base image entrypoint usually handles this.
# tail -f /dev/null
