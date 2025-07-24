package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.swara.util.DBConnection;

public class ComplaintDAO {
    public boolean saveComplaint(String uniqueId, String against, String text) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO complaints (user_unique_id, against_person, complaint_text) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, uniqueId);
            ps.setString(2, against);
            ps.setString(3, text);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
