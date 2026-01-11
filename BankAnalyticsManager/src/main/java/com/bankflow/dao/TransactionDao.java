package com.bankflow.dao;

import com.bankflow.model.Transaction;
import jakarta.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

public class TransactionDao {

    public void save(Transaction transaction) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(transaction);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Transaction> findByCompteId(Long compteId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT t FROM Transaction t LEFT JOIN FETCH t.compte c LEFT JOIN FETCH c.client " +
                                    "WHERE t.compte.id = :compteId ORDER BY t.dateOperation DESC",
                            Transaction.class)
                    .setParameter("compteId", compteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Transaction> findRecentTransactions(int limit) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT t FROM Transaction t LEFT JOIN FETCH t.compte c LEFT JOIN FETCH c.client " +
                                    "ORDER BY t.dateOperation DESC",
                            Transaction.class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> getStatsTransactionsParMois() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT YEAR(t.dateOperation), MONTH(t.dateOperation), COUNT(t), SUM(t.montant) " +
                                    "FROM Transaction t GROUP BY YEAR(t.dateOperation), MONTH(t.dateOperation) " +
                                    "ORDER BY YEAR(t.dateOperation) DESC, MONTH(t.dateOperation) DESC", Object[].class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}