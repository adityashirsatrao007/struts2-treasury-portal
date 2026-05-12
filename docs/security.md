# 🛡️ Security Model

Security is at the heart of the Treasury Portal. We implement a "Defense in Depth" strategy across all layers of the application.

## Deep-Security Request Lifecycle
Every transaction follows a strictly audited path from the browser to the database commit.

![Security Flow](assets/security_flow.png)

### 1. Interceptor-Based Defense
Every request is filtered through a stack of specialized interceptors:
*   **AuthenticationInterceptor**: Verifies user identity and session validity.
*   **HibernateSessionInterceptor**: Manages the atomic transaction boundary.
*   **AuditInterceptor**: Records forensic metadata for every action.

### 2. Role-Based Access Control (RBAC)
The portal strictly separates the **Maker** and **Checker** roles.
*   **Makers**: Can initiate transfers but cannot authorize them.
*   **Checkers**: Can authorize transfers but cannot initiate them.

### 3. Forensic Transparency
All financial activity is captured in a tamper-evident audit log, accessible only to authorized administrative roles.
