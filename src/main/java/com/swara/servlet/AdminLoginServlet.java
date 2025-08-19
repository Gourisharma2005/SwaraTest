package com.swara.servlet;

import com.swara.dao.AdminDAO;
import com.swara.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.getAdminByEmail(email);

        if (admin != null && admin.getPassword().equals(password) && admin.getRole().equalsIgnoreCase(role)) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            session.setAttribute("role", role);

            // Set department for HOD (example value, adjust dynamically if needed)
            if (role.equalsIgnoreCase("Hod")) {
                session.setAttribute("department", "Chemistry"); // Replace with dynamic department from DB
            }
            response.sendRedirect("AdminDashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials or role!");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }
}