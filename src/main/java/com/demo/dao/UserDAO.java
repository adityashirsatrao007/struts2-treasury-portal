package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class UserDAO {
    public User findByUsername(String username) {
        return HibernateUtil.getCurrentSession().get(User.class, username);
    }

    public void save(User user) {
        HibernateUtil.getCurrentSession().persist(user);
    }
}
