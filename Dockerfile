# Use the fully qualified image name from Oracle Container Registry
FROM container-registry.oracle.com/database/enterprise:19.3.0.0 

# Set the environment variables
ENV ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
ENV ORACLE_SID=ORCLCDB
ENV ORACLE_PWD=Some1New#123
ENV ORACLE_VERSION=19.3.0
ENV ORACLE_VERSION_SHORT=19.3

# Copy initialization scripts to the standard startup directory
# The base image entrypoint should execute scripts from this location.
COPY init.sh /opt/oracle/scripts/startup/init.sh
COPY 01_create_user.sql /opt/oracle/scripts/startup/01_create_user.sql
COPY 02_create_table.sql /opt/oracle/scripts/startup/02_create_table.sql
COPY 03_create_data.sql /opt/oracle/scripts/startup/03_create_data.sql
COPY 04_create_index.sql /opt/oracle/scripts/startup/04_create_index.sql

# Switch to root to change permissions
USER root
# Set execute permissions only for the shell script
RUN chmod +x /opt/oracle/scripts/startup/init.sh
# Switch back to the oracle user
USER oracle

# Expose the Oracle database port
EXPOSE 1521
EXPOSE 5500
