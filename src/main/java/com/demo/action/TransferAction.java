package com.demo.action;

import com.demo.service.TreasuryService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;

public class TransferAction extends ActionSupport {
    private String fromAccount;
    private String toAccount;
    private double amount;
    private String format;
    private boolean apiSuccess;
    private String apiMessage;

    private final TreasuryService treasuryService = new TreasuryService();

    public String execute() {
        format = ServletActionContext.getRequest().getParameter("format");
        String username = (String) ServletActionContext.getContext().getSession().get("user");
        String role = (String) ServletActionContext.getContext().getSession().get("role");

        if (!"MAKER".equals(role)) {
            apiMessage = "Access Denied: Only Makers can initiate transfers.";
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }

        try {
            treasuryService.initiateTransfer(fromAccount, toAccount, amount, username);
            apiSuccess = true;
            apiMessage = "Transfer initiated successfully.";
            addActionMessage(apiMessage);
            return "json".equals(format) ? "json" : SUCCESS;
        } catch (Exception e) {
            apiSuccess = false;
            apiMessage = e.getMessage();
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }
    }

    public String getFromAccount() { return fromAccount; }
    public void setFromAccount(String fromAccount) { this.fromAccount = fromAccount; }
    public String getToAccount() { return toAccount; }
    public void setToAccount(String toAccount) { this.toAccount = toAccount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public boolean isApiSuccess() { return apiSuccess; }
    public String getApiMessage() { return apiMessage; }
}
