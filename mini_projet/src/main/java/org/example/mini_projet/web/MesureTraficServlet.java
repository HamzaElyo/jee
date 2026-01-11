package org.example.mini_projet.web;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.mini_projet.dao.CapteurTraficDao;
import org.example.mini_projet.dao.MesureTraficDao;
import org.example.mini_projet.model.CapteurTrafic;
import org.example.mini_projet.model.MesureTrafic;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/mesuresTrafic")
public class MesureTraficServlet extends HttpServlet {
    private CapteurTraficDao capteurDao = new CapteurTraficDao();
    private MesureTraficDao mesureDao = new MesureTraficDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("capteurs", capteurDao.findAll());
        req.setAttribute("stats", mesureDao.getStatsByTypeVehicule());
        req.setAttribute("statsZone", mesureDao.getStatsByZone());
        req.getRequestDispatcher("/pages/mesuresTrafic.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long capteurId = Long.parseLong(req.getParameter("capteurId"));
        String typeVehicule = req.getParameter("typeVehicule");
        double vitesse = Double.parseDouble(req.getParameter("vitesseMoy"));
        int vehicules = Integer.parseInt(req.getParameter("vehicules"));
        double embouteillage = Double.parseDouble(req.getParameter("tauxEmbouteillage"));

        CapteurTrafic capteur = capteurDao.findById(capteurId);
        if (capteur != null) {
            MesureTrafic m = new MesureTrafic();
            m.setDateHeure(LocalDateTime.now());
            m.setVehicules(vehicules);
            m.setVitesseMoy(vitesse);
            m.setTauxEmbouteillage(embouteillage);
            m.setTypeVehicule(typeVehicule);
            m.setCapteur(capteur);
            mesureDao.save(m);
        }
        resp.sendRedirect("mesuresTrafic");
    }
}
