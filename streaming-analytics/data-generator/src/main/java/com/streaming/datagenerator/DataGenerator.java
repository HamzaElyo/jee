package com.streaming.datagenerator;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.FileWriter;
import java.io.IOException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Générateur de données pour la plateforme de streaming vidéo
 * Génère des événements de visualisation simulés
 */
public class DataGenerator {

    private static final String[] ACTIONS = { "WATCH", "PAUSE", "STOP", "RESUME", "SEEK" };
    private static final String[] QUALITIES = { "360p", "480p", "720p", "1080p", "4K" };
    private static final String[] DEVICE_TYPES = { "mobile", "desktop", "tablet", "tv", "console" };
    private static final String[] CATEGORIES = { "Action", "Comedy", "Drama", "Documentary", "SciFi", "Horror",
            "Romance", "Thriller" };

    private static final int NUM_USERS = 50000;
    private static final int NUM_VIDEOS = 10000;

    private final ObjectMapper objectMapper;
    private final Random random;

    public DataGenerator() {
        this.objectMapper = new ObjectMapper();
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        this.random = new Random();
    }

    /**
     * Génère un événement de visualisation aléatoire
     */
    public ViewEvent generateEvent() {
        ViewEvent event = new ViewEvent();

        event.setEventId("evt_" + UUID.randomUUID().toString().substring(0, 8));
        event.setUserId("user_" + ThreadLocalRandom.current().nextInt(1, NUM_USERS + 1));
        event.setVideoId("video_" + ThreadLocalRandom.current().nextInt(1, NUM_VIDEOS + 1));

        // Timestamp dans les dernières 24 heures
        Instant now = Instant.now();
        long randomMinutes = ThreadLocalRandom.current().nextLong(0, 24 * 60);
        event.setTimestamp(now.minus(randomMinutes, ChronoUnit.MINUTES).toString());

        event.setAction(ACTIONS[random.nextInt(ACTIONS.length)]);

        // Durée en secondes (0 à 3600 = 1 heure max)
        if ("WATCH".equals(event.getAction())) {
            event.setDuration(ThreadLocalRandom.current().nextInt(30, 3600));
        } else {
            event.setDuration(ThreadLocalRandom.current().nextInt(0, 300));
        }

        event.setQuality(QUALITIES[random.nextInt(QUALITIES.length)]);
        event.setDeviceType(DEVICE_TYPES[random.nextInt(DEVICE_TYPES.length)]);

        return event;
    }

    /**
     * Génère des métadonnées vidéo
     */
    public Video generateVideo(int videoId) {
        Video video = new Video();

        video.setVideoId("video_" + videoId);
        video.setTitle("Video Title " + videoId);
        video.setCategory(CATEGORIES[random.nextInt(CATEGORIES.length)]);
        video.setDuration(ThreadLocalRandom.current().nextInt(300, 7200)); // 5min à 2h

        // Date d'upload dans les derniers 365 jours
        Instant now = Instant.now();
        long randomDays = ThreadLocalRandom.current().nextLong(0, 365);
        video.setUploadDate(now.minus(randomDays, ChronoUnit.DAYS).toString());

        video.setViews(ThreadLocalRandom.current().nextInt(100, 1000000));
        video.setLikes(ThreadLocalRandom.current().nextInt(10, 50000));

        return video;
    }

    /**
     * Génère N événements et les écrit dans un fichier JSON
     */
    public void generateEventsToFile(int count, String filename) throws IOException {
        List<ViewEvent> events = new ArrayList<>();

        System.out.println("🎬 Génération de " + count + " événements...");

        for (int i = 0; i < count; i++) {
            events.add(generateEvent());

            if ((i + 1) % 10000 == 0) {
                System.out.println("  ✓ " + (i + 1) + " événements générés");
            }
        }

        System.out.println("💾 Écriture dans le fichier " + filename + "...");

        try (FileWriter writer = new FileWriter(filename)) {
            objectMapper.writeValue(writer, events);
        }

        System.out.println("✅ " + count + " événements générés avec succès dans " + filename);
    }

