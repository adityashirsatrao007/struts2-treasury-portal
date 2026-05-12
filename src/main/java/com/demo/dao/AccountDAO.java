package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.Account;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class AccountDAO {
    public Account findByAccountNumber(String accountNumber) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Account.class, accountNumber);
        }
    }

    public List<Account> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Account", Account.class).list();
        }
    }
    
    public void update(Account account) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(account);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }
}
