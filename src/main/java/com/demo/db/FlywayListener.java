package com.demo.db;

import org.flywaydb.core.Flyway;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.net.URI;

@WebListener
public class FlywayListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("--- Starting Flyway Migration ---");
        
        try {
            String url = "jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1";
            String user = "sa";
            String password = "";

            String databaseUrl = System.getenv("DATABASE_URL");
            if (databaseUrl != null && !databaseUrl.isEmpty()) {
                System.out.println("--- Flyway: Using Postgres (DATABASE_URL) ---");
                URI dbUri = new URI(databaseUrl);
                user = dbUri.getUserInfo().split(":")[0];
                password = dbUri.getUserInfo().split(":")[1];
                url = "jdbc:postgresql://" + dbUri.getHost() + ":" + dbUri.getPort() + dbUri.getPath();
            }

            Flyway flyway = Flyway.configure()
                .dataSource(url, user, password)
                .baselineOnMigrate(true)
                .load();
            
            flyway.migrate();
            System.out.println("--- Flyway Migration Successful ---");
        } catch (Exception e) {
            System.err.println("--- Flyway Migration Failed: " + e.getMessage() + " ---");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
