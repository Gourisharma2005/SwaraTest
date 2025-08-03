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
  <link rel="stylesheet" href="css/SwaraUser.css" />
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

        <!-- Static Complaint History Table (you can make this dynamic later) -->
        <section class="complaint-history">
          <h2>📋 My Complaint</h2>
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
              <tr>
                <td>#C101</td>
                <td>Harassment in Lab</td>
                <td><span class="status pending">Pending</span></td>
                <td><button>View</button></td>
              </tr>
              <tr>
                <td>#C098</td>
                <td>Comments in Corridor</td>
                <td><span class="status resolved">Resolved</span></td>
                <td><button>Download</button></td>
              </tr>
            </tbody>
          </table>
        </section>
      </section>

      <!-- Complaint Form Section (Hidden by Default) -->
      <section class="form-section" id="complaintFormSection" style="display: none;">
        <h1>Submit a Complaint</h1>

        <form class="complaint-form" novalidate>
          <fieldset>
            <legend>Personal Details</legend>
            <div class="form-group">
              <label for="name">Complainant Name *</label>
              <input type="text" id="name" name="name" required placeholder="Your full name" autocomplete="name" />
            </div>

            <div class="form-group">
              <label for="phone">Phone Number *</label>
              <input type="tel" id="phone" name="phone" required placeholder="10-digit mobile number"
                     pattern="[0-9]{10}" maxlength="10" autocomplete="tel" />
              <small class="helper-text">Enter a valid 10-digit number</small>
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

  <!-- JS -->
  <script src="css/us.js"></script>
</body>
</html>
