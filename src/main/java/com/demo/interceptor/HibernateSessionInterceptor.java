package com.demo.interceptor;

import com.demo.db.HibernateUtil;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.context.internal.ManagedSessionContext;

/**
 * Hibernate Session Interceptor
 * Implements the "Open Session in View" pattern.
 * Ensures a single Hibernate session is available for the entire request lifecycle.
 */
public class HibernateSessionInterceptor extends AbstractInterceptor {

    @Override
    public String intercept(ActionInvocation invocation) throws Exception {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        
        try {
            // Bind session to the current thread
            ManagedSessionContext.bind(session);
            transaction = session.beginTransaction();
            
            String result = invocation.invoke();
            
            if (transaction.isActive()) {
                transaction.commit();
            }
            return result;
            
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        } finally {
            // Unbind and close
            ManagedSessionContext.unbind(HibernateUtil.getSessionFactory());
            if (session.isOpen()) {
                session.close();
            }
        }
    }
}
