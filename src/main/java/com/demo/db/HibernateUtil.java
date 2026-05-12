package com.demo.db;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import java.net.URI;
import java.util.Properties;

public class HibernateUtil {
    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration().configure();
            
            // Override with environment variables if available (e.g. on Render)
            String databaseUrl = System.getenv("DATABASE_URL");
            if (databaseUrl != null && !databaseUrl.isEmpty()) {
                System.out.println("--- Configuring Hibernate for Postgres (DATABASE_URL detected) ---");
                Properties props = parseDatabaseUrl(databaseUrl);
                configuration.addProperties(props);
            } else {
                System.out.println("--- Configuring Hibernate for H2 (In-Memory) ---");
            }
            
            return configuration.buildSessionFactory();
        } catch (Throwable ex) {
            System.err.println("--- Initial SessionFactory creation failed: " + ex + " ---");
            throw new ExceptionInInitializerError(ex);
        }
    }

    private static Properties parseDatabaseUrl(String databaseUrl) {
        Properties props = new Properties();
        try {
            // Render DATABASE_URL is usually: postgres://user:pass@host:port/db
            URI dbUri = new URI(databaseUrl);
            String username = dbUri.getUserInfo().split(":")[0];
            String password = dbUri.getUserInfo().split(":")[1];
            String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ":" + dbUri.getPort() + dbUri.getPath();

            props.setProperty("hibernate.connection.url", dbUrl);
            props.setProperty("hibernate.connection.username", username);
            props.setProperty("hibernate.connection.password", password);
            props.setProperty("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
            props.setProperty("hibernate.hikari.driverClassName", "org.postgresql.Driver");
            props.setProperty("hibernate.hikari.jdbcUrl", dbUrl);
            props.setProperty("hibernate.hikari.username", username);
            props.setProperty("hibernate.hikari.password", password);
            
            // Clean up H2 specific properties
            props.setProperty("hibernate.connection.driver_class", "org.postgresql.Driver");
            
        } catch (Exception e) {
            System.err.println("Error parsing DATABASE_URL: " + e.getMessage());
        }
        return props;
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}
