package com.example.iotplatform.model;

import java.util.Objects;

public class SensorReading {
    private String readingId;
    private String sensorId;
    private String sensorType;
    private double value;
    private String unit;
    private long timestamp;
    private String location;


    public SensorReading(String readingId, String sensorId, String sensorType, double value, String unit, long timestamp, String location) {
        this.readingId = readingId;
        this.sensorId = sensorId;
        this.sensorType = sensorType;
        this.value = value;
        this.unit = unit;
        this.timestamp = timestamp;
        this.location = location;
    }

    public String getReadingId() {
        return readingId;
    }

    public void setReadingId(String readingId) {
        this.readingId = readingId;
    }

    public String getSensorId() {
        return sensorId;
    }

    public void setSensorId(String sensorId) {
        this.sensorId = sensorId;
    }

    public String getSensorType() {
        return sensorType;
    }

    public void setSensorType(String sensorType) {
        this.sensorType = sensorType;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        SensorReading that = (SensorReading) o;
        return Double.compare(value, that.value) == 0 && timestamp == that.timestamp && Objects.equals(readingId, that.readingId) && Objects.equals(sensorId, that.sensorId) && Objects.equals(sensorType, that.sensorType) && Objects.equals(unit, that.unit) && Objects.equals(location, that.location);
    }

    @Override
    public int hashCode() {
        return Objects.hash(readingId, sensorId, sensorType, value, unit, timestamp, location);
    }

    @Override
    public String toString() {
        return "SensorReading{" +
                "readingId='" + readingId + '\'' +
                ", sensorId='" + sensorId + '\'' +
                ", sensorType='" + sensorType + '\'' +
                ", value=" + value +
                ", unit='" + unit + '\'' +
                ", timestamp=" + timestamp +
                ", location='" + location + '\'' +
                '}';
    }
}