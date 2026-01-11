package com.logmaster.controller;

import com.logmaster.dao.UserDAO;
import com.logmaster.entity.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    @EJB
    private UserDAO userDAO;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            default:
                listUsers(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createUser(req, resp);
                break;
            case "update":
                updateUser(req, resp);
                break;
            case "delete":
                deleteUser(req, resp);
                break;
            default:
                listUsers(req, resp);
                break;
        }
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> listUser = userDAO.findAll();
        req.setAttribute("listUser", listUser);
        req.getRequestDispatcher("/WEB-INF/views/userList.jsp").forward(req, resp);
    }

    private void showNewForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/userForm.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            User existingUser = userDAO.findById(id);
            req.setAttribute("user", existingUser);
            req.getRequestDispatcher("/WEB-INF/views/userForm.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect("users");
        }
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User newUser = new User(name, email, password);
        userDAO.create(newUser);
        resp.sendRedirect("users");
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            User user = userDAO.findById(id);
            user.setName(name);
            user.setEmail(email);
            // Only update password if provided
            if (password != null && !password.isEmpty()) {
                user.setPassword(password);
            }
            userDAO.update(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect("users");
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            userDAO.delete(id);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        resp.sendRedirect("users");
    }
}
