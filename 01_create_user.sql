-- Note: This script assumes it's run by a user with privileges to create users and grant permissions (like SYS or SYSTEM).
-- The Docker entrypoint script might need to handle connecting as the appropriate user.
-- The init.sh script handles setting the container session.

-- Create the user
CREATE USER booklib_user IDENTIFIED BY booklib_password;

-- Grant basic connection and resource privileges
GRANT CONNECT, RESOURCE TO booklib_user;

-- Grant unlimited tablespace quota (adjust if specific tablespace management is needed)
ALTER USER booklib_user QUOTA UNLIMITED ON USERS;

-- Grant privileges to create tables, sequences, etc.
GRANT CREATE SESSION TO booklib_user;
GRANT CREATE TABLE TO booklib_user;
GRANT CREATE SEQUENCE TO booklib_user;
GRANT CREATE VIEW TO booklib_user;
GRANT CREATE PROCEDURE TO booklib_user;
GRANT CREATE TRIGGER TO booklib_user;

-- Exit SQL*Plus (optional, depending on how the script is run)
-- EXIT;
