#!/bin/bash

echo "--------------------------------------------------"
echo "🏦 JPMC Treasury Portal: Database Console Tool"
echo "--------------------------------------------------"
echo "1. Opening Browser to H2 Console..."
echo "2. Use the following credentials to log in:"
echo "   - JDBC URL: jdbc:h2:mem:testdb"
echo "   - User Name: sa"
echo "   - Password: (leave empty)"
echo "--------------------------------------------------"

# Try to open browser (works on most Linux environments)
xdg-open "http://localhost:8080/console" 2>/dev/null || echo "Please visit: http://localhost:8080/console"

echo "Done."
