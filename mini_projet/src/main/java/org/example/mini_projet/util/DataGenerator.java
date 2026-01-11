package org.example.mini_projet.util;

import jakarta.persistence.EntityManager;
import org.example.mini_projet.dao.JpaUtil;
import org.example.mini_projet.model.CapteurTrafic;
import org.example.mini_projet.model.MesureTrafic;

import java.time.LocalDateTime;
import java.util.Random;

public class DataGenerator {
    public static void main(String[] args) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        long t0 = System.currentTimeMillis();

        CapteurTrafic capteur = new CapteurTrafic();
        capteur.setNom("CapteurTest");
        capteur.setType("Débit");
        capteur.setLocalisation("Place Principale");
        capteur.setZone("Nord");

        em.persist(capteur);
        Random rnd = new Random();
        for (int i = 0; i < 10000; i++) {
            MesureTrafic m = new MesureTrafic();
            m.setDateHeure(LocalDateTime.now().minusMinutes(rnd.nextInt(10000)));
            m.setVehicules(5 + rnd.nextInt(100));                   // nombre de véhicules aléatoire
            m.setVitesseMoy(20 + rnd.nextDouble() * 40);            // vitesse moyenne
            m.setTauxEmbouteillage(rnd.nextDouble());               // congestion
            m.setTypeVehicule(i % 2 == 0 ? "Voiture" : "Poids Lourd"); // alternance type véhicule
            m.setCapteur(capteur);

            em.persist(m);
            if (i % 100 == 0) {
                em.flush();
                em.clear();
            }
        }
        em.getTransaction().commit();
        em.close();
        long t1 = System.currentTimeMillis();
        System.out.println("✅ 10 000 mesures trafic insérées en (ms) = " + (t1 - t0));
    }
}
