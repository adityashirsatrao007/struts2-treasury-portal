# 🏦 JPMC Corporate Treasury Portal

An enterprise-grade **Corporate Treasury Management System** built with **Apache Struts 2** and **Hibernate ORM**. This project simulates the high-security workflows used at top investment banks like **JPMorgan Chase**.

## 🚀 Key Features
- **Maker-Checker Workflow:** Enforces dual-authorization for all fund transfers (Banking Compliance).
- **Security Audit Logging:** Interceptor-based logging of all system actions for forensic auditing.
- **ORM Persistence:** Fully integrated with **Hibernate 6** for professional data management.
- **Headless API Support:** Dual-mode Actions (JSP for Web, JSON for CLI/Mobile testing).
- **Enterprise Security:** BCrypt password hashing and session-based authentication.

## 🛠 Tech Stack
- **Framework:** Struts 2.6 (Convention Plugin)
- **Database Layer:** Hibernate 6.2 + H2 (Oracle/PostgreSQL ready)
- **Logging:** Log4j2 (Structured Logging)
- **Server:** Apache Tomcat 9/10
- **Testing:** Python 3 (CLI API Testing)
- **Infrastructure:** Dockerized for Cloud Deployment (Railway/Render)

## 📦 Getting Started

### 1. Prerequisites
- Java 21+
- Maven 3.9+
- Python 3 (for testing)

### 2. Running Locally
```bash
mvn clean tomcat7:run
```
The server will start at `http://localhost:8080`.

### 3. Terminal-Based API Testing (No Browser Required)
```bash
python3 test_treasury.py
```

### 4. Viewing System Reports
```bash
./manage_db.sh view
```

## ☁️ Deployment
This project includes a `Dockerfile` and `railway.json`. To deploy to **Railway.app** or **Render**:
1. Connect this repository to your cloud provider.
2. Ensure the Runtime is set to **Docker**.
3. Deploy!

## 📜 License
This project is for educational purposes and follows JPMC-style architectural patterns.
