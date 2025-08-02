<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.swara.model.User" %>
<%@ page import="com.swara.model.Complaint" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Swara User Dashboard</title>
  <link rel="stylesheet" href="css/UserSwara.css" />
</head>
<body>
  <header>
    <div class="logo">Swara - User Portal</div>
    <div class="profile">
      <img src="https://via.placeholder.com/40" alt="User Profile" />
      <span>Hello, <%= session.getAttribute("user") != null ? ((User) session.getAttribute("user")).getUsername() : "Guest" %></span>
    </div>
  </header>

  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <ul class="menu">
        <li class="section-title">📥 My Complaints</li>
        <li class="section-title">📍 Track Status</li>
        <li class="section-title">📋 file a case</li>
        <li class="section-title">💬 Chat</li>

        <div class="filters">
          <h3>🔎 Filter Complaints</h3>
          <input type="text" placeholder="Search..." onkeyup="filterTable(this.value)"/>
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

    <!-- Main Content -->
    <main class="dashboard">
      <h1>Welcome to Your Safe Space 💖</h1>

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

      
    </main>
  </div>

  <button class="register-complaint-btn" onclick="window.location.href='complaintForm.jsp'">➕ Register Complaint</button>
<script src="js/userDashboard.js"></script>

</body>
</html>
