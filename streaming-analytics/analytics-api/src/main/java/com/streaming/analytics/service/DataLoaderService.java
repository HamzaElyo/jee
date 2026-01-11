package com.streaming.analytics.service;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.ReplaceOptions;
import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * Service to load initial data (videos catalog) into MongoDB
 */
@ApplicationScoped
public class DataLoaderService {

    @Inject
    private MongoDatabase database;

    private volatile boolean dataLoaded = false;

    /**
     * Load videos from JSON data into MongoDB
     */
    public void loadVideosFromJson(String jsonContent) {
        try {
            MongoCollection<Document> collection = database.getCollection("videos");

            // Parse JSON array
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> videos = parseJsonArray(jsonContent);

            int count = 0;
            for (Map<String, Object> videoMap : videos) {
                String videoId = (String) videoMap.get("videoId");
                if (videoId == null)
                    continue;

                Document doc = new Document()
                        .append("_id", videoId)
                        .append("videoId", videoId)
                        .append("title", videoMap.get("title"))
                        .append("category", videoMap.get("category"))
                        .append("duration", videoMap.get("duration"))
                        .append("uploadDate", videoMap.get("uploadDate"))
                        .append("views", videoMap.get("views"))
                        .append("likes", videoMap.get("likes"));

                collection.replaceOne(
                        new Document("_id", videoId),
                        doc,
                        new ReplaceOptions().upsert(true));
                count++;
            }

            System.out.println("[DataLoader] Loaded " + count + " videos into MongoDB");
            dataLoaded = true;
        } catch (Exception e) {
            System.err.println("[DataLoader] Error loading videos: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Simple JSON array parser (basic implementation)
     */
    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> parseJsonArray(String json) {
        // Use simple regex-based parsing or a library
        // For now, we'll use a simple approach
        try {
            // Try using built-in JSON-B if available
            jakarta.json.bind.Jsonb jsonb = jakarta.json.bind.JsonbBuilder.create();
            return jsonb.fromJson(json, List.class);
        } catch (Exception e) {
            System.err.println("[DataLoader] JSON parsing error: " + e.getMessage());
            return List.of();
        }
    }

    public boolean isDataLoaded() {
        return dataLoaded;
    }

    public long getVideosCount() {
        return database.getCollection("videos").countDocuments();
    }

    public long getEventsCount() {
        return database.getCollection("view_events").countDocuments();
    }
}
