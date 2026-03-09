package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;
import com.latexeditor.web.model.CompileResponse;
import com.latexeditor.web.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

/**
 * POST /tikz-compile
 * Proxies TikZ compilation requests to the Go API (POST /api/latex/tikz/compile).
 * Accepts JSON: {"raw": "\\usetikzlibrary{...}\\begin{tikzpicture}...\\end{tikzpicture}"}
 * Returns: {"jobId": "..."}
 */
public class TikzCompileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        String body = sb.toString().trim();

        if (body.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Empty request body\"}");
            return;
        }

        // Extract "raw" field from JSON
        String raw = null;
        try {
            java.util.Map map = JsonUtil.fromJson(body, java.util.Map.class);
            if (map != null && map.get("raw") != null) {
                raw = map.get("raw").toString();
            }
        } catch (Exception e) {
            // Not JSON — treat entire body as raw TikZ
            raw = body;
        }

        if (raw == null || raw.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing 'raw' field\"}");
            return;
        }

        try {
            ApiClient client = new ApiClient();
            CompileResponse result = client.compileTikz(raw);
            resp.getWriter().write(JsonUtil.toJson(result));
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Compilation service unavailable\"}");
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Compilation timed out\"}");
        } catch (ApiException e) {
            resp.setStatus(502);
            resp.getWriter().write("{\"error\":" + JsonUtil.toJson(e.getMessage()) + "}");
        }
    }
}
