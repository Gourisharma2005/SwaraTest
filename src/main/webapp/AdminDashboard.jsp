<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swara.dao.ComplaintDAO" %>
<%@ page import="com.swara.model.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Swara</title>
    <link rel="stylesheet" href="css/AdminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2 class="logo">Swara</h2>
                <button class="menu-toggle"><i class="fas fa-bars"></i></button>
            </div>
            <ul>
                <li><a href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="#"><i class="fas fa-file-alt"></i> Complaint Records</a></li>
                <% if ("Director".equalsIgnoreCase((String) session.getAttribute("role"))) { %>
                    <li><a href="#"><i class="fas fa-exclamation-triangle"></i> Escalation Log</a></li>
                <% } %>
                <li><a href="#analytics"><i class="fas fa-chart-line"></i> Analytics</a></li>
                <li><a href="#reports"><i class="fas fa-download"></i> Reports</a></li>
                <% if ("Director".equalsIgnoreCase((String) session.getAttribute("role")) || "NGO".equalsIgnoreCase((String) session.getAttribute("role"))) { %>
                    <li><a href="#ngo-interface"><i class="fas fa-users"></i> NGO Interface</a></li>
                <% } %>
                <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </aside>
        <main class="main-content">
            <header>
                <h1>Welcome, <%= session.getAttribute("role") %> | <span class="status-online">Online</span></h1>
                <div class="notification-panel">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                    <div class="notification-dropdown">
                        <p>New complaint from #A1023</p>
                        <p>Priority case escalated</p>
                        <p>Resolution updated for #A1045</p>
                    </div>
                </div>
            </header>
            <div class="metrics-grid">
                <%
                    ComplaintDAO complaintDAO = new ComplaintDAO();
                    List<Complaint> allComplaints = complaintDAO.getAllComplaints();
                    List<Complaint> complaints;
                    if ("Hod".equalsIgnoreCase((String) session.getAttribute("role"))) {
                        String department = (String) session.getAttribute("department");
                        complaints = complaintDAO.getComplaintsByDepartment(department);
                    } else {
                        complaints = allComplaints;
                    }
                    int total = complaints.size();
                    int pending = (int) complaints.stream().filter(c -> "Pending".equals(c.getStatus())).count();
                    int resolved = (int) complaints.stream().filter(c -> "Resolved".equals(c.getStatus())).count();
                    int priority = (int) complaints.stream().filter(c -> "Priority".equals(c.getStatus())).count();
                    double pendingPercentage = total > 0 ? (pending * 100.0) / total : 0;
                    // Simple analytics: department-wise complaint count (for Director only)
                    java.util.Map<String, Long> deptComplaints = allComplaints.stream()
                            .collect(Collectors.groupingBy(c -> c.getLicensee(), Collectors.counting()));
                    String maxDept = deptComplaints.entrySet().stream().max(java.util.Map.Entry.comparingByValue()).map(e -> e.getKey()).orElse("N/A");
                    long maxDeptCount = deptComplaints.getOrDefault(maxDept, 0L);
                %>
                <div class="metric-card">Total: <span><%= total %></span></div>
                <div class="metric-card pending">
                    Pending: <span><%= pending %></span>
                    <div class="progress-bar" style="width: <%= pendingPercentage %>%"></div>
                </div>
                <div class="metric-card resolved">Resolved: <span><%= resolved %></span></div>
                <div class="metric-card priority">Priority: <span><%= priority %></span></div>
            </div>
            <div class="complaint-section" id="complaint-section">
                <div class="filter-bar">
                    <select id="statusFilter" onchange="filterComplaints()">
                        <option value="">All Statuses</option>
                        <option value="Pending">Pending</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Priority">Priority</option>
                    </select>
                    <select id="deptFilter" onchange="filterComplaints()">
                        <option value="">All Departments</option>
                        <% if ("Director".equalsIgnoreCase((String) session.getAttribute("role"))) { %>
                            <% for (String dept : deptComplaints.keySet()) { %>
                                <option value="<%= dept %>"><%= dept %></option>
                            <% } %>
                        <% } else if ("Hod".equalsIgnoreCase((String) session.getAttribute("role"))) { %>
                            <option value="<%= session.getAttribute("department") %>"><%= session.getAttribute("department") %></option>
                        <% } %>
                    </select>
                </div>
                <table class="complaint-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Anonymous ID</th>
                            <th>Complaint</th>
                            <th>Department</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="complaintTableBody">
                        <% for (Complaint c : complaints) { %>
                            <tr>
                                <td><%= c.getId() %></td>
                                <td><%= c.getAnonymousId() %></td>
                                <td><%= c.getComplaintName() %></td>
                                <td><%= c.getLicensee() %></td>
                                <td><%= c.getStatus() %></td>
                                <td><button onclick="openModal(<%= c.getId() %>, '<%= c.getComplaintName() %>', '<%= c.getDescription() %>', '<%= c.getStatus() %>')">View</button></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="analytics-section" id="analytics">
                <h2>AI-Powered Analytics</h2>
                <div class="analytics-grid">
                    <div class="analytic-card">
                        <h3>Most Complaints</h3>
                        <p>Dept: <%= maxDept %> (<%= maxDeptCount %>)</p>
                    </div>
                    <div class="analytic-card">
                        <h3>Fastest Resolution</h3>
                        <p>Dept: N/A (TBD)</p> <!-- Placeholder, requires backend logic -->
                    </div>
                    <div class="analytic-card">
                        <h3>Performance Score</h3>
                        <p>Score: N/A (TBD)</p> <!-- Placeholder, requires ML logic -->
                    </div>
                </div>
            </div>
            <div class="sentiment-section">
                <h2>Sentiment Trend Detection</h2>
                <p>Repeated Issues: N/A (TBD with NLP)</p> <!-- Placeholder for NLP integration -->
                <p>Common Offenders: N/A (TBD with NER)</p> <!-- Placeholder for NLP integration -->
            </div>
            <% if ("Director".equalsIgnoreCase((String) session.getAttribute("role")) || "NGO".equalsIgnoreCase((String) session.getAttribute("role"))) { %>
                <div class="ngo-section" id="ngo-interface">
                    <h2>NGO/Women Officer Interface</h2>
                    <p>Escalated Complaints: <%-- Logic to filter escalated complaints --%></p> <!-- Placeholder, requires backend -->
                    <button onclick="alert('View escalated complaints')">View</button>
                </div>
            <% } %>
            <div class="report-section" id="reports">
                <h2>Report Generation</h2>
                <button onclick="generateReport('weekly')">Weekly Report</button>
                <button onclick="generateReport('monthly')">Monthly Report</button>
            </div>
            <div class="modal" id="complaintModal" style="display:none;">
                <div class="modal-content">
                    <span class="close-modal" onclick="closeModal()">&times;</span>
                    <h2>Complaint Details</h2>
                    <p><strong>ID:</strong> <span id="modalId"></span></p>
                    <p><strong>Title:</strong> <span id="modalTitle"></span></p>
                    <p><strong>Description:</strong> <span id="modalDescription"></span></p>
                    <p><strong>Status:</strong> <span id="modalStatus"></span></p>
                    <button onclick="closeModal()">Close</button>
                </div>
            </div>
            <div class="chat-section">
                <h2>Anonymous Chat System</h2>
                <div class="chat-box" id="chatBox">
                    <p><strong>admin:</strong> Complaint received and marked as pending. <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></p>
                    <p><strong>Anonymous ID #A1023:</strong> I feel unsafe due to repeated harassment in the hostel. <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></p>
                    <p><strong>Anonymous ID #A1045:</strong> Can I know the status of my complaint filed last week? <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></p>
                </div>
                <div class="chat-input">
                    <input type="text" id="chatInput" placeholder="Type a reply or note...">
                    <button onclick="sendMessage()">Send</button>
                </div>
            </div>
        </main>
    </div>
    <script src="js/AdminDashboard.js"></script>
</body>
</html>
