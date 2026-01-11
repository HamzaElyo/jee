package com.streaming.analytics.model;

import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "users")
public class UserProfile implements Serializable {

    @Id
    private String userId;

    @ElementCollection
    private List<String> watchHistory = new ArrayList<>();

    @ElementCollection
    private List<String> preferredCategories = new ArrayList<>();

    @ElementCollection
    private List<String> recommendedVideoIds = new ArrayList<>();

    public UserProfile() {
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<String> getWatchHistory() {
        return watchHistory;
    }

    public void setWatchHistory(List<String> watchHistory) {
        this.watchHistory = watchHistory;
    }

    public List<String> getPreferredCategories() {
        return preferredCategories;
    }

    public void setPreferredCategories(List<String> preferredCategories) {
        this.preferredCategories = preferredCategories;
    }

    public List<String> getRecommendedVideoIds() {
        return recommendedVideoIds;
    }

    public void setRecommendedVideoIds(List<String> recommendedVideoIds) {
        this.recommendedVideoIds = recommendedVideoIds;
    }
}
