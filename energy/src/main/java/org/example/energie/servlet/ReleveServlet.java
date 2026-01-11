package org.example.energie.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.energie.dao.CompteurDao;
import org.example.energie.dao.ReleveDao;
import org.example.energie.model.CompteurIntelligent;
import org.example.energie.model.ReleveConsommation;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/releves")
public class ReleveServlet extends HttpServlet {
    private CompteurDao compteurDao = new CompteurDao();
    private ReleveDao releveDao = new ReleveDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("compteurs", compteurDao.findAll());
        req.setAttribute("stats", releveDao.getStatsByType());
        req.getRequestDispatcher("/pages/releves.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long compteurId = Long.parseLong(req.getParameter("compteurId"));
        String unite = req.getParameter("unite");
        double valeur = Double.parseDouble(req.getParameter("valeur"));
        CompteurIntelligent compteur = compteurDao.findById(compteurId);
        if (compteur != null) {
            ReleveConsommation r = new ReleveConsommation();
            r.setDateHeure(LocalDateTime.now());
            r.setValeur(valeur);
            r.setUnite(unite);
            r.setCompteur(compteur);
            releveDao.save(r);
        }
        resp.sendRedirect("releves");
    }
}
