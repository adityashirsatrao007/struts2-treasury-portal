<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JPMC - Corporate Treasury Portal</title>
    <style>
        :root { --jpmc-blue: #0056b3; --jpmc-dark: #1a1a1a; --success: #28a745; --warning: #ffc107; --danger: #dc3545; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; }
        header { background: var(--jpmc-dark); color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 4px solid var(--jpmc-blue); }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .card { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 1.5rem; margin-bottom: 2rem; }
        h2 { border-bottom: 2px solid #eee; padding-bottom: 0.5rem; margin-bottom: 1.5rem; color: var(--jpmc-blue); }
        table { width: 100%; border-collapse: collapse; margin-bottom: 1rem; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #eee; }
        th { background: #fafafa; font-weight: 600; }
        .balance { font-family: 'Courier New', Courier, monospace; font-weight: bold; color: var(--success); }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        select, input[type="number"], input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: 600; transition: 0.3s; }
        .btn-primary { background: var(--jpmc-blue); color: white; }
        .btn-primary:hover { background: #004494; }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }
        .messages { margin-bottom: 1rem; }
        .error { color: var(--danger); background: #fdecea; padding: 10px; border-radius: 4px; margin-bottom: 10px; }
        .success { color: var(--success); background: #e9f7ef; padding: 10px; border-radius: 4px; margin-bottom: 10px; }
        .logout { color: #8b949e; text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>
    <header>
        <div>
            <h1 style="font-size: 1.5rem;">J.P. Morgan <span style="font-weight: 300; color: #aaa;">| Treasury Portal</span></h1>
        </div>
        <div>
            <span>Welcome, <strong><s:property value="#session.user" /></strong> (<s:property value="currentUserRole" />)</span> | 
            <a href="logout.action" class="logout">Secure Logout</a>
        </div>
    </header>

    <div class="container">
        <div class="messages">
            <s:if test="hasActionErrors()">
                <div class="error"><s:actionerror /></div>
            </s:if>
            <s:if test="hasActionMessages()">
                <div class="success"><s:actionmessage /></div>
            </s:if>
        </div>

        <!-- Liquidity Overview -->
        <div class="card">
            <h2>Liquidity Overview</h2>
            <table>
                <thead>
                    <tr>
                        <th>Account Number</th>
                        <th>Account Name</th>
                        <th>Available Balance (USD)</th>
                    </tr>
                </thead>
                <tbody>
                    <s:iterator value="accounts">
                        <tr>
                            <td><s:property value="accountNumber" /></td>
                            <td><s:property value="accountName" /></td>
                            <td class="balance">$<s:property value="balance" /></td>
                        </tr>
                    </s:iterator>
                </tbody>
            </table>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
            <!-- Initiate Transfer (Maker) -->
            <div class="card" <s:if test="currentUserRole != 'MAKER'">style="opacity: 0.6; pointer-events: none;"</s:if>>
                <h2>Initiate Fund Transfer <s:if test="currentUserRole != 'MAKER'"><span style="font-size: 0.8rem; color: var(--danger);">(Maker Only)</span></s:if></h2>
                <form action="initiateTransfer" method="post">
                    <div class="form-group">
                        <label>From Account</label>
                        <select name="fromAccount">
                            <s:iterator value="accounts">
                                <option value="<s:property value='accountNumber' />"><s:property value="accountName" /> (<s:property value="accountNumber" />)</option>
                            </s:iterator>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Destination Account Number</label>
                        <input type="text" name="toAccount" placeholder="Enter Account Number" required />
                    </div>
                    <div class="form-group">
                        <label>Amount (USD)</label>
                        <input type="number" name="amount" step="0.01" min="1" placeholder="0.00" required />
                    </div>
                    <button type="submit" class="btn btn-primary" <s:if test="currentUserRole != 'MAKER'">disabled</s:if>>Initiate Maker Request</button>
                </form>
            </div>

            <!-- Pending Approvals (Checker) -->
            <div class="card">
                <h2>Pending Approvals</h2>
                <s:if test="pendingTransfers.isEmpty()">
                    <p style="color: #666; text-align: center; padding: 2rem;">No pending requests at this time.</p>
                </s:if>
                <s:else>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Amount</th>
                                <th>Initiator</th>
                                <s:if test="currentUserRole == 'CHECKER'">
                                    <th>Action</th>
                                </s:if>
                            </tr>
                        </thead>
                        <tbody>
                            <s:iterator value="pendingTransfers">
                                <tr>
                                    <td>#<s:property value="id" /></td>
                                    <td>$ <s:property value="amount" /></td>
                                    <td><s:property value="initiator" /></td>
                                    <s:if test="currentUserRole == 'CHECKER'">
                                        <td>
                                            <form action="approveTransfer" method="post" style="display:inline;">
                                                <input type="hidden" name="transferId" value="<s:property value='id' />" />
                                                <button type="submit" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8rem;">Approve</button>
                                            </form>
                                        </td>
                                    </s:if>
                                </tr>
                            </s:iterator>
                        </tbody>
                    </table>
                </s:else>
            </div>
        </div>
    </div>
</body>
</html>
