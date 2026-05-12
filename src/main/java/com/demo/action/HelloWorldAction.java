package com.demo.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.demo.db.DatabaseManager;

@ParentPackage("auth-default")
@Result(name = "success", location = "/hello.jsp")
public class HelloWorldAction extends ActionSupport {
    private String name;
    private String email;
    private String role;
    private String message;

    @Action("/hello")
    public String execute() {
        // Get the logged-in user from session (for the greeting)
        String username = (String) ServletActionContext.getContext().getSession().get("user");
        
        // Save the form data to the greetings table
        if (name != null && !name.trim().isEmpty()) {
            try (Connection conn = DatabaseManager.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("INSERT INTO greetings (name, email, role) VALUES (?, ?, ?)")) {
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, role);
                pstmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace(); // In industry, use a logger
            }
        }

        if (username != null) {
            message = "Hello, " + username + "!";
        } else {
            message = "Hello, Guest!";
        }
        
        ServletActionContext.getRequest().setAttribute("message", message);
        return SUCCESS;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getMessage() { return message; }
}
