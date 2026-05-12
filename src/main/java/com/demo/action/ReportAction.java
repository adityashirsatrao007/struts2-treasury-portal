package com.demo.action;

import com.demo.model.Account;
import com.demo.service.TreasuryService;
import com.opensymphony.xwork2.ActionSupport;
import java.util.List;

public class ReportAction extends ActionSupport {
    private List<Account> accounts;
    private double totalLiquidity;
    private String format;
    
    private final TreasuryService treasuryService = new TreasuryService();

    @Override
    public String execute() {
        accounts = treasuryService.getAllAccounts();
        totalLiquidity = accounts.stream().mapToDouble(Account::getBalance).sum();
        
        return "json".equals(format) ? "json" : SUCCESS;
    }

    public List<Account> getAccounts() { return accounts; }
    public double getTotalLiquidity() { return totalLiquidity; }
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
}
