package com.demo.action;

import com.demo.service.AuthenticationService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@ParentPackage("public")
@InterceptorRef("publicStack")
@Results({
    @Result(name = "success", type = "redirect", location = "login.jsp"),
    @Result(name = "input", location = "/register.jsp"),
    @Result(name = "error", location = "/register.jsp")
})
public class RegisterAction extends ActionSupport {
    private String username;
    private String password;
    private String role;

    private final AuthenticationService authService = new AuthenticationService();

    @Action("/register")
    public String execute() {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            addActionError("Username and Password are required!");
            return ERROR;
        }

        try {
            authService.register(username, password, role);
            return SUCCESS;
        } catch (IllegalArgumentException e) {
            addActionError(e.getMessage());
            return ERROR;
        } catch (Exception e) {
            addActionError("Registration failed: " + e.getMessage());
            return ERROR;
        }
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
