package com.demo.security;

import org.mindrot.jbcrypt.BCrypt;
import java.util.regex.Pattern;

/**
 * Enterprise Password Security Utility
 * Implements high-cost BCrypt hashing and strict strength validation.
 */
public class PasswordUtils {
    // Work factor 12 for enterprise security (10 is default)
    private static final int BCRYPT_COST = 12;
    
    // Pattern: 12+ chars, Uppercase, Lowercase, Number, Special Char
    private static final Pattern STRENGTH_PATTERN = 
        Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\\S+$).{12,}$");

    /**
     * Hashes a plain text password using BCrypt with custom work factor.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) return null;
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_COST));
    }

    /**
     * Verifies a plain text password against a hashed version.
     */
    public static boolean verifyPassword(String plainPassword, String hashed) {
        if (plainPassword == null || hashed == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashed);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validates if a password meets enterprise complexity requirements.
     */
    public static boolean isStrong(String password) {
        if (password == null) return false;
        return STRENGTH_PATTERN.matcher(password).matches();
    }
}
