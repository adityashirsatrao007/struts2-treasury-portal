---
title: JPMC Treasury Portal
emoji: 🏦
colorFrom: blue
colorTo: gray
sdk: docker
app_port: 7860
pinned: false
---

# JPMC Corporate Treasury Portal

A secure, high-performance treasury management system built with Apache Struts 2 and Hibernate.

## Features
- **Maker-Checker Workflow**: Dual-authorization for all financial transactions.
- **Real-time Liquidity Dashboard**: Comprehensive view of account balances and pending approvals.
- **Enterprise Security**: BCrypt hashing, Session-per-Request (OSIV), and secure HTTP headers.
- **Persistence**: PostgreSQL integration for reliable data storage.

## Deployment
This Space is configured to run as a Docker container listening on port 7860.

### Environment Variables Required
- `DATABASE_URL`: JDBC connection string for PostgreSQL.
- `STRUTS_DEV_MODE`: Set to `true` for development debugging.

---
*Powered by Struts 2 & Hibernate 6*
