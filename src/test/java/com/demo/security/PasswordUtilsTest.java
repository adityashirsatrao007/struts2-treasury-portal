package com.demo.security;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilsTest {

    @Test
    public void testHashAndVerify() {
        String password = "SecretPassword123!@#";
        String hash = PasswordUtils.hashPassword(password);
        
        assertNotNull(hash);
        assertTrue(PasswordUtils.verifyPassword(password, hash));
        assertFalse(PasswordUtils.verifyPassword("wrongPassword", hash));
    }

    @Test
    public void testStrengthValidation() {
        assertTrue(PasswordUtils.isStrong("StrongPass123!@#")); // Valid
        assertFalse(PasswordUtils.isStrong("weak"));           // Too short
        assertFalse(PasswordUtils.isStrong("NoSpecialChar123")); // No special char
        assertFalse(PasswordUtils.isStrong("nosymbol123"));     // No uppercase
    }
}
