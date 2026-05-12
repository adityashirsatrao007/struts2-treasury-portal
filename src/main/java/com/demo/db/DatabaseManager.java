package com.demo.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DatabaseManager {
    private static final String JDBC_URL = "jdbc:h2:./testdb;AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASSWORD = "";

    static {
        try {
            Class.forName("org.h2.Driver");
            try (Connection conn = getConnection();
                 Statement stmt = conn.createStatement()) {
                // Core User Tables
                stmt.execute("CREATE TABLE IF NOT EXISTS users (username VARCHAR(255) PRIMARY KEY, password VARCHAR(255), role VARCHAR(50) DEFAULT 'MAKER')");
                
                // Treasury Tables
                stmt.execute("CREATE TABLE IF NOT EXISTS accounts (account_number VARCHAR(20) PRIMARY KEY, account_name VARCHAR(255), balance DECIMAL(15,2))");
                stmt.execute("CREATE TABLE IF NOT EXISTS transfers (id INT AUTO_INCREMENT PRIMARY KEY, from_account VARCHAR(20), to_account VARCHAR(20), amount DECIMAL(15,2), status VARCHAR(20), initiator VARCHAR(255), approver VARCHAR(255), timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
                stmt.execute("CREATE TABLE IF NOT EXISTS audit_logs (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255), action VARCHAR(255), details VARCHAR(1000), timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

                // Seed Test Accounts
                stmt.execute("MERGE INTO accounts KEY(account_number) VALUES ('ACC-JPMC-001', 'Corporate Operating Account', 1000000.00)");
                stmt.execute("MERGE INTO accounts KEY(account_number) VALUES ('ACC-JPMC-002', 'Strategic Reserve Account', 5000000.00)");
                stmt.execute("MERGE INTO accounts KEY(account_number) VALUES ('ACC-JPMC-003', 'Payroll Disbursement Account', 250000.00)");
                stmt.execute("MERGE INTO accounts KEY(account_number) VALUES ('ACC-JPMC-004', 'Tax Reserve Account', 750000.00)");
                
                // Seed Admin User (Maker/Checker)
                stmt.execute("MERGE INTO users KEY(username) VALUES ('admin', '$2a$10$8.UnVuG9shgYdfiS.r6zK.qj/S/p3A.HlZ6p.R.e.P/q.q.q.q.q.q.', 'CHECKER')");
                stmt.execute("MERGE INTO users KEY(username) VALUES ('maker1', '$2a$10$8.UnVuG9shgYdfiS.r6zK.qj/S/p3A.HlZ6p.R.e.P/q.q.q.q.q.q.', 'MAKER')");

                // Seed Historical Audit Logs
                stmt.execute("INSERT INTO audit_logs (username, action, details) VALUES ('System', 'INITIALIZATION', 'Treasury System Started')");
                stmt.execute("INSERT INTO audit_logs (username, action, details) VALUES ('admin', 'LOGIN', 'Successful login from IP 10.0.0.1')");
                stmt.execute("INSERT INTO audit_logs (username, action, details) VALUES ('admin', 'REPORT_VIEW', 'Generated Monthly Liquidity Report')");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}
