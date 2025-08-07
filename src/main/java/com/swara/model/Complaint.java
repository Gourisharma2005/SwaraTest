package com.swara.model;

import java.io.InputStream;

public class Complaint {
    private int id;
    private String anonymousId, complaintName, licensee, location, incidentDate, description, role, department, status, fileName;
    private InputStream document;

    public Complaint(int id, String anonymousId, String complaintName, String licensee, String location,
                     String incidentDate, String description, String role, String department, String status,
                     InputStream document, String fileName) {
        this.id = id;
        this.anonymousId = anonymousId;
        this.complaintName = complaintName;
        this.licensee = licensee;
        this.location = location;
        this.incidentDate = incidentDate;
        this.description = description;
        this.role = role;
        this.department = department;
        this.status = status;
        this.document = document;
        this.fileName = fileName;
    }

    public int getId() { return id; }
    public String getAnonymousId() { return anonymousId; }
    public String getComplaintName() { return complaintName; }
    public String getLicensee() { return licensee; }
    public String getLocation() { return location; }
    public String getIncidentDate() { return incidentDate; }
    public String getDescription() { return description; }
    public String getRole() { return role; }
    public String getDepartment() { return department; }
    public String getStatus() { return status; }
    public InputStream getDocument() { return document; }
    public String getFileName() { return fileName; }
}