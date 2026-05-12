#!/bin/bash
# Set Tomcat port dynamically based on PORT environment variable
PORT="${PORT:-8080}"
echo "Configuring Tomcat to listen on port $PORT"
sed -i "s/port=\"[0-9]*\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml
# Run Tomcat
exec catalina.sh run
