<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration - Swara</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
   <div class="login-container">
     <h2>User Registration</h2>
     <% if (request.getAttribute("error") != null) { %>
         <p style="color: red;"><%= request.getAttribute("error") %></p>
     <% } %>
     <form action="userRegister" method="post">
         <input type="text" name="username" placeholder="Enter Username" required>
         <input type="password" name="password" placeholder="Enter Password" required>
         <input type="email" name="email" placeholder="Enter Email" required>
         <input type="tel" name="phone" placeholder="Enter Phone Number" required>
         <button type="submit">Register</button>
     </form>
     <p>Already have an account? <a href="userLogin.jsp">Login</a></p>
   </div>
</body>
</html>
