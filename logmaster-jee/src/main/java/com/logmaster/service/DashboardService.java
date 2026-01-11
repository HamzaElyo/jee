package com.logmaster.service;

import com.logmaster.dao.LogDAO;
import com.logmaster.dao.OrderDAO;
import com.logmaster.dto.DashboardStats;
import com.logmaster.entity.OrderStatus;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;

@Stateless
public class DashboardService {

    @EJB
    private OrderDAO orderDAO;

    @EJB
    private LogDAO logDAO;

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();

        // Postgres Stats
        stats.setPendingOrders(orderDAO.countByStatus(OrderStatus.PENDING));
        stats.setConfirmedOrders(orderDAO.countByStatus(OrderStatus.CONFIRMED));
        stats.setProcessingOrders(orderDAO.countByStatus(OrderStatus.PROCESSING));
        stats.setShippedOrders(orderDAO.countByStatus(OrderStatus.SHIPPED));
        stats.setDeliveredOrders(orderDAO.countByStatus(OrderStatus.DELIVERED));
        stats.setCancelledOrders(orderDAO.countByStatus(OrderStatus.CANCELLED));

        // Mongo Stats
        try {
            stats.setErrorCount(logDAO.countErrorLogs());
            stats.setWarningCount(logDAO.countWarningLogs());
            stats.setTopActiveUsers(logDAO.getTopActiveUsers(5));
            stats.setEventStatistics(logDAO.getEventStatistics());
            stats.setErrorsByService(logDAO.getErrorsByServiceLast24h());
            stats.setRecentLogs(logDAO.getRecentLogs(10));
        } catch (Exception e) {
            // Log error but allow dashboard to load with partial data
            System.err.println("Failed to fetch MongoDB stats: " + e.getMessage());
        }

        return stats;
    }
}
