package com.swara.servlet;

import com.swara.dao.ComplaintDAO;
import com.swara.model.Complaint;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class EscalationTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ComplaintDAO dao = new ComplaintDAO();
        java.util.List<Complaint> complaints = dao.getAllComplaints();
        LocalDateTime now = LocalDateTime.now();

        long tenDaysInSeconds = 10; // For testing: 10 seconds = 10 days

        for (Complaint complaint : complaints) {
            if (complaint.getCreatedAt() == null) continue;

            LocalDateTime createdAt = complaint.getCreatedAt()
                    .toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();

            long timeElapsed = Duration.between(createdAt, now).getSeconds();
            Complaint.Status currentStatus = complaint.getStatus();

            if (currentStatus == Complaint.Status.UNSEEN && timeElapsed >= tenDaysInSeconds) {
                dao.updateComplaintStatus(complaint.getId(), Complaint.Status.PENDING);
            } else if (currentStatus == Complaint.Status.PENDING && timeElapsed >= 2 * tenDaysInSeconds) {
                dao.updateComplaintStatus(complaint.getId(), Complaint.Status.IN_PROGRESS);
            } else if (currentStatus == Complaint.Status.IN_PROGRESS && timeElapsed >= 3 * tenDaysInSeconds) {
                dao.updateComplaintStatus(complaint.getId(), Complaint.Status.TRANSFERRED_TO_DIRECTOR);
            } else if (currentStatus == Complaint.Status.TRANSFERRED_TO_DIRECTOR && timeElapsed >= 4 * tenDaysInSeconds) {
                dao.updateComplaintStatus(complaint.getId(), Complaint.Status.TRANSFERRED_TO_NGO);
            } else if (currentStatus == Complaint.Status.TRANSFERRED_TO_NGO && timeElapsed >= 5 * tenDaysInSeconds) {
                dao.updateComplaintStatus(complaint.getId(), Complaint.Status.RESOLVED);
            }
        }

        response.sendRedirect("AdminDashboard.jsp");
    }
}