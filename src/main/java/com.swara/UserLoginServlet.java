package com.swara;

import com.swara.dao.UserDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UserLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        System.out.println("Received username: " + username);
        System.out.println("Received password: " + password); // Don't do this in production, just for debugging

        UserDAO dao = new UserDAO();
        if (dao.validate(username, password)) {
            String uniqueId = dao.getUniqueId(username);
            req.getSession().setAttribute("uniqueId", uniqueId);
            res.sendRedirect("complaintForm.jsp");
        } else {
            res.getWriter().println("Invalid user credentials");
        }
    }

}
