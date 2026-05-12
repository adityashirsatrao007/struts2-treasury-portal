#!/bin/bash
# Configuration
H2_JAR="/home/aditya/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar"
JDBC_URL="jdbc:h2:./testdb;AUTO_SERVER=TRUE"
USER="sa"

# Check if Zenity is installed
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Please install it with: sudo apt install zenity"
    exit 1
fi

# Fetch data using H2 Shell and format for Zenity
# We use a special SQL query to format each column on a new line so zenity --list can consume it
DATA=$(java -cp "$H2_JAR" org.h2.tools.Shell -url "$JDBC_URL" -user "$USER" -sql "SELECT CAST(id AS VARCHAR), name, email, role FROM greetings ORDER BY id DESC;" | grep "|" | grep -v "ID |" | sed 's/ | / /g' | tr -d '|' | xargs)

# Display the popup
if [ -z "$DATA" ]; then
    zenity --info --text="The database is currently empty." --title="Database Viewer"
else
    zenity --list \
        --title="Struts 2 Demo - Database Records" \
        --width=800 --height=400 \
        --column="ID" --column="Name" --column="Email" --column="Role" \
        $DATA
fi
