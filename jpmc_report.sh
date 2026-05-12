#!/bin/bash

# Configuration
H2_JAR="/home/aditya/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar"
DB_URL="jdbc:h2:./testdb;AUTO_SERVER=TRUE"
USER="sa"

echo "=========================================================="
echo "          J.P. MORGAN - CORPORATE TREASURY REPORT         "
echo "=========================================================="
echo "Generated at: $(date)"
echo ""

echo "--- [ LIQUIDITY SUMMARY ] ---"
java -cp "$H2_JAR" org.h2.tools.Shell -url "$DB_URL" -user "$USER" -sql "SELECT account_number AS \"ACC #\", account_name AS \"NAME\", balance AS \"BALANCE (USD)\" FROM accounts;"
echo ""

echo "--- [ PENDING TRANSFERS (MAKER-CHECKER) ] ---"
java -cp "$H2_JAR" org.h2.tools.Shell -url "$DB_URL" -user "$USER" -sql "SELECT id, from_account, amount, initiator, status FROM transfers WHERE status = 'PENDING';"
echo ""

echo "--- [ SECURITY AUDIT LOGS (LATEST 5) ] ---"
java -cp "$H2_JAR" org.h2.tools.Shell -url "$DB_URL" -user "$USER" -sql "SELECT timestamp, username, action, details FROM audit_logs ORDER BY timestamp DESC LIMIT 5;"

echo ""
echo "=========================================================="
echo "             END OF TREASURY SECURITY REPORT              "
echo "=========================================================="
