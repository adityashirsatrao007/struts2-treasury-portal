package com.demo.action;

import com.demo.service.AuthenticationService;
import com.opensymphony.xwork2.ActionSupport;

public class RegisterAction extends ActionSupport {
    private String username;
    private String password;
    private String role;

    private final AuthenticationService authService = new AuthenticationService();

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
