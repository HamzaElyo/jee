package com.logmaster.dao;

import com.logmaster.entity.Order;
import com.logmaster.entity.OrderStatus;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class OrderDAO {

    @PersistenceContext(unitName = "LogMasterPU")
    private EntityManager em;

    public void create(Order order) {
        em.persist(order);
    }

    public void update(Order order) {
        em.merge(order);
    }

    public void delete(Long id) {
        Order order = em.find(Order.class, id);
        if (order != null) {
            em.remove(order);
        }
    }

    public Order findById(Long id) {
        return em.find(Order.class, id);
    }

    public Order findByIdWithItems(Long id) {
        try {
            return em
                    .createQuery("SELECT o FROM Order o LEFT JOIN FETCH o.items JOIN FETCH o.user WHERE o.id = :id",
                            Order.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public List<Order> findAll() {
        return em.createQuery("SELECT o FROM Order o JOIN FETCH o.user ORDER BY o.orderDate DESC", Order.class)
                .getResultList();
    }

    public List<Order> findByUserId(Long userId) {
        return em.createQuery("SELECT o FROM Order o WHERE o.user.id = :userId", Order.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public List<Order> findByStatus(OrderStatus status) {
        return em.createQuery("SELECT o FROM Order o WHERE o.status = :status", Order.class)
                .setParameter("status", status)
                .getResultList();
    }

    public List<Order> findRecent(int limit) {
        return em.createQuery("SELECT o FROM Order o ORDER BY o.orderDate DESC", Order.class)
                .setMaxResults(limit)
                .getResultList();
    }

    public long countByStatus(OrderStatus status) {
        return em.createQuery("SELECT COUNT(o) FROM Order o WHERE o.status = :status", Long.class)
                .setParameter("status", status)
                .getSingleResult();
    }
}
