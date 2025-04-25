#!/bin/bash
# Ensure environment variables are available
if [[ -z "$LOCAL_DB_USER" || -z "$LOCAL_DB_USER_PWD" ]]; then
  echo "Error: LOCAL_DB_USER and LOCAL_DB_USER_PWD environment variables must be set."
  exit 1
fi

sqlplus / as sysdba << EOF
      alter session set container = ENTERPRISEPDB1;
      WHENEVER SQLERROR EXIT FAILURE;
      SET SERVEROUTPUT ON;
      DECLARE
         v_exists NUMBER;
         v_username VARCHAR(128) := '$LOCAL_DB_USER'; -- Use env var
         v_password VARCHAR(128) := '$LOCAL_DB_USER_PWD'; -- Use env var
      BEGIN
         -- Use UPPER for case-insensitive comparison if needed, Oracle usernames are typically case-insensitive unless quoted
         SELECT COUNT(*)
         INTO v_exists
         FROM dba_users
         WHERE username = UPPER(v_username);

         IF v_exists = 0 THEN
            -- Use quotes around identifier and password in case they contain special characters
            EXECUTE IMMEDIATE 'CREATE USER "' || v_username || '" IDENTIFIED BY "' || v_password || '"';
            EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES TO "' || v_username || '"';
            DBMS_OUTPUT.PUT_LINE('User ' || v_username || ' created and granted privileges.');
         ELSE
            DBMS_OUTPUT.PUT_LINE('User ' || v_username || ' already exists');
            -- Optionally, update password if user exists
            -- EXECUTE IMMEDIATE 'ALTER USER "' || v_username || '" IDENTIFIED BY "' || v_password || '"';
            -- DBMS_OUTPUT.PUT_LINE('Password for user ' || v_username || ' updated.');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
            RAISE; -- Re-raise the exception to trigger WHENEVER SQLERROR
      END;
      /
      WHENEVER SQLERROR CONTINUE; -- Allow subsequent commands even if user creation block had issues (e.g., user already exists)
      exit;
EOF
