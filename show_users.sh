#!/bin/bash

# H2 Database location: /home/aditya/Downloads/WD Project/struts2-demo/testdb.mv.db
DB_URL="jdbc:h2:./testdb;AUTO_SERVER=TRUE"
JAR_PATH="../h2-2.2.224.jar"

if [ ! -f "$JAR_PATH" ]; then
    # If jar is not in parent, try to find it in maven repo
    JAR_PATH="$HOME/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar"
fi

echo "--- DATABASE FILE LOCATION ---"
ls -lh testdb.mv.db
echo ""

echo "--- REGISTERED USERS ---"
java -cp "$JAR_PATH" org.h2.tools.Shell -url "$DB_URL" -user sa -sql "SELECT * FROM users;"
