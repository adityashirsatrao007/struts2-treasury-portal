package com.demo.action;

import com.demo.service.TreasuryService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;

public class ApprovalAction extends ActionSupport {
    private int transferId;
    private String format;
    private boolean apiSuccess;
    private String apiMessage;

    private final TreasuryService treasuryService = new TreasuryService();

    public String execute() {
        format = ServletActionContext.getRequest().getParameter("format");
        String username = (String) ServletActionContext.getContext().getSession().get("user");
        String role = (String) ServletActionContext.getContext().getSession().get("role");

        if (!"CHECKER".equals(role)) {
            apiMessage = "Access Denied: Only Checkers can approve transfers.";
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }

        try {
            treasuryService.approveTransfer(transferId, username);
            apiSuccess = true;
            apiMessage = "Transfer approved successfully.";
            addActionMessage(apiMessage);
            return "json".equals(format) ? "json" : SUCCESS;
        } catch (Exception e) {
            apiSuccess = false;
            apiMessage = e.getMessage();
            addActionError(apiMessage);
            return "json".equals(format) ? "json" : ERROR;
        }
    }

    public int getTransferId() { return transferId; }
    public void setTransferId(int transferId) { this.transferId = transferId; }
    public boolean isApiSuccess() { return apiSuccess; }
    public String getApiMessage() { return apiMessage; }
}
