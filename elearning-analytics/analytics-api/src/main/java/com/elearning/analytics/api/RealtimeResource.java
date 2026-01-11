package com.elearning.analytics.api;

import com.elearning.analytics.util.MongoProducer;
import com.mongodb.client.MongoDatabase;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.sse.OutboundSseEvent;
import jakarta.ws.rs.sse.Sse;
import jakarta.ws.rs.sse.SseEventSink;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

/**
 * SSE Endpoint pour le streaming temps réel des événements
 * Properly handles connection lifecycle to avoid ClosedChannelException
 */
@Path("/realtime")
public class RealtimeResource {

    @GET
    @Path("/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public void streamEvents(@Context SseEventSink eventSink, @Context Sse sse) {
        // Create a new scheduler for each connection
        ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
        MongoDatabase database = MongoProducer.getDatabase();

        ScheduledFuture<?> task = scheduler.scheduleAtFixedRate(() -> {
            // Check if connection is still open BEFORE doing any work
            if (eventSink.isClosed()) {
                scheduler.shutdown();
                return;
            }

            try {
                // Get stats from MongoDB
                long coursesCount = database.getCollection("courses").countDocuments();
                long videosCount = database.getCollection("videos").countDocuments();
                long studentsCount = database.getCollection("students").countDocuments();
                long eventsCount = database.getCollection("events").countDocuments();

                Document stats = new Document()
                        .append("coursesCount", coursesCount)
                        .append("videosCount", videosCount)
                        .append("studentsCount", studentsCount)
                        .append("eventsCount", eventsCount);

                // Get recent events
                List<Document> events = new ArrayList<>();
                database.getCollection("events")
                        .find()
                        .sort(new Document("date", -1))
                        .limit(5)
                        .into(events);

                // Build SSE data
                Document data = new Document()
                        .append("type", "update")
                        .append("stats", stats)
                        .append("recentEvents", events)
                        .append("timestamp", System.currentTimeMillis());

                OutboundSseEvent event = sse.newEventBuilder()
                        .id(String.valueOf(System.currentTimeMillis()))
                        .name("analytics-update")
                        .data(data.toJson())
                        .build();

                // Check again before sending
                if (!eventSink.isClosed()) {
                    eventSink.send(event).exceptionally(ex -> {
                        // Connection closed, shutdown scheduler
                        scheduler.shutdown();
                        return null;
                    });
                } else {
                    scheduler.shutdown();
                }

            } catch (Exception e) {
                // Silently ignore - connection likely closed
                scheduler.shutdown();
            }
        }, 0, 5, TimeUnit.SECONDS);
    }
}
