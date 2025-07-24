package com.swara.util;

import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("✅ Database connection successful.");
        } catch (Exception e) {
            System.out.println("❌ Failed to connect.");
            e.printStackTrace();
        }
    }
}

