package com.demo.action;

import com.demo.model.Account;
import com.demo.model.Transfer;
import com.demo.service.TreasuryService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;

import java.util.List;

public class TreasuryAction extends ActionSupport {
    private List<Account> accounts;
    private List<Transfer> pendingTransfers;
    private String currentUserRole;
    
    private final TreasuryService treasuryService = new TreasuryService();

    @Override
    public String execute() {
        String format = ServletActionContext.getRequest().getParameter("format");
        currentUserRole = (String) ServletActionContext.getContext().getSession().get("role");
        
        accounts = treasuryService.getAllAccounts();
        pendingTransfers = treasuryService.getPendingTransfers();
        
        return "json".equals(format) ? "json" : SUCCESS;
    }

    public List<Account> getAccounts() { return accounts; }
    public List<Transfer> getPendingTransfers() { return pendingTransfers; }
    public String getCurrentUserRole() { return currentUserRole; }
}
