package com.bankflow.dao;

import com.bankflow.model.Compte;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class CompteDao {

    public void save(Compte compte) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(compte);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Compte> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Compte c LEFT JOIN FETCH c.client ORDER BY c.dateCreation DESC",
                            Compte.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }


    public Optional<Compte> findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Compte compte = em.find(Compte.class, id);
            return Optional.ofNullable(compte);
        } finally {
            em.close();
        }
    }

    public Optional<Compte> findByNumero(String numeroCompte) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Compte compte = em.createQuery("SELECT c FROM Compte c WHERE c.numeroCompte = :numero", Compte.class)
                    .setParameter("numero", numeroCompte)
                    .getSingleResult();
            return Optional.ofNullable(compte);
        } catch (Exception e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Compte> findByClientId(Long clientId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Compte c WHERE c.client.id = :clientId", Compte.class)
                    .setParameter("clientId", clientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Object[]> getSoldeMoyenParTypeCompte() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c.type, AVG(c.solde) FROM Compte c GROUP BY c.type", Object[].class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}