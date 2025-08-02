<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Complaint Page</title>
</head>
<body>
  <div class="login-container">
    <h2>Submit Complaint</h2>
    <% if (request.getAttribute("error") != null) { %>
        <p style="color: red;"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="submitComplaint" method="post" enctype="multipart/form-data">
        <input type="hidden" name="anonymous_id" value="<%= session.getAttribute("anonymous_id") != null ? session.getAttribute("anonymous_id") : "" %>">
        <input type="text" name="subject" placeholder="Subject" required><br>
        <textarea name="description" placeholder="Description" required></textarea><br>
        <input type="file" name="evidence" accept="application/pdf,image/*"><br>
        <button type="submit">Submit Complaint</button>
    </form>
  </div>
</body>
</html>
