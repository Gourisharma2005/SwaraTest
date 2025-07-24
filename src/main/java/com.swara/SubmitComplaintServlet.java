package com.swara;

import com.swara.dao.ComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class SubmitComplaintServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String against = req.getParameter("against");
        String complaint = req.getParameter("complaint_text");
        String uniqueId = (String) req.getSession().getAttribute("uniqueId");

        ComplaintDAO dao = new ComplaintDAO();
        if (dao.saveComplaint(uniqueId, against, complaint)) {
            res.getWriter().println("Complaint submitted anonymously.");
        } else {
            res.getWriter().println("Error submitting complaint.");
        }
    }
}
