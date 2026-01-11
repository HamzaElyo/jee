package com.streaming.analytics.util;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Produces;

import java.util.concurrent.TimeUnit;

/**
 * CDI producer for native MongoDB client.
 * Uses lazy initialization with connection pool settings.
 */
@ApplicationScoped
public class MongoProducer {

    private volatile MongoClient mongoClient;
    private volatile MongoDatabase database;

    private synchronized void ensureInitialized() {
        if (mongoClient == null) {
            System.out.println("[MongoProducer] Connecting to MongoDB (streaming_analytics)...");
            try {
                // Connection string with authentication
                ConnectionString connString = new ConnectionString(
                        "mongodb://admin:admin123@localhost:27017/streaming_analytics?authSource=admin");

                // Build settings with proper timeouts
                MongoClientSettings settings = MongoClientSettings.builder()
                        .applyConnectionString(connString)
                        .applyToSocketSettings(builder -> builder.connectTimeout(5, TimeUnit.SECONDS)
                                .readTimeout(10, TimeUnit.SECONDS))
                        .applyToClusterSettings(builder -> builder.serverSelectionTimeout(10, TimeUnit.SECONDS))
                        .applyToConnectionPoolSettings(builder -> builder.maxSize(10)
                                .minSize(2)
                                .maxWaitTime(10, TimeUnit.SECONDS))
                        .build();

                mongoClient = MongoClients.create(settings);
                database = mongoClient.getDatabase("streaming_analytics");

                // Test connection immediately
                database.listCollectionNames().first();
                System.out.println("[MongoProducer] Successfully connected to MongoDB!");
            } catch (Exception e) {
                System.err.println("[MongoProducer] Failed to connect to MongoDB: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("MongoDB connection failed", e);
            }
        }
    }

    @Produces
    @ApplicationScoped
    public MongoDatabase getDatabase() {
        ensureInitialized();
        return database;
    }

    @Produces
    @ApplicationScoped
    public MongoClient getMongoClient() {
        ensureInitialized();
        return mongoClient;
    }

    @PreDestroy
    public void close() {
        if (mongoClient != null) {
            System.out.println("[MongoProducer] Closing MongoDB connection");
            mongoClient.close();
        }
    }
}
