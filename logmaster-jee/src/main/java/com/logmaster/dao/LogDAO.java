package com.logmaster.dao;

import com.logmaster.entity.OrderStatus;
import com.mongodb.client.*;
import com.mongodb.client.model.Updates;
import com.mongodb.client.model.Indexes;
import org.bson.Document;
import org.bson.types.ObjectId;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Sorts.*;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.ejb.Stateless;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Stateless
public class LogDAO {

        private MongoClient mongoClient;
        private MongoDatabase database;
        private MongoCollection<Document> logsCollection;

        @PostConstruct
        public void init() {
                try {
                        // In production, this URI should come from configuration
                        mongoClient = MongoClients.create(
                                        "mongodb+srv://@cluster0.i5tlvj3.mongodb.net/?appName=Cluster0");
                        database = mongoClient.getDatabase("logmaster_db");
                        logsCollection = database.getCollection("application_logs");

                        // Create index for faster querying
                        logsCollection.createIndex(Indexes.descending("timestamp"));
                        logsCollection.createIndex(new Document("level", 1));
                        logsCollection.createIndex(new Document("service", 1));
                } catch (Exception e) {
                        System.err.println("Failed to initialize MongoDB: " + e.getMessage());
                        // e.printStackTrace(); // Optional: print full stack trace
                        // Don't rethrow, so deployment succeeds even if Mongo is down
                }
        }

        public void logOrderCreation(Long orderId, String userEmail, BigDecimal amount, String address) {
                Document log = new Document()
                                .append("timestamp", new Date())
                                .append("level", "INFO")
                                .append("event_type", "ORDER_CREATED")
                                .append("service", "order-service")
                                .append("message", "New order created")
                                .append("metadata", new Document()
                                                .append("order_id", orderId)
                                                .append("user_email", userEmail)
                                                .append("amount", amount.doubleValue())
                                                .append("shipping_address", address));

                logsCollection.insertOne(log);
        }

        public void logStatusChange(Long orderId, OrderStatus oldStatus, OrderStatus newStatus) {
                Document log = new Document()
                                .append("timestamp", new Date())
                                .append("level", "INFO")
                                .append("event_type", "ORDER_STATUS_CHANGED")
                                .append("service", "order-service")
                                .append("message",
                                                String.format("Order status changed: %s -> %s", oldStatus, newStatus))
                                .append("metadata", new Document()
                                                .append("order_id", orderId)
                                                .append("old_status", oldStatus.toString())
                                                .append("new_status", newStatus.toString()));

                logsCollection.insertOne(log);
        }

        public void logOrderCancellation(Long orderId, String reason) {
                Document log = new Document()
                                .append("timestamp", new Date())
                                .append("level", "WARNING")
                                .append("event_type", "ORDER_CANCELLED")
                                .append("service", "order-service")
                                .append("message", "Order cancelled: " + reason)
                                .append("metadata", new Document()
                                                .append("order_id", orderId)
                                                .append("reason", reason));

                logsCollection.insertOne(log);
        }

        public void logOrderDeletion(Long orderId) {
                Document log = new Document()
                                .append("timestamp", new Date())
                                .append("level", "WARNING")
                                .append("event_type", "ORDER_DELETED")
                                .append("service", "order-service")
                                .append("message", "Order permanently deleted")
                                .append("metadata", new Document("order_id", orderId));

                logsCollection.insertOne(log);
        }

        public void logErrorLogs(String message, String service) {
                if (logsCollection == null)
                        return;
                try {
                        Document log = new Document()
                                        .append("timestamp", new Date())
                                        .append("level", "ERROR")
                                        .append("event_type", "SYSTEM_ERROR")
                                        .append("service", service)
                                        .append("message", message);

                        logsCollection.insertOne(log);
                } catch (Exception e) {
                        System.err.println("Failed to log error: " + e.getMessage());
                }
        }

        public void logError(String service, String message, String stackTrace) {
                if (logsCollection == null)
                        return;
                Document log = new Document()
                                .append("timestamp", new Date())
                                .append("level", "ERROR")
                                .append("event_type", "SYSTEM_ERROR")
                                .append("service", service)
                                .append("message", message)
                                .append("stack_trace", stackTrace);

                logsCollection.insertOne(log);
        }

        public List<Document> getRecentLogs(int limit) {
                if (logsCollection == null)
                        return new java.util.ArrayList<>();
                return logsCollection.find()
                                .sort(descending("timestamp"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        public List<Document> getLogsByLevel(String level, int limit) {
                return logsCollection.find(eq("level", level))
                                .sort(descending("timestamp"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        public List<Document> getLogsByService(String service, int limit) {
                return logsCollection.find(eq("service", service))
                                .sort(descending("timestamp"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        public long countByLevel(String level) {
                if (logsCollection == null)
                        return 0;
                return logsCollection.countDocuments(eq("level", level));
        }

        public long countErrorLogs() {
                if (logsCollection == null)
                        return 0;
                return countByLevel("ERROR");
        }

        public long countWarningLogs() {
                if (logsCollection == null)
                        return 0;
                return countByLevel("WARNING");
        }

        public List<Document> getTopActiveUsers(int limit) {
                List<Document> pipeline = Arrays.asList(
                                new Document("$match", new Document("event_type", "ORDER_CREATED")),
                                new Document("$group", new Document()
                                                .append("_id", "$metadata.user_email")
                                                .append("order_count", new Document("$sum", 1))),
                                new Document("$sort", new Document("order_count", -1)),
                                new Document("$limit", limit));
                return logsCollection.aggregate(pipeline).into(new ArrayList<>());
        }

        public List<Document> getEventStatistics() {
                List<Document> pipeline = Arrays.asList(
                                new Document("$group", new Document()
                                                .append("_id", "$event_type")
                                                .append("count", new Document("$sum", 1))),
                                new Document("$sort", new Document("count", -1)));
                return logsCollection.aggregate(pipeline).into(new ArrayList<>());
        }

        public List<Document> getErrorsByServiceLast24h() {
                Date twentyFourHoursAgo = new Date(System.currentTimeMillis() - 86400000);
                List<Document> pipeline = Arrays.asList(
                                new Document("$match", new Document()
                                                .append("level", "ERROR")
                                                .append("timestamp", new Document("$gte", twentyFourHoursAgo))),
                                new Document("$group", new Document()
                                                .append("_id", "$service")
                                                .append("error_count", new Document("$sum", 1))
                                                .append("last_error", new Document("$max", "$timestamp"))),
                                new Document("$sort", new Document("error_count", -1)));
                return logsCollection.aggregate(pipeline).into(new ArrayList<>());
        }

        public List<Document> getLogsDistributionByHour() {
                Date twentyFourHoursAgo = new Date(System.currentTimeMillis() - 86400000);
                List<Document> pipeline = Arrays.asList(
                                new Document("$match", new Document("timestamp",
                                                new Document("$gte", twentyFourHoursAgo))),
                                new Document("$addFields", new Document("hour",
                                                new Document("$hour", "$timestamp"))),
                                new Document("$group", new Document()
                                                .append("_id", new Document()
                                                                .append("hour", "$hour")
                                                                .append("level", "$level"))
                                                .append("count", new Document("$sum", 1))),
                                new Document("$sort", new Document("_id.hour", 1)));
                return logsCollection.aggregate(pipeline).into(new ArrayList<>());
        }

        @PreDestroy
        public void cleanup() {
                if (mongoClient != null) {
                        mongoClient.close();
                }
        }
}
