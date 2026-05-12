package com.demo.interceptor;

import com.demo.db.HibernateUtil;
import com.demo.model.AuditLog;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.Map;

public class AuditInterceptor extends AbstractInterceptor {
    @Override
    public String intercept(ActionInvocation invocation) throws Exception {
        String actionName = invocation.getProxy().getActionName();
        String methodName = invocation.getProxy().getMethod();
        
        Map<String, Object> session = invocation.getInvocationContext().getSession();
        String username = (String) session.get("user");
        
        if (username == null) username = "System/Anonymous";

        // Only log specific actions to avoid recursion or session issues
        if (!actionName.equals("audit")) {
            logAction(username, "REQUEST", actionName + "." + methodName);
        }
        
        return invocation.invoke();
    }

    private void logAction(String username, String action, String details) {
        try {
            Session session = HibernateUtil.getSessionFactory().getCurrentSession();
            if (session != null && session.isOpen()) {
                AuditLog log = new AuditLog(username, action, details);
                session.save(log);
            }
        } catch (Exception e) {
            // Log to console if DB logging fails to avoid crashing the app
            System.err.println("Audit Log Failed: " + details);
        }
    }
}
