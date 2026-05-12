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
FROM tomcat:10.1-jdk21-temurin

# Remove default webapps for security
RUN rm -rf /usr/local/tomcat/webapps/*

# Create a non-root user for security
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat

# Copy the built WAR
COPY --from=build --chown=tomcat:tomcat /app/target/struts2-demo.war /usr/local/tomcat/webapps/ROOT.war

USER tomcat
EXPOSE 8080
CMD ["catalina.sh", "run"]
