-- JPMC Treasury Portal: Seed Data
-- Initializes the system with standard corporate accounts and test users

-- Accounts
INSERT INTO accounts (account_number, account_name, balance) VALUES 
('ACC-JPMC-001', 'Corporate Operating Account', 1000000.00),
('ACC-JPMC-002', 'Strategic Reserve Account', 5000000.00),
('ACC-JPMC-003', 'Payroll Account', 250000.00);

-- Default Admin User (Maker/Checker)
-- Password is 'Password123!@#' hashed with cost 12
-- Note: In a real system, you would hash these during a setup phase.
-- This hash is for 'Password123!@#'
INSERT INTO users (username, password, role) VALUES 
('admin_test', '$2a$12$grKfguheB5f6KIUW7teGuOlQNxECeQ93JLLh.W89ifQ40jU2MVD5q', 'CHECKER'),
('maker1', '$2a$12$grKfguheB5f6KIUW7teGuOlQNxECeQ93JLLh.W89ifQ40jU2MVD5q', 'MAKER');