    /**
     * Génère le catalogue vidéo
     */
    public void generateVideosCatalog(String filename) throws IOException {
        List<Video> videos = new ArrayList<>();

        System.out.println("📹 Génération de " + NUM_VIDEOS + " vidéos...");

        for (int i = 1; i <= NUM_VIDEOS; i++) {
            videos.add(generateVideo(i));

            if (i % 1000 == 0) {
                System.out.println("  ✓ " + i + " vidéos générées");
            }
        }

        System.out.println("💾 Écriture du catalogue dans " + filename + "...");

        try (FileWriter writer = new FileWriter(filename)) {
            objectMapper.writeValue(writer, videos);
        }

        System.out.println("✅ Catalogue de " + NUM_VIDEOS + " vidéos généré avec succès");
    }

    /**
     * Génère des événements en continu (mode streaming)
     */
    public void generateContinuousStream(int eventsPerSecond, int durationSeconds) {
        System.out.println(
                "🔄 Génération continue : " + eventsPerSecond + " événements/seconde pendant " + durationSeconds + "s");

        long startTime = System.currentTimeMillis();
        long endTime = startTime + (durationSeconds * 1000L);
        int totalGenerated = 0;

        while (System.currentTimeMillis() < endTime) {
            long cycleStart = System.currentTimeMillis();

            // Génère les événements pour cette seconde
            for (int i = 0; i < eventsPerSecond; i++) {
                ViewEvent event = generateEvent();
                // Ici vous pourriez envoyer vers Kafka ou une queue
                System.out.println(event.toJson());
                totalGenerated++;
            }

            // Attendre le reste de la seconde
            long cycleTime = System.currentTimeMillis() - cycleStart;
            long sleepTime = 1000 - cycleTime;

            if (sleepTime > 0) {
                try {
                    Thread.sleep(sleepTime);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }

        System.out.println("✅ Génération terminée : " + totalGenerated + " événements générés");
    }

    /**
     * Envoie une liste d'événements directement à MongoDB
     */
    public void sendEventsToMongo(List<ViewEvent> events,
            com.mongodb.client.MongoCollection<org.bson.Document> collection) {
        try {
            List<org.bson.Document> docs = new ArrayList<>();
            for (ViewEvent event : events) {
                // Conversion manuelle ou via Jackson -> Map -> Document
                // Ici on le fait manuellement pour être sûr du mapping ou via
                // Document.parse(json)
                docs.add(org.bson.Document.parse(objectMapper.writeValueAsString(event)));
            }

            if (!docs.isEmpty()) {
                collection.insertMany(docs);
                System.out.println("✅ " + docs.size() + " événements insérés dans MongoDB");
            }
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de l'insertion événements : " + e.getMessage());
        }
    }

    /**
     * Envoie le catalogue de vidéos directement à MongoDB
     */
    public void sendVideosToMongo(List<Video> videos,
            com.mongodb.client.MongoCollection<org.bson.Document> collection) {
        try {
            List<org.bson.Document> docs = new ArrayList<>();
            for (Video video : videos) {
                docs.add(org.bson.Document.parse(objectMapper.writeValueAsString(video)));
            }

            if (!docs.isEmpty()) {
                // Mode incrémental : ajoute sans supprimer les vidéos existantes
                collection.insertMany(docs);
                System.out.println("✅ " + docs.size() + " vidéos ajoutées dans MongoDB");
            }
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de l'insertion vidéos : " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        DataGenerator generator = new DataGenerator();

        // Connexion MongoDB avec authentification Docker
        String mongoUri = "mongodb://admin:admin123@localhost:27017/streaming_analytics?authSource=admin";
        String dbName = "streaming_analytics"; // Doit correspondre à persistence.xml

        try (com.mongodb.client.MongoClient mongoClient = com.mongodb.client.MongoClients.create(mongoUri)) {
            com.mongodb.client.MongoDatabase database = mongoClient.getDatabase(dbName);
            com.mongodb.client.MongoCollection<org.bson.Document> eventsCol = database.getCollection("events"); // Nom
                                                                                                                // table/collection
                                                                                                                // JPA
            com.mongodb.client.MongoCollection<org.bson.Document> videosCol = database.getCollection("videos"); // Doit
                                                                                                                // matcher
                                                                                                                // AnalyticsService
                                                                                                                // @Table(name="videos")
                                                                                                                // dans
                                                                                                                // Video.java
                                                                                                                // table/collection
                                                                                                                // JPA
                                                                                                                // (attention
                                                                                                                // case
                                                                                                                // sensitive
                                                                                                                // souvent
                                                                                                                // Entity
                                                                                                                // Name)
            // Note: EclipseLink NoSQL utilise souvent le nom de l'entité ou @Table(name).
            // ViewEvent -> @Table(name="events")
            // Video -> a vérifier (pas vu @Table, donc probablement "Video")
            // Vérifions Video.java... (Je suppose "Video" ou "video", on va utiliser
            // "Video" par défaut JPA ou check code)
            // Dans le doute, je vais checker Video.java plus tard, mais si pas
            // d'annotation, c'est le nom de la classe.

            System.out.println("=== MODE MONGO : ÉCRITURE DIRECTE DANS " + dbName + " ===\n");

            // 1. Génération Catalogue Vidéos
            System.out.println("1️⃣ Génération du catalogue vidéos...");

            // Récupérer le dernier ID pour éviter les doublons
            com.mongodb.client.MongoCollection<org.bson.Document> videosColForCount = database.getCollection("videos");
            int startId = 1;
            org.bson.Document lastVideo = videosColForCount.find()
                    .sort(new org.bson.Document("videoId", -1))
                    .first();
            if (lastVideo != null && lastVideo.getString("videoId") != null) {
                String lastVideoId = lastVideo.getString("videoId");
                // Format: "vid_XXX" - extraire le numéro
                try {
                    startId = Integer.parseInt(lastVideoId.replace("vid_", "")) + 1;
                } catch (NumberFormatException e) {
                    startId = (int) videosColForCount.countDocuments() + 1;
                }
            }
            System.out.println("📍 Démarrage à l'ID: " + startId);

            int nbVideosToAdd = 1000; // Nombre de vidéos à ajouter
            List<Video> videos = new ArrayList<>();
            for (int i = startId; i < startId + nbVideosToAdd; i++) {
                videos.add(generator.generateVideo(i));
            }
            generator.sendVideosToMongo(videos, database.getCollection("videos"));

            // 2. Génération Événements
            System.out.println("\n2️⃣ Génération des événements...");
            int totalEvents = 2000;
            int batchSize = 200;
            List<ViewEvent> batch = new ArrayList<>();

            for (int i = 0; i < totalEvents; i++) {
                batch.add(generator.generateEvent());
                if (batch.size() >= batchSize) {
                    generator.sendEventsToMongo(new ArrayList<>(batch), eventsCol);
                    batch.clear();
                    Thread.sleep(100);
                }
            }
            if (!batch.isEmpty()) {
                generator.sendEventsToMongo(batch, eventsCol);
            }

            System.out.println("\n✅ Génération Terminée.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

/**
 * Classe représentant un événement de visualisation
 */
class ViewEvent {
    private String eventId;
    private String userId;
    private String videoId;
    private String timestamp;
    private String action;
    private int duration;
    private String quality;
    private String deviceType;

    // Getters et Setters
    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getQuality() {
        return quality;
    }

    public void setQuality(String quality) {
        this.quality = quality;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String toJson() {
        return String.format(
                "{\"eventId\":\"%s\",\"userId\":\"%s\",\"videoId\":\"%s\",\"timestamp\":\"%s\",\"action\":\"%s\",\"duration\":%d,\"quality\":\"%s\",\"deviceType\":\"%s\"}",
                eventId, userId, videoId, timestamp, action, duration, quality, deviceType);
    }

    @Override
    public String toString() {
        return toJson();
    }
}

/**
 * Classe représentant une vidéo
 */
class Video {
    private String videoId;
    private String title;
    private String category;
    private int duration;
    private String uploadDate;
    private int views;
    private int likes;

    // Getters et Setters
    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(String uploadDate) {
        this.uploadDate = uploadDate;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }
}
