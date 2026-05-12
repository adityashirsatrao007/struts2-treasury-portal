package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.Transfer;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class TransferDAO {
    public Transfer findById(Integer id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Transfer.class, id);
        }
    }

    public List<Transfer> findPending() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Transfer where status = 'PENDING'", Transfer.class).list();
        }
    }

    public void save(Transfer transfer) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(transfer);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }

    public void update(Transfer transfer) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(transfer);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }
}
