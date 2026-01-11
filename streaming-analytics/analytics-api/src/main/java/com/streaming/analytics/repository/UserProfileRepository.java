package com.streaming.analytics.repository;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.ReplaceOptions;
import com.streaming.analytics.model.UserProfile;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.mongodb.client.model.Filters.eq;

@ApplicationScoped
public class UserProfileRepository {

    @Inject
    private MongoDatabase database;

    private MongoCollection<Document> getCollection() {
        return database.getCollection("user_profiles");
    }

    public void save(UserProfile profile) {
        Document doc = new Document()
                .append("_id", profile.getUserId())
                .append("userId", profile.getUserId())
                .append("watchHistory", profile.getWatchHistory())
                .append("preferredCategories", profile.getPreferredCategories())
                .append("recommendedVideoIds", profile.getRecommendedVideoIds());

        getCollection().replaceOne(
                eq("_id", profile.getUserId()),
                doc,
                new ReplaceOptions().upsert(true));
    }

    public Optional<UserProfile> findById(String userId) {
        Document doc = getCollection().find(eq("_id", userId)).first();
        if (doc == null) {
            return Optional.empty();
        }
        return Optional.of(documentToUserProfile(doc));
    }

    @SuppressWarnings("unchecked")
    private UserProfile documentToUserProfile(Document doc) {
        UserProfile profile = new UserProfile();
        profile.setUserId(doc.getString("userId"));

        List<String> watchHistory = (List<String>) doc.get("watchHistory");
        if (watchHistory != null) {
            profile.setWatchHistory(new ArrayList<>(watchHistory));
        }

        List<String> preferredCategories = (List<String>) doc.get("preferredCategories");
        if (preferredCategories != null) {
            profile.setPreferredCategories(new ArrayList<>(preferredCategories));
        }

        List<String> recommendedVideoIds = (List<String>) doc.get("recommendedVideoIds");
        if (recommendedVideoIds != null) {
            profile.setRecommendedVideoIds(new ArrayList<>(recommendedVideoIds));
        }

        return profile;
    }
}
