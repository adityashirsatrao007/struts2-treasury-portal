package com.demo.action;

import com.demo.db.HibernateUtil;
import com.demo.model.Account;
import com.demo.model.Transfer;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

@ParentPackage("auth-default")
@Results({
    @Result(name = "success", location = "/treasury.jsp"),
    @Result(name = "input", location = "/treasury.jsp"),
    @Result(name = "error", location = "/treasury.jsp"),
    @Result(name = "json", type = "json")
})
public class TreasuryAction extends ActionSupport {
    private List<Account> accounts = new ArrayList<>();
    private List<Transfer> pendingTransfers = new ArrayList<>();
    private String fromAccount;
    private String toAccount;
    private double amount;
    private int transferId;
    private String currentUserRole;
    
    // JSON response fields
    private boolean apiSuccess;
    private String apiMessage;

    @Action("/treasury")
    public String execute() {
        String format = ServletActionContext.getRequest().getParameter("format");
        currentUserRole = (String) ServletActionContext.getContext().getSession().get("role");
        loadData();
        return "json".equals(format) ? "json" : SUCCESS;
    }

    @Action("/initiateTransfer")
    public String initiate() {
        String format = ServletActionContext.getRequest().getParameter("format");
        if (amount <= 0) {
            apiSuccess = false;
            apiMessage = "Amount must be greater than zero.";
            addActionError(apiMessage);
            loadData();
            return "json".equals(format) ? "json" : ERROR;
        }

        String username = (String) ServletActionContext.getContext().getSession().get("user");

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            
            Transfer transfer = new Transfer();
            transfer.setFromAccount(fromAccount);
            transfer.setToAccount(toAccount);
            transfer.setAmount(amount);
            transfer.setStatus("PENDING");
            transfer.setInitiator(username);
            
            session.persist(transfer);
            transaction.commit();
            
            apiSuccess = true;
            apiMessage = "Transfer initiated successfully. Awaiting approval.";
            addActionMessage(apiMessage);
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            apiSuccess = false;
            apiMessage = "Error initiating transfer: " + e.getMessage();
            addActionError(apiMessage);
        }

        loadData();
        return "json".equals(format) ? "json" : SUCCESS;
    }

    @Action("/approveTransfer")
    public String approve() {
        String format = ServletActionContext.getRequest().getParameter("format");
        String username = (String) ServletActionContext.getContext().getSession().get("user");

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            
            Transfer transfer = session.get(Transfer.class, transferId);
            if (transfer != null && "PENDING".equals(transfer.getStatus())) {
                Account fromAcc = session.get(Account.class, transfer.getFromAccount());
                Account toAcc = session.get(Account.class, transfer.getToAccount());

                if (fromAcc != null && toAcc != null && fromAcc.getBalance() >= transfer.getAmount()) {
                    // Deduct and Add
                    fromAcc.setBalance(fromAcc.getBalance() - transfer.getAmount());
                    toAcc.setBalance(toAcc.getBalance() + transfer.getAmount());
                    
                    // Update transfer
                    transfer.setStatus("APPROVED");
                    transfer.setApprover(username);
                    
                    session.merge(fromAcc);
                    session.merge(toAcc);
                    session.merge(transfer);
                    
                    transaction.commit();
                    apiSuccess = true;
                    apiMessage = "Transfer ID " + transferId + " approved successfully.";
                    addActionMessage(apiMessage);
                } else {
                    apiSuccess = false;
                    apiMessage = "Insufficient balance or invalid accounts.";
                    addActionError(apiMessage);
                    transaction.rollback();
                }
            } else {
                apiSuccess = false;
                apiMessage = "Transfer not found or already processed.";
                addActionError(apiMessage);
            }
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            apiSuccess = false;
            apiMessage = "Error processing approval: " + e.getMessage();
            addActionError(apiMessage);
        }

        loadData();
        return "json".equals(format) ? "json" : SUCCESS;
    }

    private void loadData() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            accounts = session.createQuery("from Account", Account.class).list();
            pendingTransfers = session.createQuery("from Transfer where status = 'PENDING'", Transfer.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Getters and Setters
    public List<Account> getAccounts() { return accounts; }
    public List<Transfer> getPendingTransfers() { return pendingTransfers; }
    public String getFromAccount() { return fromAccount; }
    public void setFromAccount(String fromAccount) { this.fromAccount = fromAccount; }
    public String getToAccount() { return toAccount; }
    public void setToAccount(String toAccount) { this.toAccount = toAccount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public int getTransferId() { return transferId; }
    public void setTransferId(int transferId) { this.transferId = transferId; }
    public String getCurrentUserRole() { return currentUserRole; }
    public void setCurrentUserRole(String role) { this.currentUserRole = role; }
    public boolean isApiSuccess() { return apiSuccess; }
    public String getApiMessage() { return apiMessage; }
}
