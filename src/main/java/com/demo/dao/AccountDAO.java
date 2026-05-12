package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.Account;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class AccountDAO {
    public Account findByAccountNumber(String accountNumber) {
        return HibernateUtil.getCurrentSession().get(Account.class, accountNumber);
    }

    public List<Account> findAll() {
        return HibernateUtil.getCurrentSession().createQuery("from Account", Account.class).list();
    }
    
    public void update(Account account) {
        HibernateUtil.getCurrentSession().merge(account);
    }
}
