package com.swara.dao;

import com.swara.model.Complaint;
import com.swara.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    public static boolean insertComplaint(Complaint complaint) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO complaints (anonymous_id, complaint_name, licensee, location, incident_date, description, role, department, status, document, file_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, complaint.getAnonymousId());
            stmt.setString(2, complaint.getComplaintName());
            stmt.setString(3, complaint.getLicensee());
            stmt.setString(4, complaint.getLocation());
            stmt.setString(5, complaint.getIncidentDate());
            stmt.setString(6, complaint.getDescription());
            stmt.setString(7, complaint.getRole());
            stmt.setString(8, complaint.getDepartment());
            stmt.setString(9, complaint.getStatus());
            if (complaint.getDocument() != null) {
                stmt.setBlob(10, complaint.getDocument());
                stmt.setString(11, complaint.getFileName());
            } else {
                stmt.setNull(10, Types.BLOB);
                stmt.setNull(11, Types.VARCHAR);
            }
            int rowsAffected = stmt.executeUpdate();
            success = rowsAffected > 0;
            System.out.println("Insert complaint: Rows affected = " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public static List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM complaints";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Complaint complaint = new Complaint(
                        rs.getInt("id"),
                        rs.getString("anonymous_id"),
                        rs.getString("complaint_name"),
                        rs.getString("licensee"),
                        rs.getString("location"),
                        rs.getString("incident_date"),
                        rs.getString("description"),
                        rs.getString("role"),
                        rs.getString("department"),
                        rs.getString("status"),
                        null, // Document not retrieved for listing
                        rs.getString("file_name")
                );
                complaints.add(complaint);
            }
        } catch (Exception e) {
            System.err.println("Error fetching complaints: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }
}