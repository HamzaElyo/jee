package com.elearning.connector.config;

/**
 * Configuration des clés API et paramètres de connexion
 */
public class ApiConfig {

    // ============ RapidAPI - Udemy Courses ============
    public static final String RAPIDAPI_KEY = "75f3260a95msha2a4e68e827ce38p1139efjsn6328f4ddc0f8";
    public static final String RAPIDAPI_HOST = "udemy-paid-courses-for-free-api.p.rapidapi.com";
    public static final String RAPIDAPI_BASE_URL = "https://" + RAPIDAPI_HOST;

    // ============ YouTube Data API v3 ============
    public static final String YOUTUBE_API_KEY = "AIzaSyAfs6dddopZdfp-1lsyPATRsrs4s5kcHQY";
    public static final String YOUTUBE_BASE_URL = "https://www.googleapis.com/youtube/v3";

    // ============ MongoDB ============
    public static final String MONGO_URI = "mongodb://admin:admin123@localhost:27017";
    public static final String MONGO_DATABASE = "elearning_analytics";

    // ============ OULAD Dataset Paths ============
    public static final String OULAD_BASE_PATH = "d:/Cours UEMF/S9/jee/elearning-analytics/data/oulad/";
    public static final String OULAD_STUDENTS = OULAD_BASE_PATH + "studentInfo.csv";
    public static final String OULAD_EVENTS = OULAD_BASE_PATH + "studentVle.csv";
    public static final String OULAD_ASSESSMENTS = OULAD_BASE_PATH + "studentAssessment.csv";
    public static final String OULAD_VLE = OULAD_BASE_PATH + "vle.csv";

    // ============ Sync Settings ============
    public static final int COURSES_PER_PAGE = 30;
    public static final int MAX_YOUTUBE_RESULTS = 50;
    public static final int BATCH_SIZE = 1000;

    // ============ Educational Categories for YouTube Search ============
    public static final String[] YOUTUBE_SEARCH_QUERIES = {
            "programming tutorial",
            "data science course",
            "machine learning tutorial",
            "web development course",
            "python programming",
            "java tutorial",
            "javascript course",
            "cloud computing tutorial"
    };
}
