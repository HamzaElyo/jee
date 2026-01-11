package com.streaming.analytics.service;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.streaming.analytics.model.Video;
import com.streaming.analytics.model.VideoStats;
import com.streaming.analytics.repository.UserProfileRepository;
import com.streaming.analytics.repository.VideoRepository;
import com.streaming.analytics.repository.VideoStatsRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.util.*;
import java.util.stream.Collectors;

@ApplicationScoped
public class AnalyticsService {

    @Inject
    private MongoDatabase database;

    @Inject
    private VideoRepository videoRepository;

    @Inject
    private VideoStatsRepository videoStatsRepository;

    @Inject
    private UserProfileRepository userProfileRepository;

    /**
     * Agrège les statistiques par catégorie de vidéo
     * Utilise MongoDB Aggregation Framework
     */
    public Map<String, Map<String, Object>> aggregateByCategory() {
        Map<String, Map<String, Object>> result = new HashMap<>();

        MongoCollection<Document> videos = database.getCollection("videos");

        // Agrégation simple: compter les vidéos par catégorie
        List<Document> pipeline = Arrays.asList(
                new Document("$group", new Document()
                        .append("_id", "$category")
                        .append("videoCount", new Document("$sum", 1))
                        .append("totalViews", new Document("$sum", "$views"))
                        .append("avgDuration", new Document("$avg", "$duration"))));

        AggregateIterable<Document> aggregation = videos.aggregate(pipeline);

        for (Document doc : aggregation) {
            String category = doc.getString("_id");
            if (category != null) {
                Map<String, Object> categoryStats = new HashMap<>();
                categoryStats.put("videoCount", getNumberValue(doc.get("videoCount")));
                categoryStats.put("totalViews", getNumberValue(doc.get("totalViews")));
                categoryStats.put("avgDuration", getNumberValue(doc.get("avgDuration")));
                result.put(category, categoryStats);
            }
        }

        return result;
    }

    /**
     * Détecte les vidéos tendance (avec croissance rapide de vues)
     */
    public List<VideoStats> detectTrending(int limit) {
        // Retourne les vidéos avec le plus de vues récentes
        return videoStatsRepository.getTopVideos(limit);
    }

    /**
     * Génère des recommandations personnalisées pour un utilisateur
     * Basé sur l'analyse dynamique de ses événements de visionnage
     * Avec échantillonnage aléatoire basé sur le userId
     */
    public List<Video> getRecommendations(String userId) {
        List<Video> candidateVideos = new ArrayList<>();

        // Seed aléatoire basé sur le userId pour des résultats reproductibles par
        // utilisateur
        Random random = new Random(userId.hashCode());

        // 1. Récupérer l'historique de visionnage depuis la collection events
        MongoCollection<Document> events = database.getCollection("events");
        MongoCollection<Document> videos = database.getCollection("videos");

        // Trouver toutes les vidéos regardées par cet utilisateur
        Set<String> watchedVideoIds = new HashSet<>();
        Map<String, Integer> categoryCount = new HashMap<>();

        for (Document event : events.find(new Document("userId", userId))) {
            String videoId = event.getString("videoId");
            if (videoId != null) {
                watchedVideoIds.add(videoId);

                // Trouver la catégorie de cette vidéo
                Document video = videos.find(new Document("videoId", videoId)).first();
                if (video != null) {
                    String category = video.getString("category");
                    if (category != null) {
                        categoryCount.merge(category, 1, Integer::sum);
                    }
                }
            }
        }

        // 2. Trier les catégories par fréquence (préférences)
        List<String> preferredCategories = categoryCount.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        // 3. Collecter un large pool de vidéos candidates (50+ vidéos)
        Set<String> addedVideoIds = new HashSet<>();

        // D'abord les vidéos dans les catégories préférées
        for (String category : preferredCategories) {
            for (Document videoDoc : videos.find(new Document("category", category))
                    .sort(new Document("views", -1))
                    .limit(30)) {
                String videoId = videoDoc.getString("videoId");
                if (!watchedVideoIds.contains(videoId) && !addedVideoIds.contains(videoId)) {
                    Video video = documentToVideo(videoDoc);
                    if (video != null) {
                        candidateVideos.add(video);
                        addedVideoIds.add(videoId);
                    }
                }
            }
        }

        // Ajouter des vidéos populaires générales si pas assez
        if (candidateVideos.size() < 30) {
            for (Document videoDoc : videos.find()
                    .sort(new Document("views", -1))
                    .limit(50)) {
                String videoId = videoDoc.getString("videoId");
                if (!watchedVideoIds.contains(videoId) && !addedVideoIds.contains(videoId)) {
                    Video video = documentToVideo(videoDoc);
                    if (video != null) {
                        candidateVideos.add(video);
                        addedVideoIds.add(videoId);
                    }
                }
            }
        }

        // 4. Mélanger les candidats de façon aléatoire (basé sur userId)
        Collections.shuffle(candidateVideos, random);

        // 5. Retourner les 10 premiers après mélange
        return candidateVideos.subList(0, Math.min(10, candidateVideos.size()));
    }

