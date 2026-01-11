package com.bankflow.web;

import com.bankflow.dao.CompteDao;
import com.bankflow.dao.TransactionDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {
    private CompteDao compteDao = new CompteDao();
    private TransactionDao transactionDao = new TransactionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("statsComptes", compteDao.getSoldeMoyenParTypeCompte());
        req.setAttribute("statsTransactions", transactionDao.getStatsTransactionsParMois());
        req.getRequestDispatcher("/pages/rapports.jsp").forward(req, resp);
    }
}