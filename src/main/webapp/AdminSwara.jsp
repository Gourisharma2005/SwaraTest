<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Swara Admin Panel</title>
  <link rel="stylesheet" href="css/AdminSwara.css" />
</head>
<body>
  <header>
    <div class="logo">🌸 Swara Admin Panel</div>
    <div class="profile">
      <img src="https://via.placeholder.com/40" alt="Admin Profile" />
      <span>Welcome, <%= session.getAttribute("admin") != null ? ((Admin) session.getAttribute("admin")).getUsername() : "Admin" %></span>
    </div>
  </header>

  <div class="container">
    <aside class="sidebar">
      <ul class="menu">
        <li class="section-title">📥 Dashboard</li>
        <li>All Complaints</li>
        <li>New Submissions</li>
        <li>Priority Cases</li>
        <li>Anonymous Complaints</li>

        <li class="section-title">🛠️ Complaint Tools</li>
        <li>Assign Investigator</li>
        <li>Update Status</li>
        <li>Upload Notes</li>
        <li>View Evidence</li>
        <li>Generate Reports</li>

        <li class="section-title">👥 User Management</li>
        <li>View Profiles</li>
        <li>Message Users</li>
        <li>Flag Account</li>
        <li>Block Account</li>

        <li class="section-title">📊 Logs & Reports</li>
        <li>Complaint Logs</li>
        <li>Escalation History</li>
        <li>Download Logs</li>
        <li>Audit Trail</li>

        <li class="section-title">🧑‍⚕️ Support Tools</li>
        <li>Assign Counseling</li>
        <li>Schedule Session</li>
        <li>Counseling Records</li>
        <li>Refer Legal Help</li>

        <li class="section-title">🔐 Admin Tools</li>
        <li>Manage Permissions</li>
        <li>Backup Data</li>
        <li>Emergency Lockdown</li>
        <li><a href="logout">Logout</a></li>
      </ul>
    </aside>

    <main class="dashboard">
      <h1>Admin Overview</h1>
      <section class="stats">
        <div class="card">
          <h2><%= session.getAttribute("totalComplaints") != null ? session.getAttribute("totalComplaints") : "0" %></h2>
          <p>Total Complaints</p>
        </div>
        <div class="card">
          <h2><%= session.getAttribute("priorityCases") != null ? session.getAttribute("priorityCases") : "0" %></h2>
          <p>Priority Cases</p>
        </div>
        <div class="card">
          <h2><%= session.getAttribute("pendingReview") != null ? session.getAttribute("pendingReview") : "0" %></h2>
          <p>Pending Review</p>
        </div>
        <div class="card">
          <h2><%= session.getAttribute("escalated") != null ? session.getAttribute("escalated") : "0" %></h2>
          <p>Escalated</p>
        </div>
      </section>

      <section class="recent-activity">
        <h2>📋 Recent Complaints</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>User</th>
              <th>Issue</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (session.getAttribute("recentComplaints") != null) {
                java.util.List<Complaint> complaints = (java.util.List<Complaint>) session.getAttribute("recentComplaints");
                for (Complaint c : complaints) {
            %>
            <tr>
              <td><%= c.getComplaintId() %></td>
              <td><%= c.getAnonymousId() != null ? "Anonymous" : c.getUserName() %></td>
              <td><%= c.getSubject() %></td>
              <td><span class="status <%= c.getStatus().toLowerCase() %>"><%= c.getStatus() %></span></td>
              <td><button onclick="reviewComplaint('<%= c.getComplaintId() %>')">Review</button></td>
            </tr>
            <%
                }
              } else {
            %>
            <tr><td colspan="5">No recent complaints.</td></tr>
            <% } %>
          </tbody>
        </table>
      </section>
    </main>
  </div>

  <script>
    function reviewComplaint(complaintId) {
      alert("Reviewing complaint: " + complaintId);
      // Example: window.location.href = "reviewComplaint.jsp?id=" + complaintId;
    }
  </script>
</body>
</html>