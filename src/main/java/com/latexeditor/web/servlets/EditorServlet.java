package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClientConfig;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EditorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String projectId = req.getParameter("projectId");
        if (projectId == null) {
            projectId = "";
        }

        req.setAttribute("apiBase", ApiClientConfig.getApiBaseUrl());
        req.setAttribute("projectId", projectId);

        req.getRequestDispatcher("/latex/editor.jsp").forward(req, resp);
    }
}
