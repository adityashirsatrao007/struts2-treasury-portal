package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class UserDAO {
    public User findByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(User.class, username);
        }
    }

    public void save(User user) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }
}
