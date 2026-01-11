package com.elearning.dashboard.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet principal du dashboard
 */
@WebServlet(urlPatterns = { "/dashboard", "/dashboard/*" })
public class DashboardServlet extends HttpServlet {

    private static final String API_BASE_URL = "http://localhost:8080/analytics-api/api/v1/analytics";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String view;

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/home")) {
            view = "/WEB-INF/views/home.jsp";
        } else {
            switch (pathInfo) {
                case "/courses":
                    view = "/WEB-INF/views/courses.jsp";
                    break;
                case "/videos":
                    view = "/WEB-INF/views/videos.jsp";
                    break;
                case "/students":
                    view = "/WEB-INF/views/students.jsp";
                    break;
                case "/analytics":
                    view = "/WEB-INF/views/analytics.jsp";
                    break;
                case "/predictions":
                    view = "/WEB-INF/views/predictions.jsp";
                    break;
                case "/settings":
                    view = "/WEB-INF/views/settings.jsp";
                    break;
                default:
                    view = "/WEB-INF/views/home.jsp";
            }
        }

        request.setAttribute("apiBaseUrl", API_BASE_URL);
        request.getRequestDispatcher(view).forward(request, response);
    }
}
