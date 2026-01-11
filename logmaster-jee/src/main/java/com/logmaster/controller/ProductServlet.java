package com.logmaster.controller;

import com.logmaster.entity.Product;
import com.logmaster.service.ProductService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

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
                    listProducts(req, resp);
                    break;
                case "form":
                    showForm(req, resp);
                    break;
                case "delete":
                    deleteProduct(req, resp);
                    break;
                default:
                    listProducts(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("create".equals(action)) {
            createProduct(req, resp);
        } else if ("update".equals(action)) {
            updateProduct(req, resp);
        } else {
            resp.sendRedirect("products");
        }
    }

    private void listProducts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> products = productService.getAllProducts();
        req.setAttribute("products", products);
        req.getRequestDispatcher("/WEB-INF/views/productList.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            Product product = productService.getProductById(id);
            req.setAttribute("product", product);
        }
        req.getRequestDispatcher("/WEB-INF/views/productForm.jsp").forward(req, resp);
    }

    private void createProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        BigDecimal price = new BigDecimal(req.getParameter("price"));
        Integer stock = Integer.parseInt(req.getParameter("stock"));
        String category = req.getParameter("category");

        Product product = new Product(name, price, stock, category);
        productService.createProduct(product);
        resp.sendRedirect("products");
    }

    private void updateProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        String name = req.getParameter("name");
        BigDecimal price = new BigDecimal(req.getParameter("price"));
        Integer stock = Integer.parseInt(req.getParameter("stock"));
        String category = req.getParameter("category");

        Product product = productService.getProductById(id);
        if (product != null) {
            product.setName(name);
            product.setPrice(price);
            product.setStock(stock);
            product.setCategory(category);
            productService.updateProduct(product);
        }
        resp.sendRedirect("products");
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        productService.deleteProduct(id);
        resp.sendRedirect("products");
    }
}
