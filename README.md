# 🏛️ JPMC Corporate Treasury Portal

A secure, high-performance treasury management system built with Apache Struts 2 and Hibernate. Optimized for mission-critical liquidity management and dual-authorization financial workflows.

### 🌐 [Click Here to View Interactive Documentation](https://adityashirsatrao007.github.io/struts2-treasury-portal/#/)
*(Note: Requires GitHub Pages to be enabled on your repository settings for the `/docs` folder)*

---

## 🏗️ 1. Architecture Overview
The system utilizes a 2D component-layered architecture to ensure a clear separation between infrastructure, server runtime, and application logic.

![Architecture Stack](docs/assets/arch_stack.png)

## 🔄 2. Professional Workflows

### 2.1 Sequential Authorization Logic
The interaction between system participants follows a rigid 2D sequence of events to maintain financial compliance.

![Sequence Flow](docs/assets/sequence_flow.png)

### 2.2 Maker-Checker Financial Lifecycle
Ensures institutional control by requiring two distinct roles for every money movement operation.

![Transfer Flow](docs/assets/transfer_flow.png)

## 🛡️ 3. Security & Compliance
*   **Interceptor-Based Defense**: Deep security request lifecycle.
*   **Forensic Auditing**: Tamper-evident transaction logging.
*   **Dockerized Infrastructure**: Consistent deployment across environments.

![Security Flow](docs/assets/security_flow.png)

---

## 🚀 Quick Start (Local)
1.  **Build & Run**:
    ```bash
    mvn clean compile tomcat7:run -Dmaven.test.skip=true
    ```
2.  **API Verification**:
    ```bash
    python3 test_treasury.py
    ```

---
*Created for the JPMC Advanced Agentic Coding Certification.*
