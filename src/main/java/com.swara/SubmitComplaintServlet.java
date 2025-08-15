package com.swara;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import com.swara.model.Complaint;
import com.swara.dao.ComplaintDAO;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB limit
public class SubmitComplaintServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Get anonymous ID from form OR session
            String anonymousId = request.getParameter("anonymous_id");
            if (anonymousId == null || anonymousId.trim().isEmpty()) {
                anonymousId = (String) session.getAttribute("anonymous_id");
            }

            // Extract other form data
            String complaintName = request.getParameter("complaint_name");
            String licensee = request.getParameter("licensee");
            String location = request.getParameter("location");
            String incidentDate = request.getParameter("incident_date");
            String description = request.getParameter("description");
            String role = request.getParameter("role");
            String department = request.getParameter("department");

            // Validate required fields
            if (complaintName == null || complaintName.trim().isEmpty() ||
                    location == null || location.trim().isEmpty() ||
                    incidentDate == null || incidentDate.trim().isEmpty() ||
                    description == null || description.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Missing required fields");
                return;
            }

            // Validate department if recipient is HOD
            if ("HOD".equalsIgnoreCase(role) && (department == null || department.trim().isEmpty())) {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Department is required for HOD complaints");
                return;
            }

            // Handle file upload
            Part filePart = request.getPart("document");
            InputStream fileContent = null;
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!contentType.equals("application/pdf") && !contentType.startsWith("image/")) {
                    response.sendRedirect("SwaraUser.jsp?status=error&message=Invalid file format");
                    return;
                }
                fileContent = filePart.getInputStream();
                fileName = filePart.getSubmittedFileName();
            }

            // Create Complaint object
            Complaint complaint = new Complaint(
                    0, // ID will be auto-generated
                    anonymousId != null ? anonymousId.trim() : null,
                    complaintName.trim(),
                    licensee != null ? licensee.trim() : null,
                    location.trim(),
                    incidentDate.trim(),
                    description.trim(),
                    role.trim(),
                    department != null ? department.trim() : null,
                    "Pending", // Default status
                    fileName
            );

            // Insert into database
            boolean result = ComplaintDAO.insertComplaint(complaint);
            response.sendRedirect("SwaraUser.jsp?status=" + (result ? "success" : "error") +
                    "&message=" + (result ? "Complaint submitted successfully" : "Failed to submit complaint"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("SwaraUser.jsp?status=error&message=Server error: " + e.getMessage());
        }
    }
}
