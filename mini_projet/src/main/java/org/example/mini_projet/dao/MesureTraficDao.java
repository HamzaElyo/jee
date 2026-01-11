package org.example.mini_projet.dao;

import jakarta.persistence.EntityManager;
import org.example.mini_projet.model.MesureTrafic;

import java.util.List;

public class MesureTraficDao {

    public void save(MesureTrafic m) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(m);
        em.getTransaction().commit();
        em.close();
    }

    /**
     * Statistiques par type de véhicule : moyenne, min, max de vitesse ou embouteillage
     */
    public List<Object[]> getStatsByTypeVehicule() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Object[]> results = em.createQuery(
                        "SELECT m.typeVehicule, AVG(m.vitesseMoy), MIN(m.vitesseMoy), MAX(m.vitesseMoy) " +
                                "FROM MesureTrafic m GROUP BY m.typeVehicule", Object[].class)
                .getResultList();
        em.close();
        return results;
    }

    /**
     * Statistiques par zone : nombre de véhicules moyen, embouteillage moyen
     */
    public List<Object[]> getStatsByZone() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Object[]> results = em.createQuery(
                        "SELECT m.capteur.zone, AVG(m.vehicules), AVG(m.tauxEmbouteillage) " +
                                "FROM MesureTrafic m GROUP BY m.capteur.zone", Object[].class)
                .getResultList();
        em.close();
        return results;
    }
}
