package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Servlet to check security headers for a given URL.
 * Accepts query parameter "url" and returns security headers in JSON format.
 */
public class SecurityHeadersFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setHeader("Access-Control-Allow-Origin", "*");

        String targetUrl = req.getParameter("url");

        if (targetUrl == null || targetUrl.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Missing required parameter: url");
            resp.getWriter().write(new Gson().toJson(error));
            return;
        }

        // Validate URL format
        try {
            URL url = new URL(targetUrl);
            if (!url.getProtocol().equals("http") && !url.getProtocol().equals("https")) {
                throw new MalformedURLException("Only HTTP and HTTPS protocols are supported");
            }
        } catch (MalformedURLException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Invalid URL format: " + e.getMessage());
            resp.getWriter().write(new Gson().toJson(error));
            return;
        }

        // Configure HTTP client with timeouts
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(10000)
                .setSocketTimeout(10000)
                .setConnectionRequestTimeout(10000)
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setDefaultRequestConfig(requestConfig)
                .build();

        try {
            HttpHead headRequest = new HttpHead(targetUrl);
            headRequest.addHeader("User-Agent", "Mozilla/5.0 (Security Headers Checker)");

            HttpResponse response = httpClient.execute(headRequest);

            // Get final URL after redirects
            String finalUrl = headRequest.getURI().toString();

            // Extract all headers
            JsonObject headers = new JsonObject();
            for (Header header : response.getAllHeaders()) {
                String headerName = header.getName().toLowerCase();
                // Only include security-related headers
                if (isSecurityHeader(headerName)) {
                    String headerValue = header.getValue();
                    // Only add if value is not null or empty
                    if (headerValue != null && !headerValue.trim().isEmpty()) {
                        headers.addProperty(headerName, headerValue.trim());
                    }
                }
            }

            JsonObject result = new JsonObject();
            result.addProperty("url", targetUrl);
            result.addProperty("finalUrl", finalUrl);
            result.addProperty("redirected", !targetUrl.equals(finalUrl));
            result.addProperty("status", response.getStatusLine().getStatusCode());
            result.add("headers", headers);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(new Gson().toJson(result));

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to fetch headers: " + e.getMessage());
            resp.getWriter().write(new Gson().toJson(error));
        } finally {
            try {
                httpClient.close();
            } catch (IOException e) {
                // Ignore close exceptions
            }
        }
    }

    /**
     * Check if a header is security-related
     */
    private boolean isSecurityHeader(String headerName) {
        return headerName.equals("content-security-policy") ||
               headerName.equals("strict-transport-security") ||
               headerName.equals("x-frame-options") ||
               headerName.equals("x-content-type-options") ||
               headerName.equals("referrer-policy") ||
               headerName.equals("permissions-policy") ||
               headerName.equals("x-xss-protection") ||
               headerName.equals("content-security-policy-report-only") ||
               headerName.equals("expect-ct") ||
               headerName.equals("feature-policy") ||
               headerName.equals("x-permitted-cross-domain-policies") ||
               headerName.equals("cross-origin-embedder-policy") ||
               headerName.equals("cross-origin-opener-policy") ||
               headerName.equals("cross-origin-resource-policy");
    }
}
