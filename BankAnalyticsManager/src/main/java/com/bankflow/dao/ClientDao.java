package com.bankflow.dao;

import com.bankflow.model.Client;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class ClientDao {

    public void save(Client client) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(client);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<Client> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Client c ORDER BY c.nom, c.prenom", Client.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Client> findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Client client = em.find(Client.class, id);
            return Optional.ofNullable(client);
        } finally {
            em.close();
        }
    }

    public Optional<Client> findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Client client = em.createNamedQuery("Client.findByEmail", Client.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return Optional.ofNullable(client);
        } catch (Exception e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public void update(Client client) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(client);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}