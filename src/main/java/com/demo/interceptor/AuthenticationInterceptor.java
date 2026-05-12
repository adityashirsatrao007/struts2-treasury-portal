package com.demo.interceptor;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import java.util.Map;

public class AuthenticationInterceptor extends AbstractInterceptor {
    @Override
    public String intercept(ActionInvocation invocation) throws Exception {
        Map<String, Object> session = invocation.getInvocationContext().getSession();
        
        // Check if user is logged in
        Object user = session.get("user");
        
        // If not logged in, redirect to login action
        if (user == null) {
            return "login";
        }
        
        return invocation.invoke();
    }
}
