package com.swara.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.util.Date;

import com.swara.model.Complaint;
import com.swara.dao.ComplaintDAO;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB limit
public class SubmitComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            String anonymousId = request.getParameter("anonymous_id");
            if (anonymousId == null || anonymousId.trim().isEmpty()) {
                anonymousId = (String) session.getAttribute("anonymous_id");
                if (anonymousId == null || anonymousId.trim().isEmpty()) {
                    response.sendRedirect("SwaraUser.jsp?status=error&message=Anonymous ID not found");
                    return;
                }
            }

            String complaintName = request.getParameter("complaint_name");
            String licensee = request.getParameter("licensee");
            String location = request.getParameter("location");
            String incidentDateStr = request.getParameter("incident_date");
            String description = request.getParameter("description");
            String role = request.getParameter("role");
            String department = request.getParameter("department");

            if (complaintName == null || complaintName.trim().isEmpty() ||
                    location == null || location.trim().isEmpty() ||
                    incidentDateStr == null || incidentDateStr.trim().isEmpty() ||
                    description == null || description.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Missing required fields");
                return;
            }

            if ("HOD".equalsIgnoreCase(role) && (department == null || department.trim().isEmpty())) {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Department is required for HOD complaints");
                return;
            }

            try {
                LocalDate.parse(incidentDateStr.trim());
            } catch (Exception e) {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Invalid incident date format");
                return;
            }

            Part filePart = request.getPart("document");
            InputStream document = null;
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!contentType.equals("application/pdf") && !contentType.startsWith("image/")) {
                    response.sendRedirect("SwaraUser.jsp?status=error&message=Invalid file format");
                    return;
                }
                document = filePart.getInputStream();
                fileName = filePart.getSubmittedFileName();
            }

            Complaint complaint = new Complaint(
                    0,
                    anonymousId.trim(),
                    complaintName.trim(),
                    licensee != null ? licensee.trim() : null,
                    location.trim(),
                    incidentDateStr.trim(),
                    description.trim(),
                    role.trim(),
                    "HOD".equalsIgnoreCase(role) ? department.trim() : null,
                    Complaint.Status.UNSEEN,
                    document,
                    fileName,
                    new Date()
            );

            boolean result = ComplaintDAO.insertComplaint(complaint);
            if (result) {
                response.sendRedirect("SwaraUser.jsp?status=success&message=Complaint submitted successfully");
            } else {
                response.sendRedirect("SwaraUser.jsp?status=error&message=Failed to submit complaint");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("SwaraUser.jsp?status=error&message=An error occurred. Please try again later.");
        }
    }
}