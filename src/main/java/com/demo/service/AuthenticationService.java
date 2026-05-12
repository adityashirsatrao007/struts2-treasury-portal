package com.demo.service;

import com.demo.dao.UserDAO;
import com.demo.model.User;
import com.demo.security.PasswordUtils;

public class AuthenticationService {
    private final UserDAO userDAO = new UserDAO();

    public User authenticate(String username, String password) {
        User user = userDAO.findByUsername(username);
        if (user != null && PasswordUtils.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public void register(String username, String password, String role) throws Exception {
        if (!PasswordUtils.isStrong(password)) {
            throw new IllegalArgumentException("Password does not meet complexity requirements.");
        }
        
        String hashedPassword = PasswordUtils.hashPassword(password);
        User user = new User(username, hashedPassword, role != null ? role : "MAKER");
        userDAO.save(user);
    }
}
