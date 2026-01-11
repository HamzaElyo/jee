package com.streaming.analytics.repository;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import com.streaming.analytics.model.ViewEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.bson.Document;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static com.mongodb.client.model.Filters.eq;

@ApplicationScoped
public class EventRepository {

    @Inject
    private MongoDatabase database;

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

    private MongoCollection<Document> getCollection() {
        return database.getCollection("events");
    }

    public void save(ViewEvent event) {
        if (event.getEventId() == null) {
            event.setEventId(UUID.randomUUID().toString());
        }
        if (event.getTimestamp() == null) {
            event.setTimestamp(DATE_FORMAT.format(new Date()));
        }

        Document doc = new Document()
                .append("_id", event.getEventId())
                .append("eventId", event.getEventId())
                .append("videoId", event.getVideoId())
                .append("userId", event.getUserId())
                .append("action", event.getAction())
                .append("duration", event.getDuration())
                .append("timestamp", event.getTimestamp())
                .append("deviceType", event.getDeviceType())
                .append("quality", event.getQuality());

        getCollection().insertOne(doc);
    }

    public List<ViewEvent> findByUserId(String userId) {
        List<ViewEvent> result = new ArrayList<>();

        for (Document doc : getCollection().find(eq("userId", userId)).sort(Sorts.descending("timestamp"))) {
            result.add(documentToViewEvent(doc));
        }

        return result;
    }

    public List<ViewEvent> findByVideoId(String videoId) {
        List<ViewEvent> result = new ArrayList<>();

        for (Document doc : getCollection().find(eq("videoId", videoId)).sort(Sorts.descending("timestamp"))) {
            result.add(documentToViewEvent(doc));
        }

        return result;
    }

    private ViewEvent documentToViewEvent(Document doc) {
        ViewEvent event = new ViewEvent();
        event.setEventId(doc.getString("eventId"));
        event.setVideoId(doc.getString("videoId"));
        event.setUserId(doc.getString("userId"));
        event.setAction(doc.getString("action"));
        event.setDuration(doc.getInteger("duration") != null ? doc.getInteger("duration") : 0);
        event.setTimestamp(doc.getString("timestamp"));
        event.setDeviceType(doc.getString("deviceType"));
        event.setQuality(doc.getString("quality"));
        return event;
    }
}
