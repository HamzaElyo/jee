package com.streaming.analytics.repository;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.ReplaceOptions;
import com.mongodb.client.model.Sorts;
import com.streaming.analytics.model.VideoStats;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.util.*;

import static com.mongodb.client.model.Filters.eq;

@ApplicationScoped
public class VideoStatsRepository {

    @Inject
    private MongoDatabase database;

    private MongoCollection<Document> getCollection() {
        return database.getCollection("video_stats");
    }

    private MongoCollection<Document> getEventsCollection() {
        return database.getCollection("events");
    }

    public void save(VideoStats stats) {
        Document doc = new Document()
                .append("_id", stats.getVideoId())
                .append("videoId", stats.getVideoId())
                .append("totalViews", stats.getTotalViews())
                .append("avgDuration", stats.getAvgDuration())
                .append("lastUpdated", stats.getLastUpdated() != null ? stats.getLastUpdated() : new Date());

        getCollection().replaceOne(
                eq("_id", stats.getVideoId()),
                doc,
                new ReplaceOptions().upsert(true));
    }

    public Optional<VideoStats> findById(String videoId) {
        // Try video_stats collection first
        Document doc = getCollection().find(eq("_id", videoId)).first();
        if (doc != null) {
            return Optional.of(documentToVideoStats(doc));
        }

        // Calculate from events if not found
        return calculateStatsForVideo(videoId);
    }

    /**
     * Get top videos by aggregating from events collection
     */
    public List<VideoStats> getTopVideos(int limit) {
        List<VideoStats> result = new ArrayList<>();

        // Aggregate from events collection to get real-time stats
        List<Document> pipeline = Arrays.asList(
                new Document("$group", new Document()
                        .append("_id", "$videoId")
                        .append("totalViews", new Document("$sum", 1))
                        .append("avgDuration", new Document("$avg", "$duration"))),
                new Document("$sort", new Document("totalViews", -1)),
                new Document("$limit", limit));

        AggregateIterable<Document> aggregation = getEventsCollection().aggregate(pipeline);

        for (Document doc : aggregation) {
            VideoStats stats = new VideoStats();
            stats.setVideoId(doc.getString("_id"));

            Object totalViewsObj = doc.get("totalViews");
            if (totalViewsObj instanceof Number) {
                stats.setTotalViews(((Number) totalViewsObj).longValue());
            }

            Object avgDurationObj = doc.get("avgDuration");
            if (avgDurationObj instanceof Number) {
                stats.setAvgDuration(((Number) avgDurationObj).doubleValue());
            }

            stats.setLastUpdated(new Date());
            result.add(stats);
        }

        return result;
    }

    private Optional<VideoStats> calculateStatsForVideo(String videoId) {
        List<Document> pipeline = Arrays.asList(
                new Document("$match", new Document("videoId", videoId)),
                new Document("$group", new Document()
                        .append("_id", "$videoId")
                        .append("totalViews", new Document("$sum", 1))
                        .append("avgDuration", new Document("$avg", "$duration"))));

        Document doc = getEventsCollection().aggregate(pipeline).first();
        if (doc == null) {
            return Optional.empty();
        }

        VideoStats stats = new VideoStats();
        stats.setVideoId(videoId);

        Object totalViewsObj = doc.get("totalViews");
        if (totalViewsObj instanceof Number) {
            stats.setTotalViews(((Number) totalViewsObj).longValue());
        }

        Object avgDurationObj = doc.get("avgDuration");
        if (avgDurationObj instanceof Number) {
            stats.setAvgDuration(((Number) avgDurationObj).doubleValue());
        }

        stats.setLastUpdated(new Date());
        return Optional.of(stats);
    }

    private VideoStats documentToVideoStats(Document doc) {
        VideoStats stats = new VideoStats();
        stats.setVideoId(doc.getString("videoId"));

        Object totalViewsObj = doc.get("totalViews");
        if (totalViewsObj instanceof Number) {
            stats.setTotalViews(((Number) totalViewsObj).longValue());
        } else {
            stats.setTotalViews(0L);
        }

        Object avgDurationObj = doc.get("avgDuration");
        if (avgDurationObj instanceof Number) {
            stats.setAvgDuration(((Number) avgDurationObj).doubleValue());
        } else {
            stats.setAvgDuration(0.0);
        }

        stats.setLastUpdated(doc.getDate("lastUpdated"));
        return stats;
    }
}
