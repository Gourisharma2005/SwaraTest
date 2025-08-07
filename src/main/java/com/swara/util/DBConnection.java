package com.swara.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/Swara?useSSL=false";
        String user = "root";
        String password = "Harshitapanwar@17";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Database connection established successfully");
            return conn;
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
        }
    }
}