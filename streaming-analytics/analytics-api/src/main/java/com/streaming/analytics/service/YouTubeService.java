package com.streaming.analytics.service;

import jakarta.enterprise.context.ApplicationScoped;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service pour interagir avec YouTube Data API v3
 */
@ApplicationScoped
public class YouTubeService {

    private static final String API_KEY = "AIzaSyAfsyPATRsrs4s5kcHQY";
    private static final String BASE_URL = "https://www.googleapis.com/youtube/v3";

    /**
     * Récupère les vidéos tendances pour une région donnée
     */
    public List<Map<String, Object>> getTrendingVideos(int limit, String regionCode) {
        List<Map<String, Object>> videos = new ArrayList<>();

        try {
            if (regionCode == null || regionCode.isEmpty()) {
                regionCode = "MA"; // Maroc par défaut
            }
            String urlStr = BASE_URL + "/videos?part=snippet,statistics&chart=mostPopular&regionCode=" + regionCode
                    + "&maxResults="
                    + limit + "&key=" + API_KEY;
            String response = makeHttpRequest(urlStr);

            if (response != null) {
                videos = parseVideosResponse(response);
            }
        } catch (Exception e) {
            System.err.println("Erreur YouTube API: " + e.getMessage());
        }

        return videos;
    }

    /**
     * Recherche des vidéos par mot-clé
     */
    public List<Map<String, Object>> searchVideos(String query, int limit) {
        List<Map<String, Object>> videos = new ArrayList<>();

        try {
            String urlStr = BASE_URL + "/search?part=snippet&type=video&q=" + query.replace(" ", "+") + "&maxResults="
                    + limit + "&key=" + API_KEY;
            String response = makeHttpRequest(urlStr);

            if (response != null) {
                videos = parseSearchResponse(response);
            }
        } catch (Exception e) {
            System.err.println("Erreur YouTube API: " + e.getMessage());
        }

        return videos;
    }

    /**
     * Récupère les détails d'une vidéo spécifique
     */
    public Map<String, Object> getVideoDetails(String videoId) {
        Map<String, Object> video = new HashMap<>();

        try {
            String urlStr = BASE_URL + "/videos?part=snippet,statistics&id=" + videoId + "&key=" + API_KEY;
            String response = makeHttpRequest(urlStr);

            if (response != null) {
                List<Map<String, Object>> videos = parseVideosResponse(response);
                if (!videos.isEmpty()) {
                    video = videos.get(0);
                }
            }
        } catch (Exception e) {
            System.err.println("Erreur YouTube API: " + e.getMessage());
        }

        return video;
    }

    /**
     * Effectue une requête HTTP GET
     */
    private String makeHttpRequest(String urlStr) {
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setRequestProperty("Accept-Charset", "UTF-8");

            if (conn.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                return response.toString();
            } else {
                System.err.println("YouTube API returned: " + conn.getResponseCode());
            }
        } catch (Exception e) {
            System.err.println("HTTP Error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Parse la réponse JSON des vidéos
     */
    private List<Map<String, Object>> parseVideosResponse(String json) {
        List<Map<String, Object>> videos = new ArrayList<>();

        try {
            // Parse simple du JSON (sans bibliothèque externe)
            int itemsStart = json.indexOf("\"items\"");
            if (itemsStart == -1)
                return videos;

            String itemsSection = json.substring(itemsStart);
            String[] items = itemsSection.split("\"kind\": \"youtube#video\"");

            for (int i = 1; i < items.length; i++) {
                Map<String, Object> video = new HashMap<>();
                String item = items[i];

                // Extract videoId
                video.put("youtubeId", extractValue(item, "\"id\": \"", "\""));
                if (video.get("youtubeId") == null) {
                    video.put("youtubeId", extractValue(item, "\"videoId\": \"", "\""));
                }

                // Extract title
                video.put("title", extractValue(item, "\"title\": \"", "\""));

                // Extract channelTitle
                video.put("channelTitle", extractValue(item, "\"channelTitle\": \"", "\""));

                // Extract thumbnail - construct directly from videoId (more reliable)
                String videoId = (String) video.get("youtubeId");
                if (videoId != null && !videoId.isEmpty()) {
                    // YouTube standard thumbnail URL format
                    video.put("thumbnail", "https://i.ytimg.com/vi/" + videoId + "/mqdefault.jpg");
                } else {
                    video.put("thumbnail", null);
                }

                // Extract statistics
                String viewCount = extractValue(item, "\"viewCount\": \"", "\"");
                video.put("viewCount", viewCount != null ? Long.parseLong(viewCount) : 0);

                String likeCount = extractValue(item, "\"likeCount\": \"", "\"");
                video.put("likeCount", likeCount != null ? Long.parseLong(likeCount) : 0);

                // Extract publishedAt
                video.put("publishedAt", extractValue(item, "\"publishedAt\": \"", "\""));

                if (video.get("title") != null) {
                    videos.add(video);
                }
            }
        } catch (Exception e) {
            System.err.println("Parse error: " + e.getMessage());
        }

        return videos;
    }

    /**
     * Parse la réponse de recherche
     */
    private List<Map<String, Object>> parseSearchResponse(String json) {
        List<Map<String, Object>> videos = new ArrayList<>();

        try {
            String[] items = json.split("\"kind\": \"youtube#searchResult\"");

            for (int i = 1; i < items.length; i++) {
                Map<String, Object> video = new HashMap<>();
                String item = items[i];

                video.put("youtubeId", extractValue(item, "\"videoId\": \"", "\""));
                video.put("title", extractValue(item, "\"title\": \"", "\""));
                video.put("channelTitle", extractValue(item, "\"channelTitle\": \"", "\""));

                String thumbnailUrl = extractValue(item, "\"medium\": {\"url\": \"", "\"");
                video.put("thumbnail", thumbnailUrl);

                video.put("publishedAt", extractValue(item, "\"publishedAt\": \"", "\""));

                if (video.get("title") != null && video.get("youtubeId") != null) {
                    videos.add(video);
                }
            }
        } catch (Exception e) {
            System.err.println("Parse error: " + e.getMessage());
        }

        return videos;
    }

    /**
     * Extrait une valeur du JSON
     */
    private String extractValue(String json, String startMarker, String endMarker) {
        int start = json.indexOf(startMarker);
        if (start == -1)
            return null;

        start += startMarker.length();
        int end = json.indexOf(endMarker, start);
        if (end == -1)
            return null;

        return json.substring(start, end).replace("\\u0026", "&").replace("\\\"", "\"");
    }
}
