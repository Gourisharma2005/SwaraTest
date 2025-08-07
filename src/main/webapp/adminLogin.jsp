<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Swara</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
   <div class="login-container">
     <h2>Admin Login</h2>
     <p>Please enter your credentials</p>

     <% if (request.getAttribute("error") != null) { %>
         <p style="color: red;"><%= request.getAttribute("error") %></p>
     <% } %>

     <form action="adminLogin" method="post">
         <input type="email" name="email" placeholder="Enter Email" required><br>
         <input type="password" name="password" placeholder="Enter Password" required><br>
         <select name="role" required>
             <option value="">Select Role</option>
             <option value="HOD">HOD</option>
             <option value="Director">Director</option>
         </select><br>
         <button type="submit">Login</button>
     </form>
   </div>
</body>
</html>