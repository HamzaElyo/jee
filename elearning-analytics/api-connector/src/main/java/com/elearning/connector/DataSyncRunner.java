package com.elearning.connector;

import com.elearning.connector.client.UdemyApiClient;
import com.elearning.connector.client.YouTubeApiClient;
import com.elearning.connector.config.ApiConfig;
import com.elearning.connector.loader.OuladDataLoader;
import com.elearning.connector.model.Course;
import com.elearning.connector.model.Student;
import com.elearning.connector.model.Video;
import com.elearning.connector.repository.MongoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Point d'entrée pour synchroniser les données depuis les APIs externes vers
 * MongoDB
 */
public class DataSyncRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataSyncRunner.class);

    public static void main(String[] args) {
        logger.info("=== E-Learning Analytics - Data Sync ===");

        MongoRepository repository = new MongoRepository();

        try {
            // 1. Sync Udemy Courses from RapidAPI
            syncUdemyCourses(repository);

            // 2. Sync YouTube Educational Videos
            syncYouTubeVideos(repository);

            // 3. Load OULAD Dataset (students and events)
            loadOuladData(repository);

            // Print summary
            printSummary(repository);

        } catch (Exception e) {
            logger.error("Error during data sync", e);
        } finally {
            repository.close();
        }

        logger.info("=== Data Sync Complete ===");
    }

    private static void syncUdemyCourses(MongoRepository repository) {
        logger.info("\n--- Syncing Udemy Courses ---");

        if (ApiConfig.RAPIDAPI_KEY.equals("YOUR_RAPIDAPI_KEY")) {
            logger.warn("RapidAPI key not configured. Skipping Udemy sync.");
            logger.info("To enable: Set your key in ApiConfig.RAPIDAPI_KEY");
            return;
        }

        UdemyApiClient udemyClient = new UdemyApiClient();

        // Fetch first 3 pages (90 courses with free tier)
        for (int page = 0; page < 3; page++) {
            List<Course> courses = udemyClient.fetchFreeCourses(page);
            if (!courses.isEmpty()) {
                repository.saveCourses(courses);
            }

            // Respect rate limits
            try {
                Thread.sleep(500);
            } catch (InterruptedException ignored) {
            }
        }
    }

    private static void syncYouTubeVideos(MongoRepository repository) {
        logger.info("\n--- Syncing YouTube Videos ---");

        if (ApiConfig.YOUTUBE_API_KEY.equals("YOUR_YOUTUBE_API_KEY")) {
            logger.warn("YouTube API key not configured. Skipping YouTube sync.");
            logger.info("To enable: Set your key in ApiConfig.YOUTUBE_API_KEY");
            return;
        }

        YouTubeApiClient youtubeClient = new YouTubeApiClient();
        List<Video> videos = youtubeClient.fetchAllEducationalVideos();

        if (!videos.isEmpty()) {
            repository.saveVideos(videos);
        }
    }

    private static void loadOuladData(MongoRepository repository) {
        logger.info("\n--- Loading OULAD Dataset ---");

        OuladDataLoader loader = new OuladDataLoader();

        // Check if files exist
        java.io.File studentsFile = new java.io.File(ApiConfig.OULAD_STUDENTS);
        if (!studentsFile.exists()) {
            logger.warn("OULAD dataset not found at: {}", ApiConfig.OULAD_BASE_PATH);
            logger.info("To enable: Download OULAD from Kaggle and extract to data/oulad/");
            logger.info("  kaggle datasets download -d rocki37/open-university-learning-analytics-dataset");
            return;
        }

        // Load VLE types first (for activity mapping)
        loader.loadVleTypes(ApiConfig.OULAD_VLE);

        // Check if students already loaded (skip if already exist)
        if (repository.getStudentsCount() == 0) {
            List<Student> students = loader.loadStudents(ApiConfig.OULAD_STUDENTS);
            if (!students.isEmpty()) {
                repository.saveStudents(students);
            }
        } else {
            logger.info("Students already loaded ({}), skipping...", repository.getStudentsCount());
        }

        // Check if events already loaded (skip if already exist)
        if (repository.getEventsCount() == 0) {
            logger.info("Loading learning events (this may take a few minutes)...");
            loader.loadEventsInBatches(ApiConfig.OULAD_EVENTS, batch -> {
                repository.saveEvents(batch);
            });
        } else {
            logger.info("Events already loaded ({}), skipping...", repository.getEventsCount());
        }
    }

    private static void printSummary(MongoRepository repository) {
        logger.info("\n=== Data Summary ===");
        logger.info("Courses:  {}", repository.getCoursesCount());
        logger.info("Videos:   {}", repository.getVideosCount());
        logger.info("Students: {}", repository.getStudentsCount());
        logger.info("Events:   {}", repository.getEventsCount());
    }
}
