package com.example.iotplatform.dao;

import java.util.List;
import com.example.iotplatform.model.SensorReading;

public interface SensorReadingDAO {

    void addReading(SensorReading reading);

    List<SensorReading> getAllReadings();

    SensorReading getReadingById(String readingId);

    List<SensorReading> getReadingsBySensorId(String sensorId);

    List<SensorReading> getReadingsBySensorType(String sensorType);
}