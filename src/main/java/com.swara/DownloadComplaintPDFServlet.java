package com.swara;

import com.swara.dao.ComplaintDAO;
import com.swara.model.Complaint;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

import com.lowagie.text.Document;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;

public class DownloadComplaintPDFServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String anonymousId = (String) request.getSession().getAttribute("anonymous_id");
        int complaintId = Integer.parseInt(request.getParameter("id"));

        Complaint complaint = ComplaintDAO.getComplaintByAnonymousIdAndComplaintId(anonymousId, complaintId);
        if (complaint == null) {
            response.sendRedirect("SwaraUser.jsp?status=error&message=Complaint not found");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=complaint_" + complaintId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            document.add(new Paragraph("Complaint Details"));
            document.add(new Paragraph("Complaint ID: " + complaint.getId()));
            document.add(new Paragraph("Anonymous ID: " + complaint.getAnonymousId()));
            document.add(new Paragraph("Complainant Name: " + complaint.getComplaintName()));
            document.add(new Paragraph("Licensee: " + complaint.getLicensee()));
            document.add(new Paragraph("Location: " + complaint.getLocation()));
            document.add(new Paragraph("Date: " + complaint.getIncidentDate()));
            document.add(new Paragraph("Description: " + complaint.getDescription()));
            document.add(new Paragraph("Role: " + complaint.getRole()));
            document.add(new Paragraph("Department: " + complaint.getDepartment()));
            document.add(new Paragraph("Status: " + complaint.getStatus()));

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
