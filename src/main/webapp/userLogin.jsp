<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Login - Swara</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
   <div class="login-container">
     <h2>User Login</h2>
     <p>Please enter your credentials</p>
     <% if (request.getAttribute("error") != null) { %>
         <p style="color: red;"><%= request.getAttribute("error") %></p>
     <% } %>
     <form action="userLogin" method="post">
         <input type="text" name="email" placeholder="Enter Email Id" required>
         <input type="password" name="password" placeholder="Enter Password" required>
         <button type="submit">Login</button>
     </form>
     <p style="margin-top: 20px;">
         New user? <a href="userRegister.jsp" style="color: #e91e63; text-decoration: none;">Register here</a>
     </p>
   </div>
</body>
</html>
