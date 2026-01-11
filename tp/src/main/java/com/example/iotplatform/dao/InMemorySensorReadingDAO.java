package com.example.iotplatform.dao;

import com.example.iotplatform.model.SensorReading;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@ApplicationScoped  // CDI : un seul objet partagé pour toute l’application
public class InMemorySensorReadingDAO implements SensorReadingDAO {

    // Stockage en mémoire
    private final Map<String, SensorReading> readingsMap = new ConcurrentHashMap<>();

    @Override
    public void addReading(SensorReading reading) {
        readingsMap.put(reading.getReadingId(), reading);
    }

    @Override
    public List<SensorReading> getAllReadings() {
        return new ArrayList<>(readingsMap.values());
    }

    @Override
    public SensorReading getReadingById(String readingId) {
        return readingsMap.get(readingId);
    }

    @Override
    public List<SensorReading> getReadingsBySensorId(String sensorId) {
        return readingsMap.values().stream()
                .filter(r -> r.getSensorId().equals(sensorId))
                .collect(Collectors.toList());
    }

    @Override
    public List<SensorReading> getReadingsBySensorType(String sensorType) {
        return readingsMap.values().stream()
                .filter(r -> r.getSensorType().equalsIgnoreCase(sensorType))
                .collect(Collectors.toList());
    }
}