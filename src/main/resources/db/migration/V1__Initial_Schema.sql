-- JPMC Treasury Portal: Initial Schema
-- Enforces data integrity for Users, Accounts, Transfers, and Audit Logs

CREATE TABLE users (
    username VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
);

CREATE TABLE accounts (
    account_number VARCHAR(255) PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    balance DOUBLE NOT NULL
);

CREATE TABLE transfers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_account VARCHAR(255) NOT NULL,
    to_account VARCHAR(255) NOT NULL,
    amount DOUBLE NOT NULL,
    status VARCHAR(50) NOT NULL,
    initiator VARCHAR(255),
    approver VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_from FOREIGN KEY (from_account) REFERENCES accounts(account_number),
    CONSTRAINT fk_to FOREIGN KEY (to_account) REFERENCES accounts(account_number)
);

CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    action VARCHAR(255) NOT NULL,
    details CLOB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
