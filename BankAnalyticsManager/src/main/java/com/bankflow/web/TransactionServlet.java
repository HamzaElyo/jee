package com.bankflow.web;

import com.bankflow.dao.*;
import com.bankflow.service.BankService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {
    private CompteDao compteDao = new CompteDao();
    private TransactionDao transactionDao = new TransactionDao();
    private BankService bankService = new BankService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String compteId = req.getParameter("compteId");
        if (compteId != null) {
            req.setAttribute("transactions",
                    transactionDao.findByCompteId(Long.parseLong(compteId)));
        } else {
            req.setAttribute("transactions", transactionDao.findRecentTransactions(50));
        }

        req.setAttribute("comptes", compteDao.findAll());
        req.getRequestDispatcher("/pages/transactions.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Long compteId = Long.parseLong(req.getParameter("compteId"));
        BigDecimal montant = new BigDecimal(req.getParameter("montant"));
        String description = req.getParameter("description");

        try {
            if ("depot".equals(action)) {
                bankService.effectuerDepot(compteId, montant, description);
            } else if ("retrait".equals(action)) {
                bankService.effectuerRetrait(compteId, montant, description);
            } else if ("virement".equals(action)) {
                Long compteDestId = Long.parseLong(req.getParameter("compteDestId"));
                bankService.effectuerVirement(compteId, compteDestId, montant, description);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
            return;
        }

        resp.sendRedirect("transactions");
    }
}