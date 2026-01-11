package com.bankflow.web;

import com.bankflow.dao.ClientDao;
import com.bankflow.model.Client;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {
    private ClientDao clientDao = new ClientDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("clients", clientDao.findAll());
        req.getRequestDispatcher("/pages/clients.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));

        } else {
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String email = req.getParameter("email");
            String telephone = req.getParameter("telephone");
            String adresse = req.getParameter("adresse");
            String ville = req.getParameter("ville");
            String codePostal = req.getParameter("codePostal");
            String numeroSecuriteSociale = req.getParameter("numeroSecuriteSociale");

            Client client = new Client();
            client.setNom(nom);
            client.setPrenom(prenom);
            client.setEmail(email);
            client.setTelephone(telephone);
            client.setAdresse(adresse);
            client.setVille(ville);
            client.setCodePostal(codePostal);
            client.setNumeroSecuriteSociale(numeroSecuriteSociale);

            clientDao.save(client);
        }

        resp.sendRedirect("clients");
    }
}