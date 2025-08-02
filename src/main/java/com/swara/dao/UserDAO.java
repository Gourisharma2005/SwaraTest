package com.swara.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.swara.model.User;
import com.swara.util.DBConnection;

public class UserDAO {
    public User getUserByEmail(String email) {
        User user = null;

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String username = rs.getString("username");
                String password = rs.getString("password");
                String uniqueId = rs.getString("unique_id");
                String phone = rs.getString("phone");

                user = new User();
                user.setUsername(username);
                user.setPassword(password);
                user.setUniqueId(uniqueId);
                user.setEmail(email); // setting email from parameter
                user.setPhone(phone);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public boolean addUser(User user) {
        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO users (username, password, unique_id, email, phone) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getUniqueId());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
