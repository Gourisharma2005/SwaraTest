package com.swara.servlet;

import com.swara.dao.ComplaintDAO;
import com.swara.model.Complaint;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ViewComplaintServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the current user's anonymous_id from session
        String anonymousId = (String) request.getSession().getAttribute("anonymous_id");
        // Get complaint ID from URL param
        String complaintIdParam = request.getParameter("id");

        if (anonymousId != null && complaintIdParam != null) {
            try {
                int complaintId = Integer.parseInt(complaintIdParam);

                // Fetch complaint by anonymous_id and complaint_id
                Complaint complaint = ComplaintDAO.getComplaintByAnonymousIdAndComplaintId(anonymousId, complaintId);

                if (complaint != null) {
                    // Put complaint object in request
                    request.setAttribute("complaint", complaint);
                    // Set flag to tell SwaraUser.jsp to show complaint page
                    request.setAttribute("page", "viewComplaint");

                    // Forward to dashboard layout (header + sidebar always visible)
                    request.getRequestDispatcher("SwaraUser.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // If complaint not found, redirect to dashboard with error
        response.sendRedirect("SwaraUser.jsp?status=error&message=Complaint not found");
    }
}
