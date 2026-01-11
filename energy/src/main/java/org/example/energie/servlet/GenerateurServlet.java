package org.example.energie.servlet;


import jakarta.persistence.EntityManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.energie.dao.JpaUtil;
import org.example.energie.model.CompteurIntelligent;
import org.example.energie.model.ReleveConsommation;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Random;

@WebServlet("/generateur")
public class GenerateurServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        String type = req.getParameter("type");
        String adresse = req.getParameter("adresse");
        String unite = req.getParameter("unite");
        int n = Integer.parseInt(req.getParameter("n"));

        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        CompteurIntelligent c = new CompteurIntelligent();
        c.setCode(code);
        c.setType(type);
        c.setAdresse(adresse);
        em.persist(c);
        Random rnd = new Random();
        for (int i = 0; i < n; i++) {
            ReleveConsommation r = new ReleveConsommation();
            r.setDateHeure(LocalDateTime.now().minusMinutes(rnd.nextInt(10000)));
            r.setValeur(100 + rnd.nextDouble() * 200);
            r.setUnite(unite);
            r.setCompteur(c);
            em.persist(r);
            if (i % 100 == 0) { em.flush(); em.clear(); }
        }
        em.getTransaction().commit();
        em.close();

        req.setAttribute("message", "✅ " + n + " relevés générés pour le compteur " + code);
        req.getRequestDispatcher("/pages/generateur.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/pages/generateur.jsp").forward(req, resp);
    }
}
