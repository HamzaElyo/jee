package com.streaming.analytics.repository;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.ReplaceOptions;
import com.streaming.analytics.model.Video;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.mongodb.client.model.Filters.eq;

@ApplicationScoped
public class VideoRepository {

    @Inject
    private MongoDatabase database;

    private MongoCollection<Document> getCollection() {
        return database.getCollection("Video");
    }

    public void save(Video video) {
        Document doc = new Document()
                .append("_id", video.getVideoId())
                .append("videoId", video.getVideoId())
                .append("title", video.getTitle())
                .append("category", video.getCategory())
                .append("duration", video.getDuration())
                .append("uploadDate", video.getUploadDate())
                .append("views", video.getViews())
                .append("likes", video.getLikes());

        getCollection().replaceOne(
                eq("_id", video.getVideoId()),
                doc,
                new ReplaceOptions().upsert(true));
    }

    public Optional<Video> findById(String videoId) {
        Document doc = getCollection().find(eq("_id", videoId)).first();
        if (doc == null) {
            return Optional.empty();
        }
        return Optional.of(documentToVideo(doc));
    }

    public List<Video> findByCategory(String category) {
        List<Video> result = new ArrayList<>();
        for (Document doc : getCollection().find(eq("category", category)).limit(50)) {
            result.add(documentToVideo(doc));
        }
        return result;
    }

    public List<Video> findAll(int limit) {
        List<Video> result = new ArrayList<>();
        for (Document doc : getCollection().find().limit(limit)) {
            result.add(documentToVideo(doc));
        }
        return result;
    }

    public long count() {
        return getCollection().countDocuments();
    }

    private Video documentToVideo(Document doc) {
        Video video = new Video();
        video.setVideoId(doc.getString("videoId"));
        video.setTitle(doc.getString("title"));
        video.setCategory(doc.getString("category"));

        Object durationObj = doc.get("duration");
        if (durationObj instanceof Number) {
            video.setDuration(((Number) durationObj).intValue());
        }

        video.setUploadDate(doc.getString("uploadDate"));

        Object viewsObj = doc.get("views");
        if (viewsObj instanceof Number) {
            video.setViews(((Number) viewsObj).intValue());
        }

        Object likesObj = doc.get("likes");
        if (likesObj instanceof Number) {
            video.setLikes(((Number) likesObj).intValue());
        }

        return video;
    }
}
