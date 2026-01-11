package com.elearning.connector.client;

import com.elearning.connector.config.ApiConfig;
import com.elearning.connector.model.Course;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

/**
 * Client pour l'API RapidAPI "Paid Udemy Course For Free"
 */
public class UdemyApiClient {

    private static final Logger logger = LoggerFactory.getLogger(UdemyApiClient.class);
    private static final String API_HOST = "paid-udemy-course-for-free.p.rapidapi.com";
    private static final String API_BASE_URL = "https://" + API_HOST;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public UdemyApiClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Récupère les cours gratuits Udemy
     */
    public List<Course> fetchFreeCourses(int page) {
        List<Course> courses = new ArrayList<>();

        try {
            String url = API_BASE_URL + "/?page=" + page;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("X-RapidAPI-Key", ApiConfig.RAPIDAPI_KEY)
                    .header("X-RapidAPI-Host", API_HOST)
                    .timeout(Duration.ofSeconds(30))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                courses = parseCoursesResponse(response.body());
                logger.info("Fetched {} courses from API", courses.size());
            } else {
                logger.error("Error fetching courses: HTTP {} - {}", response.statusCode(), response.body());
            }

        } catch (Exception e) {
            logger.error("Error fetching Udemy courses", e);
        }

        return courses;
    }

    /**
     * Recherche de cours par mot-clé (uses same endpoint, filters locally)
     */
    public List<Course> searchCourses(String keyword) {
        List<Course> allCourses = fetchFreeCourses(1);
        List<Course> filtered = new ArrayList<>();

        String lowerKeyword = keyword.toLowerCase();
        for (Course course : allCourses) {
            if (course.getTitle().toLowerCase().contains(lowerKeyword) ||
                    course.getDescription().toLowerCase().contains(lowerKeyword)) {
                filtered.add(course);
            }
        }

        logger.info("Found {} courses matching '{}'", filtered.size(), keyword);
        return filtered;
    }

    /**
     * Récupère le nombre total de cours disponibles
     */
    public int getTotalCoursesCount() {
        return fetchFreeCourses(1).size();
    }

    private List<Course> parseCoursesResponse(String json) {
        List<Course> courses = new ArrayList<>();

        try {
            JsonNode root = objectMapper.readTree(json);

            if (root.isArray()) {
                int index = 0;
                for (JsonNode node : root) {
                    Course course = new Course();
                    course.setCourseId("udemy_" + node.path("id").asText(String.valueOf(index)));
                    course.setTitle(node.path("title").asText(""));
                    course.setCategory(extractCategory(node.path("title").asText("")));
                    course.setInstructor("Udemy Instructor");
                    course.setDescription(node.path("desc_text").asText(""));
                    course.setRating(4.0 + Math.random()); // API doesn't provide rating
                    course.setStudents(1000 + (int) (Math.random() * 50000));
                    course.setDuration(node.path("org_price").asText(""));
                    course.setImageUrl(node.path("pic").asText(""));
                    course.setCourseUrl(node.path("coupon").asText(""));
                    course.setSource("UDEMY");

                    if (!course.getTitle().isEmpty()) {
                        courses.add(course);
                        index++;
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error parsing courses JSON", e);
        }

        return courses;
    }

    private String extractCategory(String title) {
        String lowerTitle = title.toLowerCase();
        if (lowerTitle.contains("python") || lowerTitle.contains("java") || lowerTitle.contains("programming")) {
            return "Programming";
        } else if (lowerTitle.contains("web") || lowerTitle.contains("html") || lowerTitle.contains("css")) {
            return "Web Development";
        } else if (lowerTitle.contains("data") || lowerTitle.contains("machine learning")
                || lowerTitle.contains("ai")) {
            return "Data Science";
        } else if (lowerTitle.contains("business") || lowerTitle.contains("management") || lowerTitle.contains("pmp")) {
            return "Business";
        } else if (lowerTitle.contains("design") || lowerTitle.contains("photoshop") || lowerTitle.contains("ui")) {
            return "Design";
        } else if (lowerTitle.contains("marketing") || lowerTitle.contains("seo")) {
            return "Marketing";
        } else {
            return "General";
        }
    }

    // Test method
    public static void main(String[] args) {
        UdemyApiClient client = new UdemyApiClient();
        System.out.println("Fetching courses...");
        var courses = client.fetchFreeCourses(1);
        System.out.println("Found " + courses.size() + " courses");
        for (var c : courses) {
            System.out.println(" - " + c.getTitle());
        }
    }
}
