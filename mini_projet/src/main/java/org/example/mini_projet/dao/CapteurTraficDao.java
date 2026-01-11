package org.example.mini_projet.dao;

import jakarta.persistence.EntityManager;
import org.example.mini_projet.model.CapteurTrafic;

import java.util.List;
public class CapteurTraficDao {
    public void save(CapteurTrafic c) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(c);
        em.getTransaction().commit();
        em.close();
    }
    public List<CapteurTrafic> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        List<CapteurTrafic> list = em.createQuery("SELECT c FROM CapteurTrafic c", CapteurTrafic.class).getResultList();
        em.close();
        return list;
    }
    public CapteurTrafic findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        CapteurTrafic c = em.find(CapteurTrafic.class, id);
        em.close();
        return c;
    }
}