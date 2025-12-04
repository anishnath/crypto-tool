package z.y.x.Network;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet to fetch URL content for HTML to Markdown conversion
 */
public class UrlFetchFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int CONNECT_TIMEOUT = 10000; // 10 seconds
    private static final int READ_TIMEOUT = 30000; // 30 seconds
    private static final int MAX_CONTENT_LENGTH = 5 * 1024 * 1024; // 5MB max

    public UrlFetchFunctionality() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Add CORS headers for same-origin requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();
        Gson gson = new Gson();

        try {
            String urlParam = request.getParameter("url");

            if (urlParam == null || urlParam.trim().isEmpty()) {
                result.addProperty("success", false);
                result.addProperty("error", "URL parameter is required");
                out.println(gson.toJson(result));
                return;
            }

            urlParam = urlParam.trim();

            // Validate URL
            URL url;
            try {
                url = new URL(urlParam);
                String protocol = url.getProtocol().toLowerCase();
                if (!protocol.equals("http") && !protocol.equals("https")) {
                    throw new IllegalArgumentException("Only HTTP and HTTPS protocols are allowed");
                }
            } catch (Exception e) {
                result.addProperty("success", false);
                result.addProperty("error", "Invalid URL: " + e.getMessage());
                out.println(gson.toJson(result));
                return;
            }

            // Fetch the URL content
            HttpURLConnection connection = null;
            try {
                connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(CONNECT_TIMEOUT);
                connection.setReadTimeout(READ_TIMEOUT);
                connection.setInstanceFollowRedirects(true);

                // Set a realistic User-Agent
                connection.setRequestProperty("User-Agent",
                    "Mozilla/5.0 (compatible; 8gwifi.org URL Fetcher)");
                connection.setRequestProperty("Accept",
                    "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
                connection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

                int responseCode = connection.getResponseCode();

                if (responseCode != HttpURLConnection.HTTP_OK) {
                    result.addProperty("success", false);
                    result.addProperty("error", "HTTP Error: " + responseCode + " " + connection.getResponseMessage());
                    out.println(gson.toJson(result));
                    return;
                }

                // Check content length
                int contentLength = connection.getContentLength();
                if (contentLength > MAX_CONTENT_LENGTH) {
                    result.addProperty("success", false);
                    result.addProperty("error", "Content too large (max 5MB)");
                    out.println(gson.toJson(result));
                    return;
                }

                // Get content type and encoding
                String contentType = connection.getContentType();
                String charset = "UTF-8";
                if (contentType != null && contentType.contains("charset=")) {
                    int idx = contentType.indexOf("charset=");
                    charset = contentType.substring(idx + 8).split(";")[0].trim();
                }

                // Read the content
                StringBuilder content = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), charset))) {
                    String line;
                    int totalRead = 0;
                    while ((line = reader.readLine()) != null) {
                        content.append(line).append("\n");
                        totalRead += line.length();
                        if (totalRead > MAX_CONTENT_LENGTH) {
                            result.addProperty("success", false);
                            result.addProperty("error", "Content too large (max 5MB)");
                            out.println(gson.toJson(result));
                            return;
                        }
                    }
                }

                // Success response
                result.addProperty("success", true);
                result.addProperty("contents", content.toString());
                result.addProperty("url", urlParam);
                result.addProperty("contentType", contentType);
                result.addProperty("length", content.length());

            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }

        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("error", "Error fetching URL: " + e.getMessage());
        }

        out.println(gson.toJson(result));
    }
}
