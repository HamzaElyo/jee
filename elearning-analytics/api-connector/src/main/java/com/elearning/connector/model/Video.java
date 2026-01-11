package com.elearning.connector.model;

import java.time.Instant;

/**
 * Représente une vidéo éducative de YouTube
 */
public class Video {
    private String videoId;
    private String title;
    private String channelId;
    private String channelTitle;
    private String description;
    private String thumbnailUrl;
    private Instant publishedAt;
    private long viewCount;
    private long likeCount;
    private long commentCount;
    private String category;
    private Instant fetchedAt;

    public Video() {
        this.fetchedAt = Instant.now();
    }

    // Getters and Setters
    public String getVideoId() { return videoId; }
    public void setVideoId(String videoId) { this.videoId = videoId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getChannelId() { return channelId; }
    public void setChannelId(String channelId) { this.channelId = channelId; }

    public String getChannelTitle() { return channelTitle; }
    public void setChannelTitle(String channelTitle) { this.channelTitle = channelTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public Instant getPublishedAt() { return publishedAt; }
    public void setPublishedAt(Instant publishedAt) { this.publishedAt = publishedAt; }

    public long getViewCount() { return viewCount; }
    public void setViewCount(long viewCount) { this.viewCount = viewCount; }

    public long getLikeCount() { return likeCount; }
    public void setLikeCount(long likeCount) { this.likeCount = likeCount; }

    public long getCommentCount() { return commentCount; }
    public void setCommentCount(long commentCount) { this.commentCount = commentCount; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Instant getFetchedAt() { return fetchedAt; }
    public void setFetchedAt(Instant fetchedAt) { this.fetchedAt = fetchedAt; }

    @Override
    public String toString() {
        return "Video{title='" + title + "', views=" + viewCount + "}";
    }
}
