<%@ page import="com.swara.model.Complaint" %>
<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
%>

<section class="complaint-details">
    <h2>📋 Complaint Details</h2>
    <p><b>Complaint ID:</b> <%= complaint.getId() %></p>
    <p><b>Anonymous ID:</b> <%= complaint.getAnonymousId() %></p>
    <p><b>Complainant Name:</b> <%= complaint.getComplaintName() %></p>
    <p><b>Licensee:</b> <%= complaint.getLicensee() %></p>
    <p><b>Location:</b> <%= complaint.getLocation() %></p>
    <p><b>Date:</b> <%= complaint.getIncidentDate() %></p>
    <p><b>Description:</b> <%= complaint.getDescription() %></p>
    <p><b>Role:</b> <%= complaint.getRole() %></p>
    <p><b>Department:</b> <%= complaint.getDepartment() %></p>
    <p><b>Status:</b> <%= complaint.getStatus() %></p>

    <div class="buttons">
        <form action="DownloadComplaintPDFServlet" method="get">
            <input type="hidden" name="id" value="<%= complaint.getId() %>"/>
            <button type="submit" class="btn">⬇ Download as PDF</button>
        </form>
        <a href="SwaraUser.jsp" class="btn">⬅ Back to Dashboard</a>
    </div>
</section>
