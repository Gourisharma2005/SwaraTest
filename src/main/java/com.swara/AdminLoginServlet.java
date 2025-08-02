package com.swara;

import com.swara.dao.AdminDAO;
import java.io.IOException;

import com.swara.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.getAdminByUsername(username);

        if (admin != null && admin.getPassword().equals(password) && admin.getRole().equals(role)) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            response.sendRedirect("AdminSwara.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials or role!");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }
}