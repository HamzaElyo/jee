package com.streaming.analytics.service;

import com.streaming.analytics.model.VideoStats;
import com.streaming.analytics.model.ViewEvent;
import com.streaming.analytics.repository.EventRepository;
import com.streaming.analytics.repository.VideoStatsRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventProcessorService {

    @Inject
    private EventRepository eventRepository;

    @Inject
    private VideoStatsRepository videoStatsRepository;

    public void processEvent(ViewEvent event) {
        // 1. Sauvegarder l'événement brut
        eventRepository.save(event);

        // 2. Mettre à jour les statistiques de la vidéo
        updateVideoStats(event);
    }

    private void updateVideoStats(ViewEvent event) {
        Optional<VideoStats> statsOpt = videoStatsRepository.findById(event.getVideoId());
        VideoStats stats = statsOpt.orElse(new VideoStats());

        if (stats.getVideoId() == null) {
            stats.setVideoId(event.getVideoId());
            stats.setTotalViews(0);
            stats.setAvgDuration(0);
        }

        // Mise à jour incrémentale simple
        long newTotalViews = stats.getTotalViews() + 1;
        double newAvgDuration = ((stats.getAvgDuration() * stats.getTotalViews()) + event.getDuration())
                / newTotalViews;

        stats.setTotalViews(newTotalViews);
        stats.setAvgDuration(newAvgDuration);
        stats.setLastUpdated(new Date());

        videoStatsRepository.save(stats);
    }

    public List<VideoStats> getTopVideos(int limit) {
        return videoStatsRepository.getTopVideos(limit);
    }
}
