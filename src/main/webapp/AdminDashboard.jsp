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
                        complaints = allComplaints.stream()
                            .filter(c -> c.getDepartment() != null && c.getDepartment().equals(department))
                            .collect(Collectors.toList());
                    } else {
                        complaints = allComplaints;
                    }
                    int total = complaints.size();
                    int unseen = (int) complaints.stream().filter(c -> "Unseen".equals(c.getStatus())).count();
                    int pending = (int) complaints.stream().filter(c -> "Pending".equals(c.getStatus())).count();
                    int inProgress = (int) complaints.stream().filter(c -> "In-Progress".equals(c.getStatus())).count();
                    int transferredToDirector = (int) complaints.stream().filter(c -> "Transferred to Director".equals(c.getStatus())).count();
                    int transferredToNGO = (int) complaints.stream().filter(c -> "Transferred to NGO".equals(c.getStatus())).count();
                    int resolved = (int) complaints.stream().filter(c -> "Resolved".equals(c.getStatus())).count();
                    double pendingPercentage = total > 0 ? (pending * 100.0) / total : 0;
                    java.util.Map<String, Long> deptComplaints = allComplaints.stream()
                            .collect(Collectors.groupingBy(c -> c.getDepartment() != null ? c.getDepartment() : "N/A", Collectors.counting()));
                    String maxDept = deptComplaints.entrySet().stream().max(java.util.Map.Entry.comparingByValue()).map(e -> e.getKey()).orElse("N/A");
                    long maxDeptCount = deptComplaints.getOrDefault(maxDept, 0L);
                %>
                <div class="metric-card">Total: <span><%= total %></span></div>
                <div class="metric-card pending">
                    Pending: <span><%= pending %></span>
                    <div class="progress-bar" style="width: <%= pendingPercentage %>%"></div>
                </div>
                <div class="metric-card">Unseen: <span><%= unseen %></span></div>
                <div class="metric-card">In-Progress: <span><%= inProgress %></span></div>
                <div class="metric-card">To Director: <span><%= transferredToDirector %></span></div>
                <div class="metric-card">To NGO: <span><%= transferredToNGO %></span></div>
                <div class="metric-card resolved">Resolved: <span><%= resolved %></span></div>
            </div>
            <div class="complaint-section" id="complaint-section">
                <div class="filter-bar">
                    <select id="statusFilter" onchange="filterComplaints()">
                        <option value="">All Statuses</option>
                        <option value="Unseen">Unseen</option>
                        <option value="Pending">Pending</option>
                        <option value="In-Progress">In-Progress</option>
                        <option value="Transferred to Director">Transferred to Director</option>
                        <option value="Transferred to NGO">Transferred to NGO</option>
                        <option value="Resolved">Resolved</option>
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
                                <td><%= c.getDepartment() != null ? c.getDepartment() : "N/A" %></td>
                                <td><%= c.getStatus() %></td>
                                <td>
                                    <form action="UpdateStatusServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="anonymous_id" value="<%= c.getAnonymousId() %>">
                                        <input type="hidden" name="status" value="Pending">
                                        <button type="submit" <%= !"Unseen".equals(c.getStatus()) ? "disabled" : "" %>>Mark Pending</button>
                                    </form>
                                    <form action="UpdateStatusServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="anonymous_id" value="<%= c.getAnonymousId() %>">
                                        <input type="hidden" name="status" value="In-Progress">
                                        <button type="submit" <%= !"Pending".equals(c.getStatus()) ? "disabled" : "" %>>Mark In-Progress</button>
                                    </form>
                                    <form action="UpdateStatusServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="anonymous_id" value="<%= c.getAnonymousId() %>">
                                        <input type="hidden" name="status" value="Resolved">
                                        <button type="submit" <%= !("In-Progress".equals(c.getStatus()) || "Transferred to Director".equals(c.getStatus()) || "Transferred to NGO".equals(c.getStatus())) ? "disabled" : "" %>>Resolve</button>
                                    </form>
                                    <button onclick="openModal('<%= c.getId() %>', '<%= c.getComplaintName() %>', '<%= c.getDescription() %>', '<%= c.getStatus() %>')">View</button>
                                </td>
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
                    <p>Escalated Complaints: <%
                        int escalated = (int) allComplaints.stream()
                            .filter(c -> "Transferred to Director".equals(c.getStatus()) || "Transferred to NGO".equals(c.getStatus()))
                            .count();
                    %><%= escalated %></p>
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
                <h2>Anonymous Chat System <i class="fa fa-comments"></i></h2>
                <div class="chat-box" id="chatBox">
                    <!-- Messages will be appended here dynamically -->
                </div>
                <div class="chat-input">
                    <input type="text" id="chatInput" placeholder="Type a reply or note...">
                    <button onclick="sendMessage()">Send</button>
                </div>
            </div>
        </main>
    </div>
    <script src="js/AdminDashboard.js"></script>
    <script src="js/chat.js"></script>
    <script>
        const adminName = "<%= session.getAttribute("role") != null ? session.getAttribute("role") : "Admin" %>";
        initChat(adminName);
    </script>

</body>
</html>