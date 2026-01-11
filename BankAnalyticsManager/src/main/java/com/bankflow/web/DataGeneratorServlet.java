package com.bankflow.web;

import com.bankflow.service.BankService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/generate-data")
public class DataGeneratorServlet extends HttpServlet {
    private BankService bankService = new BankService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        bankService.genererDonneesTest();
        resp.sendRedirect("dashboard");
    }
}