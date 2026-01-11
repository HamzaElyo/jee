package com.logmaster.controller;

import com.logmaster.dao.OrderDAO;
import com.logmaster.dao.UserDAO;
import com.logmaster.entity.Order;
import com.logmaster.entity.OrderStatus;
import com.logmaster.entity.User;
import com.logmaster.service.OrderService;
import com.logmaster.service.ProductService;
import jakarta.ejb.EJB;
import jakarta.ejb.EJBException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    @EJB
    private OrderService orderService;
    @EJB
    private OrderDAO orderDAO;
    @EJB
    private UserDAO userDAO;

    @EJB
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "list":
                    List<Order> orders = orderDAO.findAll();
                    req.setAttribute("orders", orders);
                    req.getRequestDispatcher("/WEB-INF/views/orderList.jsp").forward(req, resp);
                    break;
                case "details":
                    Long id = Long.parseLong(req.getParameter("id"));
                    Order order = orderDAO.findByIdWithItems(id);
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/WEB-INF/views/orderDetail.jsp").forward(req, resp);
                    break;
                case "form":
                    List<User> users = userDAO.findAll();
                    req.setAttribute("users", users);
                    List<com.logmaster.entity.Product> products = productService.getAllProducts();
                    req.setAttribute("products", products);
                    req.getRequestDispatcher("/WEB-INF/views/orderForm.jsp").forward(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                Long userId = Long.parseLong(req.getParameter("userId"));
                String address = req.getParameter("address");

                // Parse products
                java.util.Map<Long, Integer> productQuantities = new java.util.HashMap<>();
                String[] productIds = req.getParameterValues("productIds");

                if (productIds != null) {
                    for (String pId : productIds) {
                        String qtyStr = req.getParameter("qty_" + pId);
                        if (qtyStr != null && !qtyStr.isEmpty()) {
                            int qty = Integer.parseInt(qtyStr);
                            if (qty > 0) {
                                productQuantities.put(Long.parseLong(pId), qty);
                            }
                        }
                    }
                }

                orderService.createOrderWithLog(userId, address, productQuantities);
                resp.sendRedirect(req.getContextPath() + "/orders?action=list");

            } else if ("cancel".equals(action)) {
                Long orderId = Long.parseLong(req.getParameter("orderId"));
                String reason = req.getParameter("reason");
                orderService.cancelOrder(orderId, reason);
                resp.sendRedirect(req.getContextPath() + "/orders?action=details&id=" + orderId);

            } else if ("status".equals(action)) {
                Long orderId = Long.parseLong(req.getParameter("orderId"));
                OrderStatus status = OrderStatus.valueOf(req.getParameter("status"));
                orderService.changeStatus(orderId, status);
                resp.sendRedirect(req.getContextPath() + "/orders?action=details&id=" + orderId);
            }
        } catch (EJBException e) {
            req.setAttribute("error", "Transaction Failed: "
                    + (e.getCausedByException() != null ? e.getCausedByException().getMessage() : e.getMessage()));
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, resp);
        }
    }
}
