package com.swara;

import com.swara.dao.AdminDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        AdminDAO dao = new AdminDAO();
        if (dao.validate(username, password, role)) {
            res.getWriter().println(role + " Login Successful");
        } else {
            res.getWriter().println("Invalid admin credentials");
        }
    }
}
