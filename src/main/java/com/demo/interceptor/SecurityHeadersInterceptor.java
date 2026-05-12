package com.demo.interceptor;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.apache.struts2.ServletActionContext;
import javax.servlet.http.HttpServletResponse;

/**
 * Security Headers Interceptor
 * Injects essential security headers to prevent common web attacks.
 */
public class SecurityHeadersInterceptor extends AbstractInterceptor {

    @Override
    public String intercept(ActionInvocation invocation) throws Exception {
        HttpServletResponse response = ServletActionContext.getResponse();

        // Prevent Clickjacking
        response.setHeader("X-Frame-Options", "DENY");

        // Prevent MIME Sniffing
        response.setHeader("X-Content-Type-Options", "nosniff");

        // Enable Browser XSS Filter
        response.setHeader("X-XSS-Protection", "1; mode=block");

        // Enforce HTTPS
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");

        // Content Security Policy (CSP)
        // Adjust these rules based on your specific JS/CSS requirements
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:;");

        // Referrer Policy
        response.setHeader("Referrer-Policy", "no-referrer-when-downgrade");

        return invocation.invoke();
    }
}
