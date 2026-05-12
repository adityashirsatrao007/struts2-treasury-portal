package com.demo.service;

import com.demo.dao.AccountDAO;
import com.demo.dao.TransferDAO;
import com.demo.model.Account;
import com.demo.model.Transfer;
import java.util.List;

public class TreasuryService {
    private final AccountDAO accountDAO = new AccountDAO();
    private final TransferDAO transferDAO = new TransferDAO();

    public List<Account> getAllAccounts() {
        return accountDAO.findAll();
    }

    public List<Transfer> getPendingTransfers() {
        return transferDAO.findPending();
    }

    public void initiateTransfer(String fromAcc, String toAcc, Double amount, String initiator) {
        Account source = accountDAO.findByAccountNumber(fromAcc);
        if (source == null || source.getBalance() < amount) {
            throw new IllegalArgumentException("Insufficient funds or invalid source account.");
        }

        Transfer transfer = new Transfer();
        transfer.setFromAccount(fromAcc);
        transfer.setToAccount(toAcc);
        transfer.setAmount(amount);
        transfer.setInitiator(initiator);
        transfer.setStatus("PENDING");
        
        transferDAO.save(transfer);
    }

    public void approveTransfer(Integer transferId, String approver) {
        Transfer transfer = transferDAO.findById(transferId);
        if (transfer == null || !"PENDING".equals(transfer.getStatus())) {
            throw new IllegalArgumentException("Transfer not found or already processed.");
        }

        if (transfer.getInitiator().equals(approver)) {
            throw new SecurityException("Maker-Checker violation: Initiator cannot approve their own transfer.");
        }

        Account source = accountDAO.findByAccountNumber(transfer.getFromAccount());
        Account target = accountDAO.findByAccountNumber(transfer.getToAccount());

        if (source.getBalance() < transfer.getAmount()) {
            transfer.setStatus("REJECTED");
            transferDAO.update(transfer);
            throw new IllegalArgumentException("Insufficient funds at time of approval.");
        }

        // Execute Transfer
        source.setBalance(source.getBalance() - transfer.getAmount());
        target.setBalance(target.getBalance() + transfer.getAmount());

        accountDAO.update(source);
        accountDAO.update(target);

        transfer.setStatus("APPROVED");
        transfer.setApprover(approver);
        transferDAO.update(transfer);
    }
}
