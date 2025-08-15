<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.swara.model.User" %>
<%@ page import="com.swara.model.Complaint" %>
<%@ page import="com.swara.dao.ComplaintDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Swara User Dashboard</title>
  <link rel="stylesheet" href="css/SwaraUser.css" />
</head>
<body>
  <header>
    <div class="logo">Swara - User Portal</div>
    <div class="profile">
      <span>Hello, <%= session.getAttribute("user") != null ? ((User) session.getAttribute("user")).getUsername() : "Guest" %></span>
    </div>
  </header>

  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <ul class="menu">
        <li class="section-title">📥 My Complaints</li>
        <li class="section-title">📍 Track Status</li>
        <li class="section-title">📋 File a Case</li>
        <li class="section-title">💬 Chat</li>
        <div class="filters">
          <h3>🔎 Filter Complaints</h3>
          <input type="text" placeholder="Search..." onkeyup="filterTable(this.value)" />
          <select onchange="filterTable(document.querySelector('.filters input').value, this.value)">
            <option value="">Status</option>
            <option value="Pending">Pending</option>
            <option value="Resolved">Resolved</option>
          </select>
          <input type="date" onchange="filterTable(document.querySelector('.filters input').value, document.querySelector('.filters select').value, this.value)" />
        </div>
        <li class="section-title">⚙️ Settings</li>
        <li class="section-title"><a href="logout">Logout</a></li>
      </ul>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      <!-- Dashboard Section -->
      <section class="dashboard" id="dashboardContent">
        <h1>Welcome to Your Safe Space 💖</h1>

        <!-- Display success/error message -->
        <%
          String status = request.getParameter("status");
          String message = request.getParameter("message");
          if (status != null) {
        %>
        <div class="alert <%= status.equals("success") ? "alert-success" : "alert-error" %>">
          <%= message != null ? message : (status.equals("success") ? "Complaint submitted successfully!" : "Failed to submit complaint.") %>
        </div>
        <% } %>

        <!-- Display anonymous_id -->
        <section>
          <h2>Your Anonymous ID</h2>
          <p><%= session.getAttribute("anonymous_id") != null ? session.getAttribute("anonymous_id") : "Not available" %></p>
        </section>

        <section class="stats">
          <div class="card">
            <h2><%= session.getAttribute("activeComplaints") != null ? session.getAttribute("activeComplaints") : "0" %></h2>
            <p>Active Complaints</p>
          </div>
          <div class="card">
            <h2><%= session.getAttribute("resolvedComplaints") != null ? session.getAttribute("resolvedComplaints") : "0" %></h2>
            <p>Resolved</p>
          </div>
          <div class="card">
            <h2><%= session.getAttribute("escalatedComplaints") != null ? session.getAttribute("escalatedComplaints") : "0" %></h2>
            <p>Escalated</p>
          </div>
        </section>

        <!-- Dynamic Complaint History Table -->
        <section class="complaint-history">
          <h2>📋 My Complaints</h2>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Subject</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
<tbody>
<%
    String anonymousId = (String) session.getAttribute("anonymous_id");
    List<Complaint> complaints = ComplaintDAO.getComplaintsByAnonymousId(anonymousId);

    if (complaints.isEmpty()) {
%>
    <tr>
        <td colspan="4">No complaints found.</td>
    </tr>
<%
    } else {
        for (Complaint complaint : complaints) {
%>
    <tr>
        <td><%= complaint.getId() %></td>
        <td><%= complaint.getComplaintName() %></td>
        <td><span class="status <%= complaint.getStatus().toLowerCase() %>"><%= complaint.getStatus() %></span></td>
        <td><button onclick="viewComplaint('<%= complaint.getId() %>')">View</button></td>
    </tr>
<%
        }
    }
