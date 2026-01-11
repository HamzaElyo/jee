package com.elearning.connector.model;

import java.util.UUID;

/**
 * Représente un événement d'apprentissage du dataset OULAD (studentVle.csv)
 */
public class LearningEvent {
    private String eventId;
    private String studentId;
    private String codeModule;
    private String codePresentation;
    private int siteId;
    private int date; // Jour relatif au début du cours
    private int sumClick;
    private String activityType;

    public LearningEvent() {
        this.eventId = "evt_" + UUID.randomUUID().toString().substring(0, 8);
    }

    // Getters and Setters
    public String getEventId() { return eventId; }
    public void setEventId(String eventId) { this.eventId = eventId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getCodeModule() { return codeModule; }
    public void setCodeModule(String codeModule) { this.codeModule = codeModule; }

    public String getCodePresentation() { return codePresentation; }
    public void setCodePresentation(String codePresentation) { this.codePresentation = codePresentation; }

    public int getSiteId() { return siteId; }
    public void setSiteId(int siteId) { this.siteId = siteId; }

    public int getDate() { return date; }
    public void setDate(int date) { this.date = date; }

    public int getSumClick() { return sumClick; }
    public void setSumClick(int sumClick) { this.sumClick = sumClick; }

    public String getActivityType() { return activityType; }
    public void setActivityType(String activityType) { this.activityType = activityType; }

    public String getCourseId() {
        return codeModule + "_" + codePresentation;
    }

    @Override
    public String toString() {
        return "LearningEvent{student='" + studentId + "', clicks=" + sumClick + "}";
    }
}
