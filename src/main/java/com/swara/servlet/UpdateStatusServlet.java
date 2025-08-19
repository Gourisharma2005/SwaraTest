package com.swara.servlet;

import com.swara.dao.ComplaintDAO;
import com.swara.model.Complaint;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UpdateStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get complaintId and status from request parameters
        String complaintIdStr = request.getParameter("complaint_id"); // Changed from anonymous_id to complaint_id
        String statusStr = request.getParameter("status");

        ComplaintDAO dao = new ComplaintDAO();

        if (complaintIdStr != null && statusStr != null) {
            try {
                int complaintId = Integer.parseInt(complaintIdStr.trim());
                // Convert status string to Complaint.Status enum
                Complaint.Status status = Complaint.Status.valueOf(statusStr.trim().toUpperCase());

                // Update the status
                if (dao.updateComplaintStatus(complaintId, status)) {
                    response.sendRedirect("AdminDashboard.jsp?status=success&message=Status updated");
                } else {
                    response.sendRedirect("AdminDashboard.jsp?status=error&message=Failed to update status");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("AdminDashboard.jsp?status=error&message=Invalid complaint ID");
            } catch (IllegalArgumentException e) {
                response.sendRedirect("AdminDashboard.jsp?status=error&message=Invalid status value");
            }
        } else {
            response.sendRedirect("AdminDashboard.jsp?status=error&message=Missing complaint ID or status");
        }
    }
}