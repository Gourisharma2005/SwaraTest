package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.swara.model.Admin;
import com.swara.util.DBConnection;

public class AdminDAO {
    public Admin getAdminByUsername(String username) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM admins WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setRole(rs.getString("role"));
                return admin;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


}
