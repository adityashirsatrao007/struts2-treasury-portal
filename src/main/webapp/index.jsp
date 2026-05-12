<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Struts 2 Demo</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a1a2e, #16213e); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .card { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); padding: 2.5rem; border-radius: 16px; width: 420px; color: #fff; }
        h1 { font-size: 1.8rem; margin-bottom: 0.4rem; color: #58a6ff; }
        p { color: #8b949e; font-size: 0.85rem; margin-bottom: 1.8rem; }
        label { display: block; font-size: 0.8rem; color: #8b949e; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.05em; }
        input[type="text"], input[type="email"], select {
            width: 100%; padding: 10px 14px; margin-bottom: 1.2rem;
            background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px; color: #fff; font-size: 0.95rem; outline: none;
            transition: border 0.2s;
        }
        input[type="text"]:focus, input[type="email"]:focus, select:focus { border-color: #58a6ff; }
        select option { background: #1a1a2e; }
        input[type="submit"] {
            width: 100%; padding: 12px; background: #58a6ff; border: none;
            border-radius: 8px; color: #fff; font-size: 1rem; font-weight: 600;
            cursor: pointer; transition: background 0.3s;
        }
        input[type="submit"]:hover { background: #1f6feb; }
        .api-hint { margin-top: 1.5rem; padding: 1rem; background: rgba(88,166,255,0.08); border-radius: 8px; font-size: 0.78rem; color: #8b949e; }
        .api-hint code { color: #58a6ff; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Struts 2 Demo</h1>
        <p>Annotation-based • H2 Database • JSON API</p>

        <form action="hello.action" method="post">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="e.g. Aditya" required />

            <label>Email Address</label>
            <input type="email" name="email" placeholder="e.g. aditya@demo.com" />

            <label>Role</label>
            <select name="role">
                <option value="Admin">Admin</option>
                <option value="User" selected>User</option>
                <option value="Guest">Guest</option>
            </select>

            <input type="submit" value="Submit →" />
        </form>

        <div style="margin-top: 1rem;">
            <a href="logout.action" style="color: #8b949e; text-decoration: none; font-size: 0.8rem;">Logout</a>
        </div>

        <div class="api-hint">
            💡 API: <code>curl "localhost:8080/api/hello?name=X&amp;role=Admin"</code>
        </div>
    </div>
</body>
</html>
