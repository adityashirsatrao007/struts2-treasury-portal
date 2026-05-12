# 🎓 Interview Prep & FAQ

Use this guide to prepare for technical reviews or project defenses.

## Top 5 Architectural Questions

**Q1: Why did you choose Struts 2 for this project?**
> Struts 2 provides a robust, interceptor-based architecture that is perfect for enterprise security requirements. Its clean separation of concerns makes it easy to implement complex workflows like Maker-Checker.

**Q2: How do you handle database concurrency?**
> We use Hibernate's session management. Each request is wrapped in an atomic transaction, ensuring that if a transfer fails at any point, the database is rolled back to a safe state.

**Q3: How is the Audit Log protected?**
> The Audit Log is handled by a global interceptor that runs outside the business logic. This ensures that every attempt to access the system is recorded, even if the action itself fails or is denied.

**Q4: What is "Open Session In View"?**
> It's a pattern implemented via our `HibernateSessionInterceptor`. It keeps the database session open during the entire request lifecycle, allowing for lazy-loading of data inside the JSPs without causing `LazyInitializationException`.

**Q5: How do you ensure the API is secure?**
> The API uses the exact same interceptor stack as the web interface. This means the same authentication and authorization rules apply whether you are using a browser or a Python script.
