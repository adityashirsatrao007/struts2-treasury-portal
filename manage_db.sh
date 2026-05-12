#!/bin/bash
# Path to H2 Jar
H2_JAR="/home/aditya/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar"
JDBC_URL="jdbc:h2:./testdb;AUTO_SERVER=TRUE"
USER="sa"

# Real BCrypt hash for 'password123'
HASH='$2a$10$0TCN5Y.sPiTuMSrHFXgE2uf3lsXdsp1Q2Dql3PlF02XVd5lgRwzoS'

if [ "$1" == "seed" ]; then
    echo "--- SEEDING JPMC TREASURY DATABASE ---"
    java -cp "$H2_JAR" org.h2.tools.Shell -url "$JDBC_URL" -user "$USER" -sql "
        DROP TABLE IF EXISTS audit_logs;
        DROP TABLE IF EXISTS transfers;
        DROP TABLE IF EXISTS accounts;
        DROP TABLE IF EXISTS users;

        CREATE TABLE users (username VARCHAR(255) PRIMARY KEY, password VARCHAR(255), role VARCHAR(50));
        CREATE TABLE accounts (account_number VARCHAR(20) PRIMARY KEY, account_name VARCHAR(255), balance DECIMAL(15,2));
        
        -- Corrected transfers table with timestamp column
        CREATE TABLE transfers (
            id INT AUTO_INCREMENT PRIMARY KEY, 
            from_account VARCHAR(20), 
            to_account VARCHAR(20), 
            amount DECIMAL(15,2), 
            status VARCHAR(20), 
            initiator VARCHAR(255), 
            approver VARCHAR(255),
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        
        CREATE TABLE audit_logs (
            id INT AUTO_INCREMENT PRIMARY KEY, 
            username VARCHAR(255), 
            action VARCHAR(255), 
            details VARCHAR(1000), 
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        INSERT INTO accounts (account_number, account_name, balance) VALUES ('ACC-JPMC-001', 'Corporate Operating Account', 1000000.00);
        INSERT INTO accounts (account_number, account_name, balance) VALUES ('ACC-JPMC-002', 'Strategic Reserve Account', 5000000.00);
        INSERT INTO accounts (account_number, account_name, balance) VALUES ('ACC-JPMC-003', 'Payroll Account', 250000.00);
        
        INSERT INTO users (username, password, role) VALUES ('maker1', '$HASH', 'MAKER');
        INSERT INTO users (username, password, role) VALUES ('checker1', '$HASH', 'CHECKER');
        INSERT INTO users (username, password, role) VALUES ('admin', '$HASH', 'CHECKER');

        INSERT INTO audit_logs (username, action, details) VALUES ('System', 'INITIALIZATION', 'Treasury System Environment Ready');
    "
    echo "--- JPMC SEEDING COMPLETE ---"
elif [ "$1" == "view" ]; then
    ./jpmc_report.sh
else
    echo "Usage: ./manage_db.sh [seed|view]"
fi
