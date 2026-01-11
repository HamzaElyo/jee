package com.elearning.connector.client;

import com.elearning.connector.config.ApiConfig;
import com.elearning.connector.model.Video;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Client pour YouTube Data API v3
 */
public class YouTubeApiClient {
    
    private static final Logger logger = LoggerFactory.getLogger(YouTubeApiClient.class);
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public YouTubeApiClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Recherche de vidéos éducatives
     */
    public List<Video> searchEducationalVideos(String query, int maxResults) {
        List<Video> videos = new ArrayList<>();
        
        try {
            String url = ApiConfig.YOUTUBE_BASE_URL + "/search"
                    + "?part=snippet"
                    + "&type=video"
                    + "&q=" + URLEncoder.encode(query + " tutorial", StandardCharsets.UTF_8)
                    + "&maxResults=" + Math.min(maxResults, 50)
                    + "&order=viewCount"
                    + "&key=" + ApiConfig.YOUTUBE_API_KEY;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(30))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                videos = parseSearchResponse(response.body(), query);
                logger.info("Found {} videos for query '{}'", videos.size(), query);
                
                // Enrich with statistics
                enrichWithStatistics(videos);
            } else {
                logger.error("Error searching videos: HTTP {} - {}", response.statusCode(), response.body());
            }
            
        } catch (Exception e) {
            logger.error("Error searching YouTube videos", e);
        }
        
        return videos;
    }

    /**
     * Récupère les statistiques d'une vidéo
     */
    public void enrichWithStatistics(List<Video> videos) {
        if (videos.isEmpty()) return;
        
        try {
            // Build comma-separated video IDs
            StringBuilder ids = new StringBuilder();
            for (int i = 0; i < videos.size(); i++) {
                if (i > 0) ids.append(",");
                ids.append(videos.get(i).getVideoId());
            }
            
            String url = ApiConfig.YOUTUBE_BASE_URL + "/videos"
                    + "?part=statistics"
                    + "&id=" + ids.toString()
                    + "&key=" + ApiConfig.YOUTUBE_API_KEY;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(30))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                parseStatisticsResponse(response.body(), videos);
            }
            
        } catch (Exception e) {
            logger.error("Error fetching video statistics", e);
        }
    }

    /**
     * Recherche sur plusieurs catégories éducatives
     */
    public List<Video> fetchAllEducationalVideos() {
        List<Video> allVideos = new ArrayList<>();
        
        for (String query : ApiConfig.YOUTUBE_SEARCH_QUERIES) {
            List<Video> videos = searchEducationalVideos(query, 10);
            allVideos.addAll(videos);
            
            // Respect rate limits
            try {
                Thread.sleep(100);
            } catch (InterruptedException ignored) {}
        }
        
        logger.info("Total educational videos fetched: {}", allVideos.size());
        return allVideos;
    }

    private List<Video> parseSearchResponse(String json, String category) {
        List<Video> videos = new ArrayList<>();
        
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode items = root.path("items");
            
            if (items.isArray()) {
                for (JsonNode item : items) {
                    Video video = new Video();
                    
                    JsonNode id = item.path("id");
                    video.setVideoId(id.path("videoId").asText());
                    
                    JsonNode snippet = item.path("snippet");
                    video.setTitle(snippet.path("title").asText());
                    video.setDescription(snippet.path("description").asText());
                    video.setChannelId(snippet.path("channelId").asText());
                    video.setChannelTitle(snippet.path("channelTitle").asText());
                    video.setCategory(category);
                    
                    // Thumbnail
                    JsonNode thumbnails = snippet.path("thumbnails");
                    if (thumbnails.has("high")) {
                        video.setThumbnailUrl(thumbnails.path("high").path("url").asText());
                    } else if (thumbnails.has("medium")) {
                        video.setThumbnailUrl(thumbnails.path("medium").path("url").asText());
                    }
                    
                    // Published date
                    String publishedAt = snippet.path("publishedAt").asText();
                    if (!publishedAt.isEmpty()) {
                        video.setPublishedAt(Instant.parse(publishedAt));
                    }
                    
                    videos.add(video);
                }
            }
        } catch (Exception e) {
            logger.error("Error parsing YouTube search response", e);
        }
        
        return videos;
    }

    private void parseStatisticsResponse(String json, List<Video> videos) {
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode items = root.path("items");
            
            if (items.isArray()) {
                for (JsonNode item : items) {
                    String videoId = item.path("id").asText();
                    JsonNode stats = item.path("statistics");
                    
                    // Find matching video
                    for (Video video : videos) {
                        if (video.getVideoId().equals(videoId)) {
                            video.setViewCount(stats.path("viewCount").asLong(0));
                            video.setLikeCount(stats.path("likeCount").asLong(0));
                            video.setCommentCount(stats.path("commentCount").asLong(0));
                            break;
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error parsing statistics response", e);
        }
    }
}
