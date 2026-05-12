<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a1a2e, #16213e); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .card { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); padding: 2.5rem; border-radius: 16px; width: 380px; color: #fff; text-align: center; }
        h1 { font-size: 1.8rem; margin-bottom: 1.5rem; color: #58a6ff; }
        input[type="text"], input[type="password"] {
            width: 100%; padding: 12px; margin-bottom: 1.2rem;
            background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px; color: #fff; font-size: 1rem; outline: none;
        }
        input[type="submit"] {
            width: 100%; padding: 12px; background: #58a6ff; border: none;
            border-radius: 8px; color: #fff; font-size: 1.1rem; font-weight: 600;
            cursor: pointer; transition: background 0.3s;
        }
        input[type="submit"]:hover { background: #1f6feb; }
        .error { color: #f85149; background: rgba(248,81,73,0.1); padding: 10px; border-radius: 8px; margin-bottom: 1rem; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Join Us</h1>
        <form action="register.action" method="post">
            <input type="text" name="username" placeholder="Choose Username" required />
            <input type="password" name="password" placeholder="Choose Password" required />
            <input type="submit" value="Register Now" />
        </form>
        <p style="margin-top: 1rem; font-size: 0.8rem; color: #8b949e;">
            Already have an account? <a href="login.jsp" style="color: #58a6ff; text-decoration: none;">Login here</a>
        </p>
    </div>
</body>
</html>
