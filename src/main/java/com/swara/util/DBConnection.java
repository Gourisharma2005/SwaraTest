package com.swara.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    static String url = "jdbc:mysql://localhost:3306/swara";
    private static final String USER = "root";
    private static final String PASSWORD = "Harshitapanwar@17";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, USER, PASSWORD);
    }
}