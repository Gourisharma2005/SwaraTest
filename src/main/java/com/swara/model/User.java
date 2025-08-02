package com.swara.model;

public class User {
    private String username;
    private String password;
    private String uniqueId;
    private String email;
    private String phone;

    public User(String username, String password, String uniqueId, String email, String phone) {
        this.username = username;
        this.password = password;
        this.uniqueId = uniqueId;
        this.email = email;
        this.phone = phone;
    }

    public User() {}

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getUniqueId() { return uniqueId; }
    public void setUniqueId(String uniqueId) { this.uniqueId = uniqueId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