%>
</tbody>

          </table>
        </section>
      </section>

      <!-- Complaint Form Section (Hidden by Default) -->
      <section class="form-section" id="complaintFormSection" style="display: none;">
        <h1>Submit a Complaint</h1>
        <form class="complaint-form" action="SubmitComplaintServlet" method="post" enctype="multipart/form-data" novalidate>
          <fieldset>
            <legend>Personal Details</legend>
            <div class="form-group">
              <label for="anonymous_id">Anonymous ID</label>
              <input type="text" id="anonymous_id" name="anonymous_id" placeholder="Leave blank if you want to stay anonymous" />
            </div>
            <div class="form-group">
              <label for="complaint_name">Complainant Name *</label>
              <input type="text" id="complaint_name" name="complaint_name" required placeholder="Your full name" autocomplete="name" />
            </div>
          </fieldset>
          <fieldset>
            <legend>Incident Details</legend>
            <div class="form-group">
              <label for="licensee">Name of Licensee</label>
              <input type="text" id="licensee" name="licensee" placeholder="Name of the accused (if known)" />
            </div>
            <div class="form-group">
              <label for="location">Place of Incident *</label>
              <input type="text" id="location" name="location" required placeholder="E.g., Chemistry Lab, Corridor" />
            </div>
            <div class="form-group">
              <label for="date">Date of Incident *</label>
              <input type="date" id="date" name="incident_date" required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" />
            </div>
            <div class="form-group full-width">
              <label for="description">Description *</label>
              <textarea id="description" name="description" rows="4" required placeholder="Describe the incident in detail..."></textarea>
            </div>
          </fieldset>
          <fieldset>
            <legend>Recipient</legend>
            <div class="form-group">
              <label for="role">Send Complaint To *</label>
              <select id="role" name="role" required onchange="toggleDepartmentField()">
                <option value="" disabled selected>Select recipient</option>
                <option value="HOD">Head of Department (HOD)</option>
                <option value="Director">Director</option>
              </select>
            </div>
            <div class="form-group" id="departmentField" style="display: none;">
              <label for="department">Department *</label>
              <select id="department" name="department">
                <option value="" disabled selected>Select department</option>
                <option value="Computer Science">Computer Science</option>
                <option value="Electrical Engineering">Electrical Engineering</option>
                <option value="Mechanical Engineering">Mechanical Engineering</option>
                <option value="Civil Engineering">Civil Engineering</option>
                <option value="Physics">Physics</option>
                <option value="Chemistry">Chemistry</option>
                <option value="Mathematics">Mathematics</option>
              </select>
            </div>
          </fieldset>
          <fieldset class="full-width">
            <legend>Evidence (Optional)</legend>
            <div class="form-group">
              <label for="document">Upload Supporting Document</label>
              <input type="file" id="document" name="document" accept=".pdf,.jpg,.jpeg,.png" />
              <small class="helper-text">Accepted formats: PDF, JPG, PNG (max 5MB)</small>
            </div>
          </fieldset>
          <button type="submit" class="submit-btn">Submit</button>
          <button type="button" class="close-btn" onclick="closeForm()">Cancel</button>
        </form>
      </section>
    </main>
  </div>

  <!-- Floating Button -->
  <button class="register-complaint-btn" onclick="openForm()">➕ Register Complaint</button>

  <!-- Inline JavaScript for dynamic form behavior -->
  <script>
    function toggleDepartmentField() {
      const role = document.getElementById('role').value;
      const departmentField = document.getElementById('departmentField');
      if (role === 'HOD') {
        departmentField.style.display = 'block';
        document.getElementById('department').setAttribute('required', 'required');
      } else {
        departmentField.style.display = 'none';
        document.getElementById('department').removeAttribute('required');
      }
    }

    function openForm() {
      document.getElementById('dashboardContent').style.display = 'none';
      document.getElementById('complaintFormSection').style.display = 'block';
    }

    function closeForm() {
      document.getElementById('complaintFormSection').style.display = 'none';
      document.getElementById('dashboardContent').style.display = 'block';
      toggleDepartmentField(); // Reset department field visibility
    }

    function viewComplaint(complaintId) {
      alert('View complaint with ID: ' + complaintId);
    }

    function filterTable(search, status, date) {
      console.log('Filtering with:', search, status, date);
    }
  </script>

  <!-- External JS -->
  <script src="js/us.js"></script>
</body>
</html>
