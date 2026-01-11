package com.elearning.analytics.util;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Produces;

/**
 * CDI Producer pour MongoDB
 * Also provides static access for non-CDI contexts (SSE threads)
 */
@ApplicationScoped
public class MongoProducer {

    private static final String MONGO_URI = "mongodb://admin:admin123@localhost:27017";
    private static final String DATABASE_NAME = "elearning_analytics";

    private MongoClient mongoClient;

    // Static instance for non-CDI access
    private static MongoDatabase staticDatabase;
    private static MongoClient staticClient;

    @PostConstruct
    public void init() {
        mongoClient = MongoClients.create(MONGO_URI);
        // Also init static reference
        if (staticClient == null) {
            staticClient = MongoClients.create(MONGO_URI);
            staticDatabase = staticClient.getDatabase(DATABASE_NAME);
        }
    }

    @Produces
    @ApplicationScoped
    public MongoDatabase produceDatabase() {
        return mongoClient.getDatabase(DATABASE_NAME);
    }

    /**
     * Static method for non-CDI contexts (background threads)
     */
    public static MongoDatabase getDatabase() {
        if (staticDatabase == null) {
            staticClient = MongoClients.create(MONGO_URI);
            staticDatabase = staticClient.getDatabase(DATABASE_NAME);
        }
        return staticDatabase;
    }

    @PreDestroy
    public void cleanup() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
