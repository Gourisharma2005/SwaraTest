package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.swara.util.DBConnection;

public class UserDAO {
    public boolean validate(String username, String password) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // login success
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getUniqueId(String username) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT unique_id FROM users WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("unique_id");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
