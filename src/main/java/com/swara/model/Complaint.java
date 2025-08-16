package com.swara.model;

import java.io.InputStream;
import java.util.Date;

public class Complaint {
    public enum Status {
        UNSEEN,
        PENDING,
        IN_PROGRESS,
        TRANSFERRED_TO_DIRECTOR,
        TRANSFERRED_TO_NGO,
        RESOLVED
    }

    private int id;
    private String anonymousId, complaintName, licensee, location, incidentDate, description, role, department, fileName;
    private Status status;
    private InputStream document;
    private Date createdAt;

    public Complaint(int id, String anonymousId, String complaintName, String licensee, String location,
                     String incidentDate, String description, String role, String department, Status status,
                     InputStream document, String fileName, Date createdAt) {
        this.id = id;
        this.anonymousId = anonymousId;
        this.complaintName = complaintName;
        this.licensee = licensee;
        this.location = location;
        this.incidentDate = incidentDate;
        this.description = description;
        this.role = role;
        this.department = department;
        this.status = (status != null) ? status : Status.UNSEEN;
        this.document = document;
        this.fileName = fileName;
        this.createdAt = createdAt;
    }

    public Complaint() {
        this.createdAt = new Date();
        this.status = Status.UNSEEN;
    }

    public Complaint(int id, String anonymousId, String complaintName, String licensee, String location,
                     String incidentDate, String description, String role, String department, Status status,
                     String fileName) {
        this.id = id;
        this.anonymousId = anonymousId;
        this.complaintName = complaintName;
        this.licensee = licensee;
        this.location = location;
        this.incidentDate = incidentDate;
        this.description = description;
        this.role = role;
        this.department = department;
        this.status = (status != null) ? status : Status.UNSEEN;
        this.fileName = fileName;
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getAnonymousId() { return anonymousId; }
    public void setAnonymousId(String anonymousId) { this.anonymousId = anonymousId; }
    public String getComplaintName() { return complaintName; }
    public void setComplaintName(String complaintName) { this.complaintName = complaintName; }
    public String getLicensee() { return licensee; }
    public void setLicensee(String licensee) { this.licensee = licensee; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getIncidentDate() { return incidentDate; }
    public void setIncidentDate(String incidentDate) { this.incidentDate = incidentDate; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public InputStream getDocument() { return document; }
    public void setDocument(InputStream document) { this.document = document; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}