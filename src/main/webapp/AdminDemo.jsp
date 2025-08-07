<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.swara.model.Complaint" %>
<%@ page import="com.swara.model.AdminDemoModel" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Swara Admin Dashboard</title>
  <link rel="stylesheet" href="css/SwaraAdmin.css" />
</head>
<body>
  <header>
    <div class="logo">Swara - Admin Portal</div>
    <div class="profile">
      <img src="https://via.placeholder.com/40" alt="Admin Profile" />
      <span>Hello, <%= session.getAttribute("admin") != null ? ((Admin) session.getAttribute("admin")).getUsername() : "Admin" %></span>
    </div>
  </header>

  <div class="container">
    <aside class="sidebar">
      <ul class="menu">
        <li class="section-title">📥 Complaints</li>
        <li class="section-title">📊 Reports</li>
        <li class="section-title">⚙️ Settings</li>
        <li class="section-title"><a href="logout">Logout</a></li>
      </ul>
    </aside>

    <main class="main-content">
      <h1>Admin Dashboard</h1>
      <section class="complaint-list">
        <h2>Assigned Complaints</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Anonymous ID</th>
              <th>Location</th>
              <th>Date</th>
              <th>Description</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
              AdminDemoModel admin = (AdminDemoModel) session.getAttribute("admin");
              String role = admin != null ? admin.getRole() : "HOD"; // Assume role is HOD or Director
              List<Complaint> complaints = ComplaintDAO.getComplaintsByRecipient(role);
              if (complaints != null) {
                for (Complaint complaint : complaints) {
            %>
              <tr>
                <td><%= complaint.getId() %></td>
                <td><%= complaint.getAnonymousId() %></td>
                <td><%= complaint.getLocation() %></td>
                <td><%= new SimpleDateFormat("yyyy-MM-dd").format(complaint.getIncidentDate()) %></td>
                <td><%= complaint.getDescription() %></td>
                <td><span class="status <%= complaint.getStatus().toLowerCase() %>"><%= complaint.getStatus() %></span></td>
                <td>
                  <a href="ViewComplaintServlet?id=<%= complaint.getId() %>">View</a>
                  <% if (complaint.getFilePath() != null) { %>
                    <a href="<%= complaint.getFilePath() %>" download>Download</a>
                  <% } %>
                </td>
              </tr>
            <%
                }
              }
            %>
          </tbody>
        </table>
      </section>
    </main>
  </div>
</body>
</html>