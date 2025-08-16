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
            String sql = "INSERT INTO complaints (anonymous_id, complaint_name, licensee, location, incident_date, description, role, department, status, document, file_name, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, complaint.getAnonymousId());
            stmt.setString(2, complaint.getComplaintName());
            stmt.setString(3, complaint.getLicensee());
            stmt.setString(4, complaint.getLocation());
            stmt.setString(5, complaint.getIncidentDate());
            stmt.setString(6, complaint.getDescription());
            stmt.setString(7, complaint.getRole());
            stmt.setString(8, complaint.getDepartment());
            stmt.setString(9, complaint.getStatus() != null ? complaint.getStatus().name() : Complaint.Status.UNSEEN.name());
            if (complaint.getDocument() != null) {
                stmt.setBlob(10, complaint.getDocument());
                stmt.setString(11, complaint.getFileName());
            } else {
                stmt.setNull(10, Types.BLOB);
                stmt.setNull(11, Types.VARCHAR);
            }
            stmt.setTimestamp(12, new Timestamp(complaint.getCreatedAt().getTime()));
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
                try {
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
                            Complaint.Status.valueOf(rs.getString("status").toUpperCase()), // Handle case sensitivity
                            rs.getString("file_name")
                    );
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaints.add(complaint);
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid status value in database: " + rs.getString("status"));
                    // Set to UNSEEN as fallback
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
                            Complaint.Status.UNSEEN,
                            rs.getString("file_name")
                    );
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaints.add(complaint);
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching complaints: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }

    public static List<Complaint> getComplaintsByAnonymousId(String anonymousId) {
        List<Complaint> complaints = new ArrayList<>();
        if (anonymousId == null || anonymousId.trim().isEmpty()) {
            return complaints;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM complaints WHERE anonymous_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, anonymousId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                try {
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
                            Complaint.Status.valueOf(rs.getString("status").toUpperCase()),
                            rs.getString("file_name")
                    );
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaints.add(complaint);
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid status value in database: " + rs.getString("status"));
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
                            Complaint.Status.UNSEEN,
                            rs.getString("file_name")
                    );
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaints.add(complaint);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public static boolean updateComplaintStatus(int complaintId, Complaint.Status status) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE complaints SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.name());
            stmt.setInt(2, complaintId);
            int rowsAffected = stmt.executeUpdate();
            success = rowsAffected > 0;
            System.out.println("Update complaint status: Rows affected = " + rowsAffected);
        } catch (Exception e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public static Complaint getComplaintByAnonymousIdAndComplaintId(String anonymousId, int complaintId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM complaints WHERE anonymous_id = ? AND id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, anonymousId);
            stmt.setInt(2, complaintId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Complaint(
                        rs.getInt("id"),
                        rs.getString("anonymous_id"),
                        rs.getString("complaint_name"),
                        rs.getString("licensee"),
                        rs.getString("location"),
                        rs.getString("incident_date"),
                        rs.getString("description"),
                        rs.getString("role"),
                        rs.getString("department"),
                        Complaint.Status.valueOf(rs.getString("status").toUpperCase()),
                        rs.getString("file_name")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}