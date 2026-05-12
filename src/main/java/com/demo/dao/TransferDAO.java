package com.demo.dao;

import com.demo.db.HibernateUtil;
import com.demo.model.Transfer;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class TransferDAO {
    public Transfer findById(Integer id) {
        return HibernateUtil.getCurrentSession().get(Transfer.class, id);
    }

    public List<Transfer> findPending() {
        return HibernateUtil.getCurrentSession().createQuery("from Transfer where status = 'PENDING'", Transfer.class).list();
    }

    public void save(Transfer transfer) {
        HibernateUtil.getCurrentSession().persist(transfer);
    }

    public void update(Transfer transfer) {
        HibernateUtil.getCurrentSession().merge(transfer);
    }
}
