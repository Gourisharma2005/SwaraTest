package com.swara.model;

public class AdminDemoModel {
    private String username;
    private String role; // HOD or Director

    // Constructor
    public AdminDemoModel(String username, String role) {
        this.username = username;
        this.role = role;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}