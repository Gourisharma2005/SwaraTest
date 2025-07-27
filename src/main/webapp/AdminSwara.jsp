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
      <span>Welcome, Admin</span>
    </div>
  </header>

  <div class="container">
    <!-- Sidebar -->
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
        <li>Logout</li>
      </ul>
    </aside>

    <!-- Main Section -->
    <main class="dashboard">
      <h1>Admin Overview</h1>
      <section class="stats">
        <div class="card">
          <h2>134</h2>
          <p>Total Complaints</p>
        </div>
        <div class="card">
          <h2>26</h2>
          <p>Priority Cases</p>
        </div>
        <div class="card">
          <h2>12</h2>
          <p>Pending Review</p>
        </div>
        <div class="card">
          <h2>8</h2>
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
            <tr>
              <td>#A102</td>
              <td>Ananya S.</td>
              <td>Harassment in Hostel</td>
              <td><span class="status pending">Pending</span></td>
              <td><button>Review</button></td>
            </tr>
            <tr>
              <td>#A099</td>
              <td>Anonymous</td>
              <td>Stalking on Campus</td>
              <td><span class="status urgent">Urgent</span></td>
              <td><button>Investigate</button></td>
            </tr>
          </tbody>
        </table>
      </section>
    </main>
  </div>
</body>
</html>
