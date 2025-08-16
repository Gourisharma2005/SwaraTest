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
            <option value="Unseen">Unseen</option>
            <option value="Pending">Pending</option>
            <option value="In-Progress">In-Progress</option>
            <option value="Transferred to Director">Transferred to Director</option>
            <option value="Transferred to NGO">Transferred to NGO</option>
            <option value="Resolved">Resolved</option>
          </select>
          <input type="date" onchange="filterTable(document.querySelector('.filters input').value, document.querySelector('.filters select').value, this.value)" />
        </div>
        <li class="section-title">⚙️ Settings</li>
        <li class="section-title"><a href="logout">Logout</a></li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
      <%
        String pageAttr = (String) request.getAttribute("page");

        if ("viewComplaint".equals(pageAttr)) {
      %>
          <!-- ✅ Complaint details show here -->
          <jsp:include page="ViewComplaint.jsp" />
      <%
        } else {
      %>
          <!-- ✅ Dashboard Section -->
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

            <!-- Stats -->
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

            <!-- Complaint History Table -->
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
                          String statusEnum = complaint.getStatus().toString();
                          String statusClass = statusEnum.toLowerCase();
                          String statusLabel = statusEnum.substring(0,1).toUpperCase() + statusEnum.substring(1).toLowerCase();
                  %>
                    <tr>
                      <td><%= complaint.getId() %></td>
                      <td><%= complaint.getComplaintName() %></td>
                      <td><span class="status <%= statusClass %>"><%= statusLabel %></span></td>
                      <td>
                        <a href="ViewComplaintServlet?id=<%= complaint.getId() %>">
                          <button type="button">View</button>
                        </a>
                      </td>
                    </tr>
                  <%
                        }
                    }
                  %>
                </tbody>
              </table>
            </section>
          </section>

          <!-- ✅ Complaint Form Section (hidden by default) -->
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
                  <input type="text" id="complaint_name" name="complaint_name" required />
                </div>
              </fieldset>
              <fieldset>
                <legend>Incident Details</legend>
                <div class="form-group">
                  <label for="licensee">Name of Licensee</label>
                  <input type="text" id="licensee" name="licensee" />
                </div>
                <div class="form-group">
                  <label for="location">Place of Incident *</label>
                  <input type="text" id="location" name="location" required />
                </div>
                <div class="form-group">
                  <label for="date">Date of Incident *</label>
                  <input type="date" id="date" name="incident_date"
                    max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required />
                </div>
                <div class="form-group full-width">
                  <label for="description">Description *</label>
                  <textarea id="description" name="description" rows="4" required></textarea>
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
                    <option value="Electrical">Electrical</option>
                    <option value="Mechanical">Mechanical</option>
                  </select>
                </div>
              </fieldset>
              <fieldset>
                <legend>Evidence (Optional)</legend>
                <div class="form-group">
                  <label for="document">Upload Supporting Document</label>
                  <input type="file" id="document" name="document" accept=".pdf,.jpg,.jpeg,.png" />
                </div>
              </fieldset>
              <button type="submit" class="submit-btn">Submit</button>
              <button type="button" class="close-btn" onclick="closeForm()">Cancel</button>
            </form>
          </section>
      <%
        } // end else
      %>
    </main>
  </div>

  <!-- Floating Button -->
  <button class="register-complaint-btn" onclick="openForm()">➕ Register Complaint</button>

  <!-- JS -->
  <script>
    function toggleDepartmentField() {
      const role = document.getElementById('role').value;
      const deptField = document.getElementById('departmentField');
      if (role === 'HOD') {
        deptField.style.display = 'block';
        document.getElementById('department').setAttribute('required', 'required');
      } else {
        deptField.style.display = 'none';
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
    }

    function filterTable(search, status, date) {
      console.log('Filtering with:', search, status, date);
    }
  </script>
</body>
</html>
