package org.example.energie.dao;
import jakarta.persistence.*;
import org.example.energie.model.CompteurIntelligent;
import java.util.List;

public class CompteurDao {
    public void save(CompteurIntelligent c) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(c);
        em.getTransaction().commit();
        em.close();
    }
    public List<CompteurIntelligent> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        List<CompteurIntelligent> list =
                em.createQuery("FROM CompteurIntelligent", CompteurIntelligent.class).getResultList();
        em.close();
        return list;
    }
    public CompteurIntelligent findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        CompteurIntelligent c = em.find(CompteurIntelligent.class, id);
        em.close();
        return c;
    }
}
