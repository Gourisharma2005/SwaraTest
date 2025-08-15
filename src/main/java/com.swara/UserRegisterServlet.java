package com.swara;

import com.swara.dao.UserDAO;
import java.io.IOException;

import com.swara.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.UUID;

public class UserRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        String anonymousId = "UNQ_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String hashedPassword = password;

        User user = new User(username, hashedPassword, anonymousId, email, phone);
        UserDAO userDAO = new UserDAO();

        if (userDAO.addUser(user)) {
            response.sendRedirect("userLogin.jsp");
        } else {
            request.setAttribute("error", "Registration failed!");
            request.getRequestDispatcher("userRegister.jsp").forward(request, response);
        }
    }
}