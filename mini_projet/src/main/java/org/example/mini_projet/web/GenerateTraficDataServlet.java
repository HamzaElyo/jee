package org.example.mini_projet.web;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import jakarta.persistence.EntityManager;
import org.example.mini_projet.dao.JpaUtil;
import org.example.mini_projet.model.CapteurTrafic;
import org.example.mini_projet.model.MesureTrafic;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Random;

@WebServlet("/generateTrafic")
public class GenerateTraficDataServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int n = Integer.parseInt(req.getParameter("n"));
        String zone = req.getParameter("zone");
        String typeVehicule = req.getParameter("typeVehicule");

        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();

        // Création d'un capteur pour cette génération (adapter si tu veux en sélectionner un existant)
        CapteurTrafic capteur = new CapteurTrafic();
        capteur.setNom("Capteur " + zone);
        capteur.setType("Débit");
        capteur.setZone(zone);
        capteur.setLocalisation("Place centrale " + zone);
        em.persist(capteur);

        Random rnd = new Random();
        for (int i = 0; i < n; i++) {
            MesureTrafic mesure = new MesureTrafic();
            mesure.setDateHeure(LocalDateTime.now().minusMinutes(rnd.nextInt(10000)));
            mesure.setVehicules(5 + rnd.nextInt(80));       // nombre de véhicules
            mesure.setVitesseMoy(20 + rnd.nextDouble() * 40);         // vitesse moyenne
            mesure.setTauxEmbouteillage(rnd.nextDouble()); // >=0, <=1 (0=pas d'embouteillage, 1=max congestion)
            mesure.setTypeVehicule(typeVehicule);
            mesure.setCapteur(capteur);
            em.persist(mesure);
            if (i % 100 == 0) { em.flush(); em.clear(); }
        }

        em.getTransaction().commit();
        em.close();
        resp.sendRedirect("mesuresTrafic");
    }
}
