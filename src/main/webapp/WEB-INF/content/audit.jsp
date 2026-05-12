<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forensic Audit Logs - JPMC Treasury</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --jpmc-blue: #0056b3; 
            --jpmc-dark: #1a1a1a; 
            --sidebar-width: 280px;
            --text-main: #1f2937;
            --text-muted: #6b7280;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: var(--sidebar-width); background: var(--jpmc-dark); color: white; padding: 2rem 1.5rem; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-logo { font-size: 1.4rem; font-weight: 700; margin-bottom: 3rem; border-bottom: 1px solid #333; padding-bottom: 1rem; }
        .sidebar-logo span { color: var(--jpmc-blue); }
        .nav-item { padding: 12px 15px; border-radius: 8px; margin-bottom: 0.5rem; cursor: pointer; transition: 0.2s; display: flex; align-items: center; text-decoration: none; color: #d1d5db; }
        .nav-item:hover { background: #2d2d2d; color: white; }
        .nav-item.active { background: var(--jpmc-blue); color: white; }

        .main-content { margin-left: var(--sidebar-width); flex-grow: 1; }
        header { background: white; padding: 1.25rem 2.5rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e5e7eb; }
        
        .container { padding: 2.5rem; max-width: 1200px; margin: 0 auto; }
        .card { background: white; border-radius: 12px; border: 1px solid #e5e7eb; padding: 2rem; margin-bottom: 2rem; }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 1rem; border-bottom: 2px solid #f3f4f6; color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; }
        td { padding: 1rem; border-bottom: 1px solid #f3f4f6; font-size: 0.875rem; }
        
        .log-type { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 700; }
        .type-request { background: #e0f2fe; color: #0369a1; }
        .type-result { background: #f0fdf4; color: #166534; }
        
        .timestamp { font-family: monospace; color: var(--text-muted); white-space: nowrap; }
        .user-tag { font-weight: 600; color: var(--jpmc-blue); }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">J.P. Morgan<span>.</span></div>
        <div class="nav-menu">
            <a href="treasury.action" class="nav-item"><i>🏠</i> Dashboard</a>
            <a href="reports.action" class="nav-item"><i>📊</i> Liquidity Reports</a>
            <a href="audit.action" class="nav-item active"><i>⚖️</i> Audit Logs</a>
        </div>
        <a href="logout.action" class="nav-item" style="margin-top: auto; color: #ef4444;"><i>🚪</i> Sign Out</a>
    </div>

    <div class="main-content">
        <header>
            <div class="breadcrumb">Treasury Portal / <strong>Forensic Audit Trail</strong></div>
            <div style="font-weight: 600;"><s:property value="#session.user" /></div>
        </header>

        <div class="container">
            <h1 style="font-size: 1.875rem; font-weight: 700; margin-bottom: 2rem;">Activity Monitoring</h1>

            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 style="font-size: 1.25rem;">Real-time Forensic Feed</h2>
                    <span style="font-size: 0.875rem; color: var(--text-muted);">Showing last 100 entries</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Timestamp</th>
                            <th>User</th>
                            <th>Type</th>
                            <th>Operation / Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <s:iterator value="auditLogs">
                            <tr>
                                <td class="timestamp"><s:date name="timestamp" format="yyyy-MM-dd HH:mm:ss" /></td>
                                <td class="user-tag"><s:property value="username" /></td>
                                <td>
                                    <span class="log-type <s:if test="action == 'REQUEST'">type-request</s:if><s:else>type-result</s:else>">
                                        <s:property value="action" />
                                    </span>
                                </td>
                                <td><code><s:property value="details" /></code></td>
                            </tr>
                        </s:iterator>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
