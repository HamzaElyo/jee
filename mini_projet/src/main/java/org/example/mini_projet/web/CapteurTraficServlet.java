package org.example.mini_projet.web;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.mini_projet.dao.CapteurTraficDao;
import org.example.mini_projet.model.CapteurTrafic;

import java.io.IOException;

@WebServlet("/capteursTrafic")
public class CapteurTraficServlet extends HttpServlet {
    private CapteurTraficDao dao = new CapteurTraficDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("capteurs", dao.findAll());
        req.getRequestDispatcher("/pages/capteursTrafic.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String type = req.getParameter("type");
        String localisation = req.getParameter("localisation");
        String zone = req.getParameter("zone");

        CapteurTrafic capteur = new CapteurTrafic();
        capteur.setNom(nom);
        capteur.setType(type);
        capteur.setLocalisation(localisation);
        capteur.setZone(zone);

        dao.save(capteur);
        resp.sendRedirect("capteursTrafic");
    }
}
