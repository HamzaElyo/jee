package com.streaming.dashboard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, java.io.IOException {

        String page = req.getParameter("page");
        String jspPath;

        if (page == null || page.isEmpty() || page.equals("home")) {
            jspPath = "/WEB-INF/home.jsp";
        } else {
            switch (page) {
                case "videos":
                    jspPath = "/WEB-INF/views/videos.jsp";
                    break;
                case "users":
                    jspPath = "/WEB-INF/views/users.jsp";
                    break;
                case "analytics":
                    jspPath = "/WEB-INF/views/analytics.jsp";
                    break;
                case "collections":
                    jspPath = "/WEB-INF/views/collections.jsp";
                    break;
                case "events":
                    jspPath = "/WEB-INF/views/events.jsp";
                    break;
                case "settings":
                    jspPath = "/WEB-INF/views/settings.jsp";
                    break;
                default:
                    jspPath = "/WEB-INF/home.jsp";
            }
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}
