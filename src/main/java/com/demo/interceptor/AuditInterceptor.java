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

        logAction(username, "REQUEST", actionName + "." + methodName);
        String result = invocation.invoke();
        logAction(username, "RESULT", actionName + " returned " + result);

        return result;
    }

    private void logAction(String username, String action, String details) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            AuditLog log = new AuditLog(username, action, details);
            session.persist(log);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
