package com.elearning.connector.model;

import java.time.Instant;

/**
 * Représente un cours provenant de Udemy (via RapidAPI)
 */
public class Course {
    private String courseId;
    private String title;
    private String category;
    private String instructor;
    private String description;
    private double rating;
    private int students;
    private String duration;
    private String level;
    private String imageUrl;
    private String courseUrl;
    private String source; // "UDEMY" ou "YOUTUBE"
    private Instant fetchedAt;

    public Course() {
        this.fetchedAt = Instant.now();
    }

    // Getters and Setters
    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getStudents() { return students; }
    public void setStudents(int students) { this.students = students; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCourseUrl() { return courseUrl; }
    public void setCourseUrl(String courseUrl) { this.courseUrl = courseUrl; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public Instant getFetchedAt() { return fetchedAt; }
    public void setFetchedAt(Instant fetchedAt) { this.fetchedAt = fetchedAt; }

    @Override
    public String toString() {
        return "Course{title='" + title + "', category='" + category + "', rating=" + rating + "}";
    }
}
