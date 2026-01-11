package com.bankflow.web;

import com.bankflow.dao.*;
import com.bankflow.external.BankDataApiService;
import com.bankflow.external.ExternalFinancialData;
import com.bankflow.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private ClientDao clientDao = new ClientDao();
    private CompteDao compteDao = new CompteDao();
    private TransactionDao transactionDao = new TransactionDao();
    private BankDataApiService apiService = new BankDataApiService(); // Initialisation une fois

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // === DONNÉES INTERNES DE LA BANQUE ===
            // Récupérer les statistiques avec les associations chargées
            List<Client> clients = clientDao.findAll();
            List<Compte> comptes = compteDao.findAll(); // Utilise maintenant LEFT JOIN FETCH
            List<Transaction> recentTransactions = transactionDao.findRecentTransactions(10);
            List<Object[]> statsComptes = compteDao.getSoldeMoyenParTypeCompte();
            List<Object[]> statsTransactions = transactionDao.getStatsTransactionsParMois();

            // === DONNÉES EXTERNES DE L'API ===
            ExternalFinancialData marketData = apiService.fetchMarketData();

            // === PASSER TOUTES LES DONNÉES À LA JSP ===
            req.setAttribute("totalClients", clients.size());
            req.setAttribute("totalComptes", comptes.size());
            req.setAttribute("recentTransactions", recentTransactions);
            req.setAttribute("statsComptes", statsComptes);
            req.setAttribute("statsTransactions", statsTransactions);
            req.setAttribute("marketData", marketData); // Données externes

            req.getRequestDispatcher("/pages/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            // Gestion d'erreur - vous pouvez rediriger vers une page d'erreur
            req.setAttribute("errorMessage", "Erreur lors du chargement du dashboard");
            req.getRequestDispatcher("/pages/error.jsp").forward(req, resp);
        }
    }
}