package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

/**
 * GET /logs/{jobId}
 * Proxies SSE stream from Go API to browser.
 */
public class LogProxyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UUID_PATTERN = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = extractJobId(req);
        if (jobId == null || !jobId.matches(UUID_PATTERN)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"Invalid or missing job ID\"}");
            return;
        }

        resp.setContentType("text/event-stream");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Connection", "keep-alive");
        resp.setHeader("X-Accel-Buffering", "no");
        resp.flushBuffer();

        InputStream sseStream = null;
        try {
            ApiClient client = new ApiClient();
            sseStream = client.getLogStream(jobId);

            BufferedReader reader = new BufferedReader(new InputStreamReader(sseStream));
            PrintWriter writer = resp.getWriter();
            String line;

            while ((line = reader.readLine()) != null) {
                writer.println(line);
                writer.flush();

                if (writer.checkError()) {
                    break; // client disconnected
                }
            }
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
        } catch (ApiException e) {
            resp.setStatus(502);
        } finally {
            if (sseStream != null) {
                try { sseStream.close(); } catch (IOException ignored) {}
            }
        }
    }

    private String extractJobId(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() < 2) return null;
        return pathInfo.substring(1); // strip leading /
    }
}
