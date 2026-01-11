package com.bankflow.web;

import com.bankflow.dao.ClientDao;
import com.bankflow.dao.CompteDao;
import com.bankflow.model.Compte;
import com.bankflow.model.TypeCompte;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/comptes")
public class CompteServlet extends HttpServlet {
    private CompteDao compteDao = new CompteDao();
    private ClientDao clientDao = new ClientDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("comptes", compteDao.findAll());
        req.setAttribute("clients", clientDao.findAll());
        req.getRequestDispatcher("/pages/comptes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String numeroCompte = req.getParameter("numeroCompte");
        String typeStr = req.getParameter("type");
        String clientIdStr = req.getParameter("clientId");

        try {
            TypeCompte type = TypeCompte.valueOf(typeStr);
            Long clientId = Long.parseLong(clientIdStr);

            var clientOpt = clientDao.findById(clientId);
            if (clientOpt.isPresent()) {
                Compte compte = new Compte(numeroCompte, type, clientOpt.get());
                compteDao.save(compte);
            } else {
                req.setAttribute("error", "Client non trouvé");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la création du compte: " + e.getMessage());
        }

        resp.sendRedirect("comptes");
    }
}