    /**
     * Convertit un Document MongoDB en objet Video
     */
    private Video documentToVideo(Document doc) {
        if (doc == null)
            return null;
        Video video = new Video();
        video.setVideoId(doc.getString("videoId"));
        video.setTitle(doc.getString("title"));
        video.setCategory(doc.getString("category"));
        video.setDuration(doc.getInteger("duration", 0));
        video.setViews(doc.getInteger("views", 0));
        video.setLikes(doc.getInteger("likes", 0));
        video.setUploadDate(doc.getString("uploadDate"));
        return video;
    }

    /**
     * Agrège les événements par type d'action (PLAY, PAUSE, SEEK, STOP)
     */
    public Map<String, Long> aggregateByAction() {
        Map<String, Long> result = new HashMap<>();

        MongoCollection<Document> events = database.getCollection("events");

        List<Document> pipeline = Arrays.asList(
                new Document("$group", new Document()
                        .append("_id", "$action")
                        .append("count", new Document("$sum", 1))));

        AggregateIterable<Document> aggregation = events.aggregate(pipeline);

        for (Document doc : aggregation) {
            String action = doc.getString("_id");
            if (action != null) {
                result.put(action, getNumberValue(doc.get("count")));
            }
        }

        return result;
    }

    /**
     * Agrège les événements par type d'appareil (desktop, mobile, tablet)
     */
    public Map<String, Long> aggregateByDevice() {
        Map<String, Long> result = new HashMap<>();

        MongoCollection<Document> events = database.getCollection("events");

        List<Document> pipeline = Arrays.asList(
                new Document("$group", new Document()
                        .append("_id", "$deviceType")
                        .append("count", new Document("$sum", 1))));

        AggregateIterable<Document> aggregation = events.aggregate(pipeline);

        for (Document doc : aggregation) {
            String device = doc.getString("_id");
            if (device != null) {
                result.put(device, getNumberValue(doc.get("count")));
            }
        }

        return result;
    }

    /**
     * Récupère les événements récents
     */
    public List<Map<String, Object>> getRecentEvents(int limit) {
        List<Map<String, Object>> result = new ArrayList<>();

        MongoCollection<Document> events = database.getCollection("events");

        for (Document doc : events.find().sort(new Document("timestamp", -1)).limit(limit)) {
            Map<String, Object> event = new HashMap<>();
            event.put("eventId", doc.getString("eventId"));
            event.put("userId", doc.getString("userId"));
            event.put("videoId", doc.getString("videoId"));
            event.put("action", doc.getString("action"));
            event.put("timestamp", doc.getString("timestamp"));
            event.put("deviceType", doc.getString("deviceType"));
            event.put("quality", doc.getString("quality"));
            result.add(event);
        }

        return result;
    }

    /**
     * Compte le nombre total d'événements
     */
    public long getTotalEventCount() {
        MongoCollection<Document> events = database.getCollection("events");
        return events.countDocuments();
    }

    /**
     * Compte le nombre total de vidéos
     */
    public long getTotalVideoCount() {
        MongoCollection<Document> videos = database.getCollection("videos");
        return videos.countDocuments();
    }

    private long getNumberValue(Object obj) {
        if (obj instanceof Number) {
            return ((Number) obj).longValue();
        }
        return 0L;
    }

    /**
     * Get top videos by actual views count from Video collection
     */
    public List<Map<String, Object>> getTopVideosByViews(int limit) {
        List<Map<String, Object>> result = new ArrayList<>();

        MongoCollection<Document> videos = database.getCollection("videos");

        for (Document doc : videos.find()
                .sort(new Document("views", -1))
                .limit(limit)) {
            Map<String, Object> videoData = new HashMap<>();
            videoData.put("videoId", doc.getString("videoId"));
            videoData.put("title", doc.getString("title"));
            videoData.put("category", doc.getString("category"));
            videoData.put("totalViews", getNumberValue(doc.get("views")));
            videoData.put("duration", getNumberValue(doc.get("duration")));
            videoData.put("likes", getNumberValue(doc.get("likes")));
            result.add(videoData);
        }

        return result;
    }

    /**
     * Get list of real users from events collection with their watch counts
     */
    public List<Map<String, Object>> getUsersWithStats(int limit) {
        List<Map<String, Object>> result = new ArrayList<>();

        MongoCollection<Document> events = database.getCollection("events");

        // Aggregate to get distinct users with their event counts
        List<Document> pipeline = Arrays.asList(
                new Document("$group", new Document()
                        .append("_id", "$userId")
                        .append("watchCount", new Document("$sum", 1))),
                new Document("$sort", new Document("watchCount", -1)),
                new Document("$limit", limit));

        AggregateIterable<Document> aggregation = events.aggregate(pipeline);

        for (Document doc : aggregation) {
            String userId = doc.getString("_id");
            if (userId != null) {
                Map<String, Object> userData = new HashMap<>();
                userData.put("userId", userId);
                userData.put("watchCount", getNumberValue(doc.get("watchCount")));
                result.add(userData);
            }
        }

        return result;
    }
}
