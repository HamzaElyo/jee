package com.elearning.analytics.api;

import com.elearning.analytics.service.AnalyticsService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.bson.Document;

import java.util.List;

/**
 * REST API principale pour les analytics e-learning
 */
@Path("/analytics")
@Produces(MediaType.APPLICATION_JSON)
public class AnalyticsResource {

    @Inject
    private AnalyticsService analyticsService;

    // ============ Courses Endpoints ============

    @GET
    @Path("/courses/top")
    public Response getTopCourses(@QueryParam("limit") @DefaultValue("10") int limit) {
        List<Document> courses = analyticsService.getTopCourses(limit);
        return Response.ok(courses).build();
    }

    @GET
    @Path("/courses/category/{category}")
    public Response getCoursesByCategory(@PathParam("category") String category) {
        List<Document> courses = analyticsService.getCoursesByCategory(category);
        return Response.ok(courses).build();
    }

    @GET
    @Path("/courses/search")
    public Response searchCourses(@QueryParam("q") String query) {
        if (query == null || query.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new Document("error", "Query parameter 'q' is required"))
                    .build();
        }
        List<Document> courses = analyticsService.searchCourses(query);
        return Response.ok(courses).build();
    }

    // ============ Videos Endpoints ============

    @GET
    @Path("/videos/trending")
    public Response getTrendingVideos(@QueryParam("limit") @DefaultValue("10") int limit) {
        List<Document> videos = analyticsService.getTrendingVideos(limit);
        return Response.ok(videos).build();
    }

    @GET
    @Path("/videos/search")
    public Response searchVideos(@QueryParam("q") String query) {
        if (query == null || query.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new Document("error", "Query parameter 'q' is required"))
                    .build();
        }
        List<Document> videos = analyticsService.searchVideos(query);
        return Response.ok(videos).build();
    }

    // ============ Students & Progress ============

    @GET
    @Path("/users/{userId}/progress")
    public Response getStudentProgress(@PathParam("userId") String userId) {
        Document progress = analyticsService.getStudentProgress(userId);
        if (progress == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new Document("error", "Student not found"))
                    .build();
        }
        return Response.ok(progress).build();
    }

    @GET
    @Path("/users/leaderboard")
    public Response getLeaderboard(@QueryParam("limit") @DefaultValue("10") int limit) {
        List<Document> leaderboard = analyticsService.getLeaderboard(limit);
        return Response.ok(leaderboard).build();
    }

    // ============ Analytics Aggregations ============

    @GET
    @Path("/categories/stats")
    public Response getCategoryStats() {
        List<Document> stats = analyticsService.aggregateByCategory();
        return Response.ok(stats).build();
    }

    @GET
    @Path("/events/stats/activities")
    public Response getActivityStats() {
        List<Document> stats = analyticsService.aggregateByActivityType();
        return Response.ok(stats).build();
    }

    @GET
    @Path("/students/stats/results")
    public Response getResultStats() {
        List<Document> stats = analyticsService.aggregateByFinalResult();
        return Response.ok(stats).build();
    }

    @GET
    @Path("/students/stats/regions")
    public Response getRegionStats() {
        List<Document> stats = analyticsService.aggregateByRegion();
        return Response.ok(stats).build();
    }

    // ============ Global Stats ============

    @GET
    @Path("/stats/global")
    public Response getGlobalStats() {
        Document stats = analyticsService.getGlobalStats();
        return Response.ok(stats).build();
    }

    // ============ Recent Events ============

    @GET
    @Path("/events/recent")
    public Response getRecentEvents(@QueryParam("limit") @DefaultValue("20") int limit) {
        List<Document> events = analyticsService.getRecentEvents(limit);
        return Response.ok(events).build();
    }

    // ============ Predictions (Analytics Avancés) ============

    @Inject
    private com.elearning.analytics.service.PredictionService predictionService;

    @GET
    @Path("/predictions/{studentId}")
    public Response getStudentRiskPrediction(@PathParam("studentId") String studentId) {
        Document prediction = predictionService.predictStudentRisk(studentId);
        if (prediction.containsKey("error")) {
            return Response.status(Response.Status.NOT_FOUND).entity(prediction).build();
        }
        return Response.ok(prediction).build();
    }

    @GET
    @Path("/predictions/at-risk")
    public Response getAtRiskStudents(@QueryParam("limit") @DefaultValue("20") int limit) {
        List<Document> atRiskStudents = predictionService.getAtRiskStudents(limit);
        return Response.ok(atRiskStudents).build();
    }

    // ============ Advanced Filters ============

    @GET
    @Path("/filters/options")
    public Response getFilterOptions() {
        Document options = analyticsService.getFilterOptions();
        return Response.ok(options).build();
    }

    @GET
    @Path("/students/filter")
    public Response filterStudents(
            @QueryParam("region") String region,
            @QueryParam("result") String result,
            @QueryParam("limit") @DefaultValue("50") int limit) {
        List<Document> students = analyticsService.filterStudents(region, result, limit);
        return Response.ok(students).build();
    }

    @GET
    @Path("/students/module-stats")
    public Response getModuleStats() {
        List<Document> stats = analyticsService.aggregateByModule();
        return Response.ok(stats).build();
    }

    @GET
    @Path("/compare-periods")
    public Response comparePeriods(
            @QueryParam("period1") @DefaultValue("2014J") String period1,
            @QueryParam("period2") @DefaultValue("2013J") String period2) {
        Document comparison = analyticsService.comparePeriods(period1, period2);
        return Response.ok(comparison).build();
    }

    // ============ ML Predictions (Hugging Face) ============

    @Inject
    private com.elearning.analytics.service.HuggingFaceService huggingFaceService;

    @GET
    @Path("/ml/predict")
    public Response predictWithML(
            @QueryParam("clicks") @DefaultValue("500") int clicks,
            @QueryParam("days") @DefaultValue("30") int days,
            @QueryParam("assessments") @DefaultValue("10") int assessments,
            @QueryParam("score") @DefaultValue("65") double score) {
        Document prediction = huggingFaceService.predictStudentRisk(clicks, days, assessments, score);
        return Response.ok(prediction).build();
    }
}
