package com.ironlog.common;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Simple password encoder using SHA-256
 * Note: In production, use BCrypt or similar industry-standard algorithms
 */
public class PasswordEncoder {
    
    private static final String SALT = "IronLog2024"; // In production, use per-user salt
    
    /**
     * Encode password using SHA-256
     * @param rawPassword the plain text password
     * @return the encoded password
     */
    public static String encode(String rawPassword) {
        if (rawPassword == null || rawPassword.isEmpty()) {
            return rawPassword;
        }
        
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String saltedPassword = rawPassword + SALT;
            byte[] hash = digest.digest(saltedPassword.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to encode password", e);
        }
    }
    
    /**
     * Check if a raw password matches an encoded password
     * @param rawPassword the plain text password
     * @param encodedPassword the encoded password
     * @return true if passwords match
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        String encoded = encode(rawPassword);
        return encoded.equals(encodedPassword);
    }
}
