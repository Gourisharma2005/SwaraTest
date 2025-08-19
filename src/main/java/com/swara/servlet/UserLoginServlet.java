package com.swara.servlet;

import com.swara.dao.UserDAO;
import com.swara.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class UserLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("anonymous_id", user.getAnonymousId());
            response.sendRedirect("SwaraUser.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials!");
            request.getRequestDispatcher("userLogin.jsp").forward(request, response);
        }
    }
}
