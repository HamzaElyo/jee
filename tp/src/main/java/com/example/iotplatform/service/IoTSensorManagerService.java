package com.example.iotplatform.service;

import com.example.iotplatform.dao.SensorReadingDAO;
import com.example.iotplatform.model.SensorReading;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped  // Service partagé dans l’application
public class IoTSensorManagerService {

    @Inject
    private SensorReadingDAO sensorReadingDAO;

    // Ingestion d'une nouvelle lecture
    public void ingestSensorReading(SensorReading reading) {
        sensorReadingDAO.addReading(reading);
    }

    // Récupérer toutes les lectures
    public List<SensorReading> retrieveAllSensorReadings() {
        return sensorReadingDAO.getAllReadings();
    }

    // Récupérer une lecture par ID
    public SensorReading findReadingById(String readingId) {
        return sensorReadingDAO.getReadingById(readingId);
    }

    // Filtrer par type de capteur
    public List<SensorReading> filterReadingsBySensorType(String sensorType) {
        return sensorReadingDAO.getReadingsBySensorType(sensorType);
    }

    // Obtenir les dernières lectures ajoutées
    public List<SensorReading> getLatestReadings(int limit) {
        return sensorReadingDAO.getAllReadings().stream()
                .sorted(Comparator.comparing(SensorReading::getTimestamp).reversed())
                .limit(limit)
                .collect(Collectors.toList());
    }
}