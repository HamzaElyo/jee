package com.elearning.connector.repository;

import com.elearning.connector.config.ApiConfig;
import com.elearning.connector.model.Course;
import com.elearning.connector.model.LearningEvent;
import com.elearning.connector.model.Student;
import com.elearning.connector.model.Video;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Repository MongoDB pour stocker les données e-learning
 */
public class MongoRepository {

    private static final Logger logger = LoggerFactory.getLogger(MongoRepository.class);

    private MongoClient mongoClient;
    private MongoDatabase database;

    public MongoRepository() {
        try {
            this.mongoClient = MongoClients.create(ApiConfig.MONGO_URI);
            this.database = mongoClient.getDatabase(ApiConfig.MONGO_DATABASE);
            logger.info("Connected to MongoDB: {}", ApiConfig.MONGO_DATABASE);
        } catch (Exception e) {
            logger.error("Failed to connect to MongoDB", e);
        }
    }

    // ============ Courses ============

    public void saveCourses(List<Course> courses) {
        if (courses.isEmpty())
            return;

        MongoCollection<Document> collection = database.getCollection("courses");
        List<Document> docs = new ArrayList<>();

        for (Course course : courses) {
            Document doc = new Document()
                    .append("courseId", course.getCourseId())
                    .append("title", course.getTitle())
                    .append("category", course.getCategory())
                    .append("instructor", course.getInstructor())
                    .append("description", course.getDescription())
                    .append("rating", course.getRating())
                    .append("students", course.getStudents())
                    .append("duration", course.getDuration())
                    .append("level", course.getLevel())
                    .append("imageUrl", course.getImageUrl())
                    .append("courseUrl", course.getCourseUrl())
                    .append("source", course.getSource())
                    .append("fetchedAt", course.getFetchedAt().toString());
            docs.add(doc);
        }

        collection.insertMany(docs);
        logger.info("Saved {} courses to MongoDB", courses.size());
    }

    // ============ Videos ============

    public void saveVideos(List<Video> videos) {
        if (videos.isEmpty())
            return;

        MongoCollection<Document> collection = database.getCollection("videos");
        int saved = 0;

        for (Video video : videos) {
            Document doc = new Document()
                    .append("videoId", video.getVideoId())
                    .append("title", video.getTitle())
                    .append("channelId", video.getChannelId())
                    .append("channelTitle", video.getChannelTitle())
                    .append("description", video.getDescription())
                    .append("thumbnailUrl", video.getThumbnailUrl())
                    .append("publishedAt", video.getPublishedAt() != null ? video.getPublishedAt().toString() : null)
                    .append("viewCount", video.getViewCount())
                    .append("likeCount", video.getLikeCount())
                    .append("commentCount", video.getCommentCount())
                    .append("category", video.getCategory())
                    .append("fetchedAt", video.getFetchedAt().toString());

            // Use upsert to avoid duplicates
            collection.replaceOne(
                    new Document("videoId", video.getVideoId()),
                    doc,
                    new com.mongodb.client.model.ReplaceOptions().upsert(true));
            saved++;
        }

        logger.info("Saved/updated {} videos to MongoDB", saved);
    }

    // ============ Students ============

    public void saveStudents(List<Student> students) {
        if (students.isEmpty())
            return;

        MongoCollection<Document> collection = database.getCollection("students");
        List<Document> docs = new ArrayList<>();

        for (Student student : students) {
            Document doc = new Document()
                    .append("studentId", student.getStudentId())
                    .append("codeModule", student.getCodeModule())
                    .append("codePresentation", student.getCodePresentation())
                    .append("gender", student.getGender())
                    .append("region", student.getRegion())
                    .append("highestEducation", student.getHighestEducation())
                    .append("ageBand", student.getAgeBand())
                    .append("disability", student.getDisability())
                    .append("finalResult", student.getFinalResult());
            docs.add(doc);
        }

        collection.insertMany(docs);
        logger.info("Saved {} students to MongoDB", students.size());
    }

    // ============ Learning Events ============

    public void saveEvents(List<LearningEvent> events) {
        if (events.isEmpty())
            return;

        MongoCollection<Document> collection = database.getCollection("events");
        List<Document> docs = new ArrayList<>();

        for (LearningEvent event : events) {
            Document doc = new Document()
                    .append("eventId", event.getEventId())
                    .append("studentId", event.getStudentId())
                    .append("courseId", event.getCourseId())
                    .append("codeModule", event.getCodeModule())
                    .append("codePresentation", event.getCodePresentation())
                    .append("siteId", event.getSiteId())
                    .append("date", event.getDate())
                    .append("sumClick", event.getSumClick())
                    .append("activityType", event.getActivityType());
            docs.add(doc);
        }

        collection.insertMany(docs);
        logger.debug("Saved {} events to MongoDB", events.size());
    }

    // ============ Stats ============

    public long getCoursesCount() {
        return database.getCollection("courses").countDocuments();
    }

    public long getVideosCount() {
        return database.getCollection("videos").countDocuments();
    }

    public long getStudentsCount() {
        return database.getCollection("students").countDocuments();
    }

    public long getEventsCount() {
        return database.getCollection("events").countDocuments();
    }

    // ============ Clear collections ============

    public void clearCollection(String collectionName) {
        database.getCollection(collectionName).drop();
        logger.info("Cleared collection: {}", collectionName);
    }

    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
            logger.info("MongoDB connection closed");
        }
    }
}
