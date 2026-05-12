package com.demo.action;

import com.demo.db.HibernateUtil;
import com.demo.model.User;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.hibernate.Session;
import org.mindrot.jbcrypt.BCrypt;

@ParentPackage("public")
@InterceptorRef("publicStack")
@Results({
    @Result(name = "success", type = "redirect", location = "treasury.action"),
    @Result(name = "input", location = "/login.jsp"),
    @Result(name = "error", location = "/login.jsp"),
    @Result(name = "json", type = "json")
})
public class LoginAction extends ActionSupport {
    private String username;
    private String password;
    
    // JSON response fields
    private boolean apiSuccess;
    private String apiMessage;

    @Action("/login")
    public String execute() {
        String format = ServletActionContext.getRequest().getParameter("format");
        if (username == null || password == null) return "json".equals(format) ? "json" : INPUT;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            User user = session.get(User.class, username);

            if (user != null) {
                // Verify the hashed password
                if (com.demo.security.PasswordUtils.verifyPassword(password, user.getPassword())) {
                    ServletActionContext.getContext().getSession().put("user", username);
                    ServletActionContext.getContext().getSession().put("role", user.getRole());
                    apiSuccess = true;
                    apiMessage = "Login successful";
                    return "json".equals(format) ? "json" : SUCCESS;
                }
            }
            
            apiSuccess = false;
            apiMessage = "Invalid Username or Password!";
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        } catch (Exception e) {
            apiSuccess = false;
            apiMessage = "Database error: " + e.getMessage();
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }
    }

    @Action("/logout")
    public String logout() {
        ServletActionContext.getContext().getSession().clear();
        return INPUT;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public boolean isApiSuccess() { return apiSuccess; }
    public String getApiMessage() { return apiMessage; }
}
