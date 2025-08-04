package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.swara.model.Admin;
import com.swara.util.DBConnection;

public class AdminDAO {
    public Admin getAdminByEmail(String email) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM admins WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setRole(rs.getString("role"));
                admin.setEmail(rs.getString("email"));
                return admin;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


}
