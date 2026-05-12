# 🔌 API Reference

The portal provides a programmatic interface for automated forensic auditing and machine-to-machine interaction.

## JSON Support
All core actions support a `format=json` parameter. When provided, the server returns a structured JSON response instead of a JSP view.

### 1. Authentication API
*   **Endpoint**: `/login.action?format=json`
*   **Method**: POST
*   **Parameters**: `username`, `password`

### 2. Treasury Dashboard API
*   **Endpoint**: `/treasury.action?format=json`
*   **Description**: Returns a list of accounts and their current balances.

### 3. Transfer Initiation API
*   **Endpoint**: `/initiateTransfer.action?format=json`
*   **Role Required**: MAKER
*   **Parameters**: `fromAccount`, `toAccount`, `amount`

### 4. Forensic Audit API
*   **Endpoint**: `/audit.action?format=json`
*   **Description**: Provides a paginated list of all system audit logs.
