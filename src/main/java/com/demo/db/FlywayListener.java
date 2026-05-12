package com.demo.db;

import org.flywaydb.core.Flyway;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Properties;
import java.io.InputStream;

/**
 * Flyway Migration Listener
 * Ensures the database schema is up-to-date on application startup.
 */
@WebListener
public class FlywayListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("--- Starting Flyway Database Migration ---");
        
        try {
            // In a real app, load these from application.properties
            String url = "jdbc:h2:./testdb;AUTO_SERVER=TRUE";
            String user = "sa";
            String password = "";

            Flyway flyway = Flyway.configure()
                .dataSource(url, user, password)
                .load();
            
            flyway.migrate();
            System.out.println("--- Flyway Migration Successful ---");
        } catch (Exception e) {
            System.err.println("--- Flyway Migration Failed: " + e.getMessage() + " ---");
            throw new RuntimeException("Database migration failed", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
