<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liquidity Reports - JPMC Treasury</title>
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
        
        .liquidity-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem; }
        .total-badge { background: #eff6ff; color: #1e40af; padding: 1rem 2rem; border-radius: 12px; border: 1px solid #bfdbfe; }
        .total-label { font-size: 0.875rem; font-weight: 600; text-transform: uppercase; margin-bottom: 0.5rem; }
        .total-amount { font-size: 2rem; font-weight: 700; }

        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1.25rem 1rem; border-bottom: 2px solid #f3f4f6; color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; }
        td { padding: 1.5rem 1rem; border-bottom: 1px solid #f3f4f6; }
        
        .progress-bar-container { width: 100%; height: 8px; background: #e5e7eb; border-radius: 4px; margin-top: 8px; overflow: hidden; }
        .progress-bar { height: 100%; background: var(--jpmc-blue); border-radius: 4px; }
        
        .btn { padding: 8px 16px; border-radius: 6px; font-weight: 600; text-decoration: none; display: inline-block; font-size: 0.875rem; }
        .btn-outline { border: 1px solid #d1d5db; color: var(--text-main); }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">J.P. Morgan<span>.</span></div>
        <div class="nav-menu">
            <a href="treasury.action" class="nav-item"><i>🏠</i> Dashboard</a>
            <a href="reports.action" class="nav-item active"><i>📊</i> Liquidity Reports</a>
            <a href="audit.action" class="nav-item"><i>⚖️</i> Audit Logs</a>
        </div>
        <a href="logout.action" class="nav-item" style="margin-top: auto; color: #ef4444;"><i>🚪</i> Sign Out</a>
    </div>

    <div class="main-content">
        <header>
            <div class="breadcrumb">Treasury Portal / <strong>Liquidity Reports</strong></div>
            <div style="font-weight: 600;"><s:property value="#session.user" /></div>
        </header>

        <div class="container">
            <div class="liquidity-header">
                <div>
                    <h1 style="font-size: 1.875rem; font-weight: 700;">Global Liquidity Position</h1>
                    <p style="color: var(--text-muted); margin-top: 0.5rem;">Real-time aggregation across all subsidiary accounts.</p>
                </div>
                <div class="total-badge">
                    <div class="total-label">Total Net Position (USD)</div>
                    <div class="total-amount">$<s:property value="getText('{0,number,#,##0.00}', {totalLiquidity})" /></div>
                </div>
            </div>

            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 style="font-size: 1.25rem;">Account Breakdown</h2>
                    <a href="reports.action?format=json" class="btn btn-outline">Export JSON</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Account Name</th>
                            <th>Account Number</th>
                            <th>Balance</th>
                            <th>Weight</th>
                        </tr>
                    </thead>
                    <tbody>
                        <s:iterator value="accounts">
                            <tr>
                                <td><strong><s:property value="accountName" /></strong></td>
                                <td style="font-family: monospace; color: var(--text-muted);"><s:property value="accountNumber" /></td>
                                <td style="font-weight: 700;">$<s:property value="getText('{0,number,#,##0.00}', {balance})" /></td>
                                <td style="width: 300px;">
                                    <div style="font-size: 0.75rem; margin-bottom: 4px; text-align: right;">
                                        <s:property value="getText('{0,number,0.0}%', { (balance / totalLiquidity) * 100 })" />
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar" style="width: <s:property value="(balance / totalLiquidity) * 100" />%"></div>
                                    </div>
                                </td>
                            </tr>
                        </s:iterator>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
