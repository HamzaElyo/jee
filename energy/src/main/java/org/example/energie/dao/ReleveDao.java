package org.example.energie.dao;
import jakarta.persistence.*;
import org.example.energie.model.ReleveConsommation;
import java.util.List;

public class ReleveDao {
    public void save(ReleveConsommation r) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(r);
        em.getTransaction().commit();
        em.close();
    }
    public List<Object[]> getStatsByType() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Object[]> results = em.createQuery(
                        "SELECT r.compteur.type, AVG(r.valeur), MIN(r.valeur), MAX(r.valeur) FROM ReleveConsommation r GROUP BY r.compteur.type",
                        Object[].class)
                .getResultList();
        em.close();
        return results;
    }
}
