package org.example.energie.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.energie.dao.CompteurDao;
import org.example.energie.model.CompteurIntelligent;
import java.io.IOException;

@WebServlet("/compteurs")
public class CompteurServlet extends HttpServlet {
    private CompteurDao dao = new CompteurDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("compteurs", dao.findAll());
        req.getRequestDispatcher("/pages/compteurs.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        String type = req.getParameter("type");
        String adresse = req.getParameter("adresse");
        CompteurIntelligent c = new CompteurIntelligent();
        c.setCode(code);
        c.setType(type);
        c.setAdresse(adresse);
        dao.save(c);
        resp.sendRedirect("compteurs");
    }
}
