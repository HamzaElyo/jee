package com.elearning.connector.model;

/**
 * Représente un étudiant du dataset OULAD
 */
public class Student {
    private String studentId;
    private String codeModule;
    private String codePresentation;
    private String gender;
    private String region;
    private String highestEducation;
    private String ageBand;
    private String disability;
    private String finalResult; // Pass, Fail, Distinction, Withdrawn

    // Getters and Setters
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getCodeModule() { return codeModule; }
    public void setCodeModule(String codeModule) { this.codeModule = codeModule; }

    public String getCodePresentation() { return codePresentation; }
    public void setCodePresentation(String codePresentation) { this.codePresentation = codePresentation; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getHighestEducation() { return highestEducation; }
    public void setHighestEducation(String highestEducation) { this.highestEducation = highestEducation; }

    public String getAgeBand() { return ageBand; }
    public void setAgeBand(String ageBand) { this.ageBand = ageBand; }

    public String getDisability() { return disability; }
    public void setDisability(String disability) { this.disability = disability; }

    public String getFinalResult() { return finalResult; }
    public void setFinalResult(String finalResult) { this.finalResult = finalResult; }

    @Override
    public String toString() {
        return "Student{id='" + studentId + "', result='" + finalResult + "'}";
    }
}
