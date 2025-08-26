package z.y.x.Network;

import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Reverse DNS / PTR lookup servlet.
 * Proxies requests to the backend API {api}/revdns/{ip_list}
 * Supports single IP or comma-separated IPs via query parameter 'ip'.
 * Returns upstream JSON as-is, including per-IP error details and durations.
 */
public class RevDnsFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String ipParam = req.getParameter("ip");
        if (ipParam == null || ipParam.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: ip\"}");
            return;
        }

        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }

        // Allow comma-separated multiple IPs; encode entire segment safely
        String encodedIpSegment = URLEncoder.encode(ipParam.trim(), StandardCharsets.UTF_8.name());
        String url = apiBase + "revdns/" + encodedIpSegment;

        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("accept", "application/json");

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
            resp.getWriter().write("{\"error\":\"Upstream request failed\"}");
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}


