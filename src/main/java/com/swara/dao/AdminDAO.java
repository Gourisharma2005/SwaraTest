package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.swara.util.DBConnection;

public class AdminDAO {
    public boolean validate(String username, String password, String role) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM admins WHERE username = ? AND password = ? AND role = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
