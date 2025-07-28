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
      <span>Hello, Priya</span>
    </div>
  </header>

  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <ul class="menu">


          <ul class="menu">
            <li class="section-title">📥 My Complaints</li>
            <li class="section-title">📍 Track Status</li>
            <li class="section-title">📋 file a case</li>
            <li class="section-title">💬 Chat</li>

            <div class="filters">
                <h3>🔎 Filter Complaints</h3>
                <input type="text" placeholder="Search..."/>
                <select>
                  <option>Status</option>
                  <option>Pending</option>
                  <option>Resolved</option>
                </select>
                <input type="date" />
              </div>
              <li class="section-title">⚙️ Settings</li>
              <li class="section-title">Logout</li>
      </ul>
    </aside>



    <!-- Main Content -->
    <main class="dashboard">
      <h1>Welcome to Your Safe Space 💖</h1>

      <section class="stats">
        <div class="card">
          <h2>3</h2>
          <p>Active Complaints</p>
        </div>
        <div class="card">
          <h2>1</h2>
          <p>Resolved</p>
        </div>
        <div class="card">
          <h2>0</h2>
          <p>Escalated</p>
        </div>
      </section>

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
    </main>
  </div>
  <button class="register-complaint-btn">➕Register Complaint</button>

</body>
</html>
