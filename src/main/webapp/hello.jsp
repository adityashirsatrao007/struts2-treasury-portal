<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a1a2e, #16213e); height: 100vh; display: flex; justify-content: center; align-items: center; color: white; margin: 0; }
        .card { background: rgba(255,255,255,0.05); padding: 3rem; border-radius: 16px; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); text-align: center; }
        h1 { font-size: 3rem; color: #58a6ff; margin-bottom: 1rem; }
        a { color: #8b949e; text-decoration: none; border: 1px solid #8b949e; padding: 10px 20px; border-radius: 8px; transition: 0.3s; }
        a:hover { background: rgba(255,255,255,0.1); color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h1><%= message %></h1>
        <p style="margin-bottom: 2rem; color: #8b949e;">You have successfully authenticated.</p>
        <a href="logout.action">Logout</a>
    </div>
</body>
</html>
