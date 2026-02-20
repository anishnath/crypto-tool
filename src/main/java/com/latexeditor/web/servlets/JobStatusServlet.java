package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;
import com.latexeditor.web.model.JobStatus;
import com.latexeditor.web.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * GET /jobs/{jobId}/status
 * Proxies job status request to Go API.
 */
public class JobStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UUID_PATTERN = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String jobId = extractJobId(req);
        if (jobId == null || !jobId.matches(UUID_PATTERN)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid or missing job ID\"}");
            return;
        }

        try {
            ApiClient client = new ApiClient();
            JobStatus status = client.getJobStatus(jobId);
            resp.getWriter().write(JsonUtil.toJson(status));
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Compilation service unavailable\"}");
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Request timed out\"}");
        } catch (ApiException e) {
            resp.setStatus(502);
            resp.getWriter().write("{\"error\":" + JsonUtil.toJson(e.getMessage()) + "}");
        }
    }

    private String extractJobId(HttpServletRequest req) {
        // pathInfo: /{jobId}/status
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() < 2) return null;
        String[] parts = pathInfo.substring(1).split("/");
        return parts.length > 0 ? parts[0] : null;
    }
}
