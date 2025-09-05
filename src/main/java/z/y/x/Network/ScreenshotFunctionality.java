package z.y.x.Network;

import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Screenshot capture servlet.
 * Proxies requests to the backend API {api}/screenshot or {api}/screenshots
 * Supports single screenshot or batch screenshots via POST requests.
 * Returns upstream JSON as-is, including screenshot data and metadata.
 */
public class ScreenshotFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        // Read the request body
        StringBuilder requestBody = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }
        }

        if (requestBody.length() == 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing request body\"}");
            return;
        }

        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }

        // Determine if this is a single or batch screenshot request
        String requestBodyStr = requestBody.toString();
        String endpoint = requestBodyStr.contains("\"urls\"") ? "screenshots" : "screenshot";
        String url = apiBase + endpoint;

        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("accept", "application/json");
            conn.setDoOutput(true);

            // Write the request body
            try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
                writer.write(requestBodyStr);
                writer.flush();
            }

            int status = conn.getResponseCode();
            resp.setStatus(status);

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    (status >= 200 && status < 400) ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8
            ));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
            resp.getWriter().write(content.toString());

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Upstream request failed: " + e.getMessage() + "\"}");
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}
