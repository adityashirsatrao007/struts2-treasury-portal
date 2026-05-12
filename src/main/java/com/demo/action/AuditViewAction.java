package com.demo.action;

import com.demo.db.HibernateUtil;
import com.demo.model.AuditLog;
import com.opensymphony.xwork2.ActionSupport;
import org.hibernate.Session;
import java.util.List;

public class AuditViewAction extends ActionSupport {
    private List<AuditLog> auditLogs;
    private String format;

    @Override
    @SuppressWarnings("unchecked")
    public String execute() {
        Session session = HibernateUtil.getCurrentSession();
        auditLogs = session.createQuery("from AuditLog order by timestamp desc").setMaxResults(100).list();
        
        return "json".equals(format) ? "json" : SUCCESS;
    }

    public List<AuditLog> getAuditLogs() { return auditLogs; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
}
