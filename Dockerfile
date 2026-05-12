# Phase 1: Build the application
FROM maven:3.9.5-eclipse-temurin-21 AS build
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Build application
COPY . .
RUN mvn clean package -DskipTests

# Phase 2: Secure Runtime
FROM tomcat:9.0-jdk21-temurin

# Set JVM options for Java 21 compatibility with legacy Struts/Tomcat
ENV CATALINA_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED \
                   --add-opens=java.base/java.io=ALL-UNNAMED \
                   --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED \
                   --add-opens=java.base/java.util=ALL-UNNAMED \
                   --add-opens=java.base/sun.nio.ch=ALL-UNNAMED"

# Remove default webapps for security
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable shutdown port to prevent Render health check issues
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/g' /usr/local/tomcat/conf/server.xml

# Create a non-root user for security
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Copy the built WAR
COPY --from=build --chown=tomcat:tomcat /app/target/struts2-demo.war /usr/local/tomcat/webapps/ROOT.war

# Configure Tomcat to listen on 10000
RUN sed -i 's/port="8080"/port="10000"/g' /usr/local/tomcat/conf/server.xml

USER tomcat
EXPOSE 10000
CMD ["catalina.sh", "run"]
