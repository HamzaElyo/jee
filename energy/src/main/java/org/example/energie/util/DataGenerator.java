package org.example.energie.util;

import jakarta.persistence.EntityManager;
import org.example.energie.dao.JpaUtil;
import org.example.energie.model.CompteurIntelligent;
import org.example.energie.model.ReleveConsommation;

import java.time.LocalDateTime;
import java.util.Random;

public class DataGenerator {
    public static void main(String[] args) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        CompteurIntelligent c = new CompteurIntelligent();
        c.setCode("CPT-TEST");
        c.setType("Electricité");
        c.setAdresse("Avenue Einstein");
        em.persist(c);
        Random rnd = new Random();
        for (int i = 0; i < 50000; i++) {
            ReleveConsommation r = new ReleveConsommation();
            r.setDateHeure(LocalDateTime.now().minusMinutes(rnd.nextInt(10000)));
            r.setValeur(100 + rnd.nextDouble() * 200);
            r.setUnite("kWh");
            r.setCompteur(c);
            em.persist(r);
            if (i % 100 == 0) { em.flush(); em.clear(); }
        }
        em.getTransaction().commit();
        em.close();
        System.out.println("Insertions terminées !");
    }
}
