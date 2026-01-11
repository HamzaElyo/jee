package com.logmaster.service;

import com.logmaster.dao.LogDAO;
import com.logmaster.entity.Order;
import com.logmaster.entity.OrderStatus;
import com.logmaster.entity.User;
import jakarta.ejb.EJB;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Stateless
public class OrderService {

    @PersistenceContext(unitName = "LogMasterPU")
    private EntityManager em;

    @EJB
    private LogDAO logDAO;

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Order createOrderWithLog(Long userId, String address, java.util.Map<Long, Integer> productQuantities) {
        // 1. Create Order in PostgreSQL
        User user = em.find(User.class, userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found with ID: " + userId);
        }

        Order order = new Order();
        order.setUser(user);
        order.setOrderDate(LocalDateTime.now());
        order.setStatus(OrderStatus.PENDING);
        order.setShippingAddress(address);

        // Process items
        BigDecimal totalAmount = BigDecimal.ZERO;
        java.util.List<com.logmaster.entity.OrderItem> items = new java.util.ArrayList<>();

        for (java.util.Map.Entry<Long, Integer> entry : productQuantities.entrySet()) {
            Long productId = entry.getKey();
            Integer quantity = entry.getValue();

            if (quantity <= 0)
                continue;

            com.logmaster.entity.Product product = em.find(com.logmaster.entity.Product.class, productId);
            if (product == null) {
                throw new IllegalArgumentException("Product not found with ID: " + productId);
            }

            // Optional: Check stock
            if (product.getStock() < quantity) {
                throw new IllegalArgumentException("Insufficient stock for product: " + product.getName());
            }

            // Update Stock
            product.setStock(product.getStock() - quantity);
            em.merge(product);

            com.logmaster.entity.OrderItem item = new com.logmaster.entity.OrderItem(product, quantity,
                    product.getPrice());
            items.add(item);

            totalAmount = totalAmount.add(product.getPrice().multiply(new BigDecimal(quantity)));
        }

        if (items.isEmpty()) {
            throw new IllegalArgumentException("Order must contain at least one product");
        }

        order.setItems(items);
        order.setTotalAmount(totalAmount);

        em.persist(order);
        em.flush(); // Force ID generation

        // 2. Log in MongoDB
        try {
            logDAO.logOrderCreation(order.getId(), user.getEmail(), totalAmount, address);
        } catch (Exception e) {
            // Rollback JTA transaction if Mongo/DAO fails
            throw new EJBException("Failed to log order creation in MongoDB", e);
        }

        return order;
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void changeStatus(Long orderId, OrderStatus newStatus) {
        Order order = em.find(Order.class, orderId);
        if (order != null) {
            OrderStatus oldStatus = order.getStatus();
            order.setStatus(newStatus);
            em.merge(order);

            try {
                logDAO.logStatusChange(orderId, oldStatus, newStatus);
            } catch (Exception e) {
                throw new EJBException("Failed to log status change", e);
            }
        }
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void cancelOrder(Long orderId, String reason) {
        Order order = em.find(Order.class, orderId);
        if (order != null) {
            order.setStatus(OrderStatus.CANCELLED);
            em.merge(order);

            try {
                logDAO.logOrderCancellation(orderId, reason);
            } catch (Exception e) {
                throw new EJBException("Failed to log cancellation", e);
            }
        }
    }
}
