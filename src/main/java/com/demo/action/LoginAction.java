package com.demo.action;

import com.demo.model.User;
import com.demo.service.AuthenticationService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;

public class LoginAction extends ActionSupport {
    private String username;
    private String password;
    private String format;
    
    // JSON response fields
    private boolean apiSuccess;
    private String apiMessage;

    private final AuthenticationService authService = new AuthenticationService();

    @Override
    public String execute() {
        System.out.println("--- LoginAction: format=" + format + ", user=" + username + " ---");
        if (username == null || password == null) return "json".equals(format) ? "json" : INPUT;

        try {
            User user = authService.authenticate(username, password);
            if (user != null) {
                ServletActionContext.getContext().getSession().put("user", username);
                ServletActionContext.getContext().getSession().put("role", user.getRole());
                apiSuccess = true;
                apiMessage = "Login successful";
                return "json".equals(format) ? "json" : SUCCESS;
            }
            
            apiSuccess = false;
            apiMessage = "Invalid Username or Password!";
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        } catch (Exception e) {
            apiSuccess = false;
            apiMessage = "System error: " + e.getMessage();
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }
    }

    public String logout() {
        ServletActionContext.getContext().getSession().clear();
        return SUCCESS;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
    public boolean isApiSuccess() { return apiSuccess; }
    public String getApiMessage() { return apiMessage; }
}
