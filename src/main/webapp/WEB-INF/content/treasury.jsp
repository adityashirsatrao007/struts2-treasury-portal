<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JPMC - Corporate Treasury Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { 
            --jpmc-blue: #0056b3; 
            --jpmc-dark: #1a1a1a; 
            --jpmc-light: #f8f9fa;
            --sidebar-width: 280px;
            --success: #10b981; 
            --warning: #f59e0b; 
            --danger: #ef4444; 
            --text-main: #1f2937;
            --text-muted: #6b7280;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; color: var(--text-main); display: flex; min-height: 100vh; }
        
        /* Sidebar Styles */
        .sidebar { width: var(--sidebar-width); background: var(--jpmc-dark); color: white; padding: 2rem 1.5rem; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-logo { font-size: 1.4rem; font-weight: 700; margin-bottom: 3rem; border-bottom: 1px solid #333; padding-bottom: 1rem; }
        .sidebar-logo span { color: var(--jpmc-blue); }
        .nav-menu { flex-grow: 1; }
        .nav-item { padding: 12px 15px; border-radius: 8px; margin-bottom: 0.5rem; cursor: pointer; transition: 0.2s; display: flex; align-items: center; text-decoration: none; color: #d1d5db; }
        .nav-item:hover { background: #2d2d2d; color: white; }
        .nav-item.active { background: var(--jpmc-blue); color: white; }
        .nav-item i { margin-right: 12px; font-style: normal; }

        /* Main Content */
        .main-content { margin-left: var(--sidebar-width); flex-grow: 1; display: flex; flex-direction: column; }
        header { background: white; padding: 1.25rem 2.5rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e5e7eb; position: sticky; top: 0; z-index: 10; }
        .user-profile { display: flex; align-items: center; gap: 1rem; }
        .role-badge { background: #dbeafe; color: #1e40af; padding: 4px 12px; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }

        .container { padding: 2.5rem; max-width: 1400px; margin: 0 auto; width: 100%; }
        .card { background: white; border-radius: 12px; border: 1px solid #e5e7eb; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 1.75rem; margin-bottom: 2rem; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        
        h2 { font-size: 1.25rem; font-weight: 700; margin-bottom: 1.5rem; color: var(--jpmc-dark); }
        
        /* Stats/Balance Cards */
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; border: 1px solid #e5e7eb; border-left: 4px solid var(--jpmc-blue); }
        .stat-label { color: var(--text-muted); font-size: 0.875rem; margin-bottom: 0.5rem; }
        .stat-value { font-size: 1.5rem; font-weight: 700; color: var(--jpmc-dark); }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 1rem; border-bottom: 2px solid #f3f4f6; color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; }
        td { padding: 1.25rem 1rem; border-bottom: 1px solid #f3f4f6; font-size: 0.9375rem; }
        .status-pill { padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .status-pending { background: #fef3c7; color: #92400e; }

        .btn { padding: 10px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; border: none; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-primary { background: var(--jpmc-blue); color: white; }
        .btn-primary:hover { background: #004494; transform: translateY(-1px); }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }

        .form-group { margin-bottom: 1.25rem; }
        label { display: block; font-size: 0.875rem; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-main); }
        input, select { width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 0.9375rem; }
        input:focus { outline: 2px solid var(--jpmc-blue); border-color: transparent; }

        .messages { margin-bottom: 1.5rem; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 1rem; font-size: 0.875rem; display: flex; align-items: center; gap: 10px; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
    </style>
</head>
<body>
    <!-- Sidebar Navigation -->
    <div class="sidebar">
        <div class="sidebar-logo">J.P. Morgan<span>.</span></div>
        <div class="nav-menu">
            <a href="treasury.action" class="nav-item active"><i>🏠</i> Dashboard</a>
            <a href="reports.action" class="nav-item"><i>📊</i> Liquidity Reports</a>
            <a href="audit.action" class="nav-item"><i>⚖️</i> Audit Logs</a>
            <s:if test="currentUserRole.equals('MAKER')">
                <a href="#initiate" class="nav-item"><i>💸</i> Initiate Transfer</a>
                <a href="#pending" class="nav-item"><i>⏳</i> Pending Approvals</a>
            </s:if>
            <s:if test="currentUserRole.equals('CHECKER')">
                <a href="#queue" class="nav-item"><i>⚖️</i> Authorization Queue</a>
            </s:if>
            <a href="#" class="nav-item"><i>⚙️</i> Settings</a>
        </div>
        <a href="logout.action" class="nav-item" style="margin-top: auto; color: #ef4444;"><i>🚪</i> Sign Out</a>
    </div>

    <!-- Main Content Area -->
    <div class="main-content">
        <header>
            <div class="breadcrumb">Treasury Portal / <strong>Dashboard</strong></div>
            <div class="user-profile">
                <div class="role-badge"><s:property value="currentUserRole" /></div>
                <span><strong><s:property value="#session.user" /></strong></span>
                <div style="width: 35px; height: 35px; background: #e5e7eb; border-radius: 50%; display: flex; align-items:center; justify-content:center; font-weight:bold;">
                    <s:property value="#session.user.substring(0,1).toUpperCase()" />
                </div>
            </div>
        </header>

        <div class="container">
            <div class="messages">
                <s:if test="hasActionErrors()">
                    <div class="alert alert-error">❌ <s:actionerror /></div>
                </s:if>
                <s:if test="hasActionMessages()">
                    <div class="alert alert-success">✅ <s:actionmessage /></div>
                </s:if>
            </div>

            <!-- Liquidity Overview (Balances) -->
            <div class="grid">
                <s:iterator value="accounts">
                    <div class="stat-card">
                        <div class="stat-label"><s:property value="accountName" /> (<s:property value="accountNumber" />)</div>
                        <div class="stat-value">$<s:property value="getText('{0,number,#,##0.00}', {balance})" /></div>
                    </div>
                </s:iterator>
            </div>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
                
                <div class="left-col">
                    <!-- MAKER: PENDING LIST -->
                    <s:if test="currentUserRole.equals('MAKER')">
                        <div id="pending" class="card">
                            <h2>My Pending Submissions</h2>
                            <s:if test="pendingTransfers.isEmpty()">
                                <p style="color: #9ca3af; font-style: italic;">No pending instructions at this time.</p>
                            </s:if>
                            <s:else>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Beneficiary</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <s:iterator value="pendingTransfers">
                                            <s:if test="initiator.equals(#session.user)">
                                                <tr>
                                                    <td style="font-size: 0.8rem; color: #6b7280;"><s:date name="timestamp" format="MMM dd, HH:mm" /></td>
                                                    <td><s:property value="toAccount" /></td>
                                                    <td style="font-weight: 600;">$<s:property value="amount" /></td>
                                                    <td><span class="status-pill status-pending">PENDING</span></td>
                                                </tr>
                                            </s:if>
                                        </s:iterator>
                                    </tbody>
                                </table>
                            </s:else>
                        </div>
                    </s:if>

                    <!-- CHECKER: QUEUE -->
                    <s:if test="currentUserRole.equals('CHECKER')">
                        <div id="queue" class="card">
                            <h2>Authorization Queue</h2>
                            <s:if test="pendingTransfers.isEmpty()">
                                <p style="color: #9ca3af; font-style: italic;">Queue is empty.</p>
                            </s:if>
                            <s:else>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Ref</th>
                                            <th>Source</th>
                                            <th>Target</th>
                                            <th>Amount</th>
                                            <th>Maker</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <s:iterator value="pendingTransfers">
                                            <tr>
                                                <td>#<s:property value="id" /></td>
                                                <td style="font-size: 0.8rem;"><s:property value="fromAccount" /></td>
                                                <td style="font-size: 0.8rem;"><s:property value="toAccount" /></td>
                                                <td style="font-weight: 700; color: var(--danger);">$<s:property value="amount" /></td>
                                                <td style="font-size: 0.8rem;"><s:property value="initiator" /></td>
                                                <td>
                                                    <form action="approveTransfer" method="post">
                                                        <input type="hidden" name="transferId" value="<s:property value='id' />" />
                                                        <button type="submit" class="btn btn-success" style="padding: 6px 12px; font-size: 0.8rem;">Authorize</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </s:iterator>
                                    </tbody>
                                </table>
                            </s:else>
                        </div>
                    </s:if>
                </div>

                <div class="right-col">
                    <!-- MAKER: FORM -->
                    <s:if test="currentUserRole.equals('MAKER')">
                        <div id="initiate" class="card">
                            <h2>Initiate Payment</h2>
                            <form action="initiateTransfer" method="post">
                                <div class="form-group">
                                    <label>Debit Account</label>
                                    <select name="fromAccount">
                                        <s:iterator value="accounts">
                                            <option value="<s:property value='accountNumber' />"><s:property value="accountName" /></option>
                                        </s:iterator>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Beneficiary IBAN/ACC</label>
                                    <input type="text" name="toAccount" placeholder="ACC-JPMC-XXX" required />
                                </div>
                                <div class="form-group">
                                    <label>Amount (USD)</label>
                                    <input type="number" name="amount" step="0.01" min="1" required />
                                </div>
                                <button type="submit" class="btn btn-primary" style="width: 100%;">Submit Instruction</button>
                            </form>
                        </div>
                    </s:if>

                    <div class="card" style="background: var(--jpmc-blue); color: white;">
                        <h3>Quick Support</h3>
                        <p style="font-size: 0.8rem; margin-top: 0.5rem; opacity: 0.9;">Contact the Treasury Operations desk for assistance with large value settlements.</p>
                        <a href="#" style="color: white; font-size: 0.8rem; display: block; margin-top: 1rem; font-weight: bold;">Contact Support →</a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>

