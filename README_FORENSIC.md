# 🏦 J.P. Morgan Treasury Portal: Forensic Technical Manual

This document provides a detailed breakdown of the portal's architecture, security model, and implementation logic. Use this for project reviews, handovers, or technical interviews.

## 🚀 1. Technology Stack
*   **Framework**: Apache Struts 2.6.x (The industry standard for Java-based enterprise MVC).
*   **ORM**: Hibernate 6.2 (Object-Relational Mapping for database interactions).
*   **Server**: Apache Tomcat (Local: Maven Plugin | Production: Dockerized).
*   **Database**: H2 (Development) / PostgreSQL (Production).
*   **Security**: Interceptor-based "Maker-Checker" authentication and forensic auditing.

---

## 🗺️ 2. Mapping & Routing (The Backbone)
The portal uses **Manual Mapping** instead of "magic" annotations to ensure 100% predictability and security.
*   **File**: `src/main/resources/struts.xml`
*   **Logic**: Every URL (e.g., `/login.action`) is mapped to a specific Java Class (e.g., `LoginAction.java`) and a specific Result (e.g., `/WEB-INF/content/login.jsp`).
*   **Security Rule**: All JSPs are placed inside `/WEB-INF/`. This makes them **unreachable** via a direct URL, forcing all traffic to pass through our security Interceptors.

---

## ⚙️ 3. Core Logic Flow
1.  **Request**: User hits a URL (e.g., `initiateTransfer.action`).
2.  **Interceptors**: 
    *   `HibernateSessionInterceptor`: Opens a database connection.
    *   `AuthenticationInterceptor`: Checks if the user is logged in.
    *   `AuditInterceptor`: Records the request in the `AUDIT_LOGS` table.
3.  **Action**: The Java class executes the business logic (e.g., `TransferAction.java`).
4.  **Result**: The action returns a string (e.g., `"success"`) which Struts maps to the final JSP or a JSON object for the API.

---

## 🧪 4. Top 10 Forensic Interview Questions

**Q1: How did you fix the 404 error on the logout page?**
> *Answer*: I changed the logout result from a "Forward" to a "Redirect". This ensures the browser session is properly terminated and the URL is reset to the login page, preventing stale session conflicts.

**Q2: Why are the JSPs inside WEB-INF instead of the root folder?**
> *Answer*: This is a security best practice. Files in `WEB-INF` cannot be accessed directly by a browser. This forces every request to go through the Struts Filter and our Interceptor stack (Authentication & Auditing).

**Q3: How does the "Maker-Checker" logic work here?**
> *Answer*: It's enforced in the `TransferAction` and `ApprovalAction`. A user with the `MAKER` role can only initiate transfers (Status: PENDING), while only a user with the `CHECKER` role can see the authorization queue and approve them.

**Q4: How did you handle the Database connection issues on Render?**
> *Answer*: I modified `HibernateUtil.java` to dynamically parse the `DATABASE_URL`. I added a fail-safe that defaults the port to `5432` if it's missing from the Render environment string, preventing "Port -1" errors.

**Q5: What is the purpose of the `AuditInterceptor`?**
> *Answer*: It provides a forensic trail. Every time an action is called, it captures the username, the operation, and the timestamp, storing it in the `audit_logs` table for compliance auditing.

**Q6: Why did you use `json-default` in struts.xml?**
> *Answer*: To support both Web and API users. By extending `json-default`, we can return structured JSON data to Python scripts (like `test_treasury.py`) when they provide the `format=json` parameter.

**Q7: How do you prevent SQL Injection in this app?**
> *Answer*: By using Hibernate's HQL (Hibernate Query Language) and Parameterized Queries. We never concatenate raw strings into SQL.

**Q8: What happens if the database goes down during a transfer?**
> *Answer*: The `HibernateSessionInterceptor` wraps the entire request in a `@Transaction`. If any error occurs, the transaction is rolled back completely, ensuring data integrity.

**Q9: How did you implement the "Liquidity Reports"?**
> *Answer*: I created a `ReportAction` that uses Java Streams to aggregate balances across all accounts and calculated their relative weights for visualization in a modern UI.

**Q10: What server-side technology handles the startup and database migrations?**
> *Answer*: **Flyway**. It runs automatically on startup (via `FlywayListener.java`), ensuring the database schema (Tables, Seed data) is always synchronized across Local and Cloud environments.

---

## 🛠️ How to Run (Exact Commands)
**Local Build:**
```bash
mvn clean compile tomcat7:run -Dmaven.test.skip=true
```

**API Verification:**
```bash
python3 test_treasury.py
```
