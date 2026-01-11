package com.elearning.analytics.service;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.util.*;

import static com.mongodb.client.model.Accumulators.*;
import static com.mongodb.client.model.Aggregates.*;
import static com.mongodb.client.model.Sorts.*;

/**
 * Service principal d'analytics pour l'e-learning
 */
@ApplicationScoped
public class AnalyticsService {

        @Inject
        private MongoDatabase database;

        // ============ Courses ============

        public List<Document> getTopCourses(int limit) {
                MongoCollection<Document> collection = database.getCollection("courses");
                return collection.find()
                                .sort(descending("students"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        public List<Document> getCoursesByCategory(String category) {
                MongoCollection<Document> collection = database.getCollection("courses");
                return collection.find(new Document("category", category))
                                .sort(descending("rating"))
                                .into(new ArrayList<>());
        }

        public List<Document> searchCourses(String query) {
                MongoCollection<Document> collection = database.getCollection("courses");
                Document filter = new Document("title", new Document("$regex", query).append("$options", "i"));
                return collection.find(filter)
                                .limit(20)
                                .into(new ArrayList<>());
        }

        // ============ Videos ============

        public List<Document> getTrendingVideos(int limit) {
                MongoCollection<Document> collection = database.getCollection("videos");
                return collection.find()
                                .sort(descending("viewCount"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        public List<Document> searchVideos(String query) {
                MongoCollection<Document> collection = database.getCollection("videos");
                Document filter = new Document("title", new Document("$regex", query).append("$options", "i"));
                return collection.find(filter)
                                .limit(20)
                                .into(new ArrayList<>());
        }

        // ============ Students & Progress ============

        public Document getStudentProgress(String studentId) {
                MongoCollection<Document> students = database.getCollection("students");
                MongoCollection<Document> events = database.getCollection("events");

                Document student = students.find(new Document("studentId", studentId)).first();
                if (student == null) {
                        return null;
                }

                // Count events and total clicks
                long eventCount = events.countDocuments(new Document("studentId", studentId));

                // Aggregate total clicks
                AggregateIterable<Document> result = events.aggregate(Arrays.asList(
                                match(new Document("studentId", studentId)),
                                group(null, sum("totalClicks", "$sumClick"))));

                Document stats = result.first();
                int totalClicks = stats != null ? stats.getInteger("totalClicks", 0) : 0;

                return new Document()
                                .append("student", student)
                                .append("eventCount", eventCount)
                                .append("totalClicks", totalClicks);
        }

        public List<Document> getLeaderboard(int limit) {
                MongoCollection<Document> events = database.getCollection("events");

                return events.aggregate(Arrays.asList(
                                group("$studentId",
                                                sum("totalClicks", "$sumClick"),
                                                sum("eventCount", 1)),
                                sort(descending("totalClicks")),
                                limit(limit))).into(new ArrayList<>());
        }

        // ============ Analytics Aggregations ============

        public List<Document> aggregateByCategory() {
                MongoCollection<Document> collection = database.getCollection("courses");

                return collection.aggregate(Arrays.asList(
                                group("$category",
                                                sum("count", 1),
                                                avg("avgRating", "$rating"),
                                                sum("totalStudents", "$students")),
                                sort(descending("count")))).into(new ArrayList<>());
        }

        public List<Document> aggregateByActivityType() {
                MongoCollection<Document> collection = database.getCollection("events");

                return collection.aggregate(Arrays.asList(
                                group("$activityType",
                                                sum("count", 1),
                                                sum("totalClicks", "$sumClick")),
                                sort(descending("count")))).into(new ArrayList<>());
        }

        public List<Document> aggregateByFinalResult() {
                MongoCollection<Document> collection = database.getCollection("students");

                return collection.aggregate(Arrays.asList(
                                group("$finalResult", sum("count", 1)),
                                sort(descending("count")))).into(new ArrayList<>());
        }

        public List<Document> aggregateByRegion() {
                MongoCollection<Document> collection = database.getCollection("students");

                return collection.aggregate(Arrays.asList(
                                group("$region", sum("count", 1)),
                                sort(descending("count")))).into(new ArrayList<>());
        }

        // ============ Global Stats ============

        public Document getGlobalStats() {
                return new Document()
                                .append("coursesCount", database.getCollection("courses").countDocuments())
                                .append("videosCount", database.getCollection("videos").countDocuments())
                                .append("studentsCount", database.getCollection("students").countDocuments())
                                .append("eventsCount", database.getCollection("events").countDocuments());
        }

        // ============ Recent Events ============

        public List<Document> getRecentEvents(int limit) {
                MongoCollection<Document> collection = database.getCollection("events");
                return collection.find()
                                .sort(descending("_id"))
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        // ============ Advanced Filters ============

        /**
         * Filtre les étudiants par région et/ou résultat
         */
        public List<Document> filterStudents(String region, String result, int limit) {
                MongoCollection<Document> collection = database.getCollection("students");
                Document filter = new Document();

                if (region != null && !region.isEmpty()) {
                        filter.append("region", region);
                }
                if (result != null && !result.isEmpty()) {
                        filter.append("finalResult", result);
                }

                return collection.find(filter)
                                .limit(limit)
                                .into(new ArrayList<>());
        }

        /**
         * Statistiques des étudiants groupées par module
         */
        public List<Document> aggregateByModule() {
                MongoCollection<Document> collection = database.getCollection("students");

                return collection.aggregate(Arrays.asList(
                                group("$codeModule",
                                                sum("count", 1),
                                                push("results", "$finalResult")),
                                sort(descending("count")))).into(new ArrayList<>());
        }

        /**
         * Comparaison entre deux périodes (semestres)
         */
        public Document comparePeriods(String period1, String period2) {
                MongoCollection<Document> collection = database.getCollection("students");

                long count1 = collection.countDocuments(new Document("codePresentation", period1));
                long count2 = collection.countDocuments(new Document("codePresentation", period2));

                // Aggregate pass rates for each period
                List<Document> results1 = collection.aggregate(Arrays.asList(
                                match(new Document("codePresentation", period1)),
                                group("$finalResult", sum("count", 1)))).into(new ArrayList<>());

                List<Document> results2 = collection.aggregate(Arrays.asList(
                                match(new Document("codePresentation", period2)),
                                group("$finalResult", sum("count", 1)))).into(new ArrayList<>());

                return new Document()
                                .append("period1", new Document()
                                                .append("name", period1)
                                                .append("totalStudents", count1)
                                                .append("results", results1))
                                .append("period2", new Document()
                                                .append("name", period2)
                                                .append("totalStudents", count2)
                                                .append("results", results2));
        }

        /**
         * Retourne les options disponibles pour les filtres
         */
        public Document getFilterOptions() {
                MongoCollection<Document> students = database.getCollection("students");

                List<String> regions = students.distinct("region", String.class).into(new ArrayList<>());
                List<String> results = students.distinct("finalResult", String.class).into(new ArrayList<>());
                List<String> modules = students.distinct("codeModule", String.class).into(new ArrayList<>());
                List<String> presentations = students.distinct("codePresentation", String.class)
                                .into(new ArrayList<>());

                return new Document()
                                .append("regions", regions)
                                .append("results", results)
                                .append("modules", modules)
                                .append("presentations", presentations);
        }
}
