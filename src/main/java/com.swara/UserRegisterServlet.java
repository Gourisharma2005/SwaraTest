package com.swara;

import com.swara.dao.UserDAO;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;


public class UserRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Generate unique ID (simple logic — change if needed)
        String uniqueId = "UID" + System.currentTimeMillis();

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(username, password, uniqueId, email, phone);

        if (success) {
            res.getWriter().println("Registration successful. Your Unique ID is: " + uniqueId);
            // Optionally: redirect to login
            // res.sendRedirect("userLogin.jsp");
        } else {
            res.getWriter().println("Error: User already exists or DB error.");
        }
    }
}
