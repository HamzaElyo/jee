package com.streaming.analytics.api;

import com.streaming.analytics.model.Video;
import com.streaming.analytics.model.VideoStats;
import com.streaming.analytics.model.ViewEvent;
import com.streaming.analytics.repository.VideoStatsRepository;
import com.streaming.analytics.service.AnalyticsService;
import com.streaming.analytics.service.EventProcessorService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.sse.OutboundSseEvent;
import jakarta.ws.rs.sse.Sse;
import jakarta.ws.rs.sse.SseEventSink;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

@Path("/analytics")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AnalyticsResource {

    @Inject
    private EventProcessorService processor;

    @Inject
    private AnalyticsService analyticsService;

    @Inject
    private VideoStatsRepository videoStatsRepository;

    // POST /api/v1/analytics/events - Ingère un événement
    @POST
    @Path("/events")
    public Response ingestEvent(ViewEvent event) {
        processor.processEvent(event);
        return Response.ok("{\"status\":\"received\"}").build();
    }

    // POST /api/v1/analytics/events/batch - Ingère un lot d'événements
    @POST
    @Path("/events/batch")
    public Response ingestBatch(List<ViewEvent> events) {
        int count = 0;
        for (ViewEvent event : events) {
            processor.processEvent(event);
            count++;
        }
        return Response.ok("{\"processed\":" + count + "}").build();
    }

    // GET /api/v1/analytics/videos/top - Top vidéos par vues (from Video
    // collection)
    @GET
    @Path("/videos/top")
    public Response getTopVideos(@QueryParam("limit") @DefaultValue("10") int limit) {
        // Use actual views from Video collection instead of event counts
        List<Map<String, Object>> topVideos = analyticsService.getTopVideosByViews(limit);
        return Response.ok(topVideos).build();
    }

    // GET /api/v1/analytics/videos/{videoId}/stats - Stats d'une vidéo spécifique
    @GET
    @Path("/videos/{videoId}/stats")
    public Response getVideoStats(@PathParam("videoId") String videoId) {
        Optional<VideoStats> statsOpt = videoStatsRepository.findById(videoId);
        if (statsOpt.isPresent()) {
            return Response.ok(statsOpt.get()).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\":\"Video not found\"}")
                    .build();
        }
    }

    // GET /api/v1/analytics/users - Liste des utilisateurs réels avec stats
    @GET
    @Path("/users")
    public Response getUsers(@QueryParam("limit") @DefaultValue("50") int limit) {
        List<Map<String, Object>> users = analyticsService.getUsersWithStats(limit);
        return Response.ok(users).build();
    }

    // GET /api/v1/analytics/users/{userId}/recommendations - Recommandations
    // personnalisées
    @GET
    @Path("/users/{userId}/recommendations")
    public Response getRecommendations(@PathParam("userId") String userId) {
        List<Video> recommendations = analyticsService.getRecommendations(userId);
        return Response.ok(recommendations).build();
    }

    // GET /api/v1/analytics/categories/stats - Statistiques par catégorie
    @GET
    @Path("/categories/stats")
    public Response getCategoryStats() {
        Map<String, Map<String, Object>> categoryStats = analyticsService.aggregateByCategory();
        return Response.ok(categoryStats).build();
    }

    // GET /api/v1/analytics/trending - Vidéos tendance
    @GET
    @Path("/trending")
    public Response getTrending(@QueryParam("limit") @DefaultValue("10") int limit) {
        List<VideoStats> trending = analyticsService.detectTrending(limit);
        return Response.ok(trending).build();
    }

    // GET /api/v1/analytics/realtime/stream - Stream SSE temps réel
    @GET
    @Path("/realtime/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public void streamRealtime(@Context SseEventSink eventSink, @Context Sse sse) {
        Executors.newSingleThreadScheduledExecutor().scheduleAtFixedRate(() -> {
            if (eventSink.isClosed())
                return;
            try {
                List<VideoStats> topVideos = processor.getTopVideos(5);
                StringBuilder json = new StringBuilder("{\"timestamp\":");
                json.append(System.currentTimeMillis());
                json.append(",\"topVideos\":[");
                for (int i = 0; i < topVideos.size(); i++) {
                    if (i > 0)
                        json.append(",");
                    VideoStats v = topVideos.get(i);
                    json.append("{\"videoId\":\"").append(v.getVideoId())
                            .append("\",\"views\":").append(v.getTotalViews()).append("}");
                }
                json.append("]}");

                OutboundSseEvent event = sse.newEventBuilder()
                        .name("stats-update")
                        .data(String.class, json.toString())
                        .build();
                eventSink.send(event);
            } catch (Exception e) {
                // Ignore errors
            }
        }, 0, 2, TimeUnit.SECONDS);
    }

    // GET /api/v1/analytics/health - Health check
    @GET
    @Path("/health")
    public Response health() {
        return Response.ok("{\"status\":\"UP\"}").build();
    }

    // GET /api/v1/analytics/events/stats/actions - Stats par type d'action
    @GET
    @Path("/events/stats/actions")
    public Response getActionStats() {
        Map<String, Long> actionStats = analyticsService.aggregateByAction();
        return Response.ok(actionStats).build();
    }

    // GET /api/v1/analytics/events/stats/devices - Stats par type d'appareil
    @GET
    @Path("/events/stats/devices")
    public Response getDeviceStats() {
        Map<String, Long> deviceStats = analyticsService.aggregateByDevice();
        return Response.ok(deviceStats).build();
    }

    // GET /api/v1/analytics/events/recent - Événements récents
    @GET
    @Path("/events/recent")
    public Response getRecentEvents(@QueryParam("limit") @DefaultValue("50") int limit) {
        List<Map<String, Object>> events = analyticsService.getRecentEvents(limit);
        return Response.ok(events).build();
    }

    // GET /api/v1/analytics/stats/global - Statistiques globales
    @GET
    @Path("/stats/global")
    public Response getGlobalStats() {
        Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalEvents", analyticsService.getTotalEventCount());
        stats.put("totalVideos", analyticsService.getTotalVideoCount());
        return Response.ok(stats).build();
    }

    // ==================== YouTube API Endpoints ====================

    @Inject
    private com.streaming.analytics.service.YouTubeService youtubeService;

    // GET /api/v1/analytics/youtube/trending - Vidéos tendances YouTube par région
    @GET
    @Path("/youtube/trending")
    public Response getYoutubeTrending(@QueryParam("limit") @DefaultValue("10") int limit,
            @QueryParam("region") @DefaultValue("MA") String region) {
        java.util.List<Map<String, Object>> trending = youtubeService.getTrendingVideos(limit, region);
        return Response.ok(trending).build();
    }

    // GET /api/v1/analytics/youtube/search - Recherche de vidéos
    @GET
    @Path("/youtube/search")
    public Response searchYoutube(@QueryParam("q") String query, @QueryParam("limit") @DefaultValue("10") int limit) {
        if (query == null || query.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\":\"Query parameter 'q' is required\"}").build();
        }
        java.util.List<Map<String, Object>> results = youtubeService.searchVideos(query, limit);
        return Response.ok(results).build();
    }

    // GET /api/v1/analytics/youtube/video/{videoId} - Détails d'une vidéo YouTube
    @GET
    @Path("/youtube/video/{videoId}")
    public Response getYoutubeVideo(@PathParam("videoId") String videoId) {
        Map<String, Object> video = youtubeService.getVideoDetails(videoId);
        if (video.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND).entity("{\"error\":\"Video not found\"}").build();
        }
        return Response.ok(video).build();
    }
}
