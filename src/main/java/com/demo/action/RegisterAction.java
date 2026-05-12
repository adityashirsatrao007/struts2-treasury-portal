package com.demo.action;

import com.demo.db.HibernateUtil;
import com.demo.model.User;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.mindrot.jbcrypt.BCrypt;

@Results({
    @Result(name = "success", type = "redirect", location = "login.jsp"),
    @Result(name = "input", location = "/register.jsp"),
    @Result(name = "error", location = "/register.jsp")
})
public class RegisterAction extends ActionSupport {
    private String username;
    private String password;

    @Action("/register")
    public String execute() {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            addActionError("Username and Password are required!");
            return ERROR;
        }

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            
            // Hash the password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            
            User user = new User(username, hashedPassword, "MAKER");
            session.persist(user);
            
            transaction.commit();
            return SUCCESS;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            addActionError("User already exists or database error!");
            return ERROR;
        }
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
