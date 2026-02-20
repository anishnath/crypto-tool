package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;
import org.apache.http.HttpResponse;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * GET /pdf/{jobId}
 * Streams compiled PDF from Go API to browser.
 */
public class PDFProxyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UUID_PATTERN = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$";
    private static final int BUFFER_SIZE = 8192;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = extractJobId(req);
        if (jobId == null || !jobId.matches(UUID_PATTERN)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"Invalid or missing job ID\"}");
            return;
        }

        try {
            ApiClient client = new ApiClient();
            HttpResponse apiResp = client.getPDFResponse(jobId);

            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", "inline; filename=document.pdf");

            if (apiResp.getEntity().getContentLength() > 0) {
                resp.setHeader("Content-Length", String.valueOf(apiResp.getEntity().getContentLength()));
            }

            InputStream in = apiResp.getEntity().getContent();
            OutputStream out = resp.getOutputStream();
            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
            in.close();
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"Compilation service unavailable\"}");
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"Request timed out\"}");
        } catch (ApiException e) {
            resp.setStatus(502);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":" + "\"" + e.getMessage() + "\"}");
        }
    }

    private String extractJobId(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() < 2) return null;
        return pathInfo.substring(1);
    }
}
