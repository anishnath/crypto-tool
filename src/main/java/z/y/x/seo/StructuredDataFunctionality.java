package z.y.x.seo;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Servlet proxy for the Structured Data Extract API.
 * Rate-limited: 10 extractions per IP per 10 minutes.
 *
 * POST action=extract  -> POST /api/structured-data/extract
 */
public class StructuredDataFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int EXTRACTS_PER_WINDOW = 10;
    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    private static final int CONNECT_TIMEOUT = 10000;
    private static final int READ_TIMEOUT = 45000; // extraction can take up to 30s

    private Bucket resolveBucket(String ip) {
        if (buckets.size() > MAX_BUCKETS) buckets.clear();
        return buckets.computeIfAbsent(ip, k ->
            Bucket.builder()
                .addLimit(Bandwidth.classic(EXTRACTS_PER_WINDOW,
                    Refill.intervally(EXTRACTS_PER_WINDOW, Duration.ofMinutes(10))))
                .build()
        );
    }

    private String getClientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isEmpty()) {
            String ip = xff.split(",")[0].trim();
            if (!ip.isEmpty()) return ip;
        }
        String realIp = req.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isEmpty()) return realIp.trim();
        return req.getRemoteAddr();
    }

    private String getApiBase() {
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        if (!apiBase.endsWith("/")) apiBase += "/";
        return apiBase;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");
        if (!"extract".equals(action)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid action. Use action=extract\"}");
            return;
        }

        String body = readRequestBody(req);
        if (body.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing request body with url field\"}");
            return;
        }

        // Extract and validate URL
        java.util.regex.Matcher m = java.util.regex.Pattern.compile("\"url\"\\s*:\\s*\"([^\"]+)\"").matcher(body);
        if (!m.find()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing url field in request body\"}");
            return;
        }

        String targetUrl = m.group(1);
        try {
            java.net.URL parsed = new java.net.URL(targetUrl);
            String scheme = parsed.getProtocol().toLowerCase();
            String host = parsed.getHost().toLowerCase();
            if (!"http".equals(scheme) && !"https".equals(scheme)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Only http and https URLs are supported\"}");
                return;
            }
            if (host.equals("localhost") || host.equals("127.0.0.1") || host.equals("0.0.0.0") ||
                host.equals("::1") || host.startsWith("192.168.") || host.startsWith("10.") ||
                host.startsWith("172.16.") || host.startsWith("172.17.") || host.startsWith("172.18.") ||
                host.startsWith("172.19.") || host.startsWith("172.2") || host.startsWith("172.30.") ||
                host.startsWith("172.31.") || host.endsWith(".local") || host.endsWith(".internal")) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Cannot test private or local addresses\"}");
                return;
            }
        } catch (java.net.MalformedURLException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid URL format\"}");
            return;
        }

        // Reachability check
        try {
            java.net.URL parsed = new java.net.URL(targetUrl);
            String host = parsed.getHost();
            int port = parsed.getPort() != -1 ? parsed.getPort()
                     : "https".equalsIgnoreCase(parsed.getProtocol()) ? 443 : 80;
            java.net.InetAddress addr = java.net.InetAddress.getByName(host);
            java.net.Socket sock = new java.net.Socket();
            sock.connect(new java.net.InetSocketAddress(addr, port), 5000);
            sock.close();
        } catch (java.net.UnknownHostException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Cannot resolve hostname. Check the URL and try again.\"}");
            return;
        } catch (java.io.IOException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Site is unreachable. Check the URL and try again.\"}");
            return;
        }

        // Rate limit — only after validation passes
        String clientIp = getClientIp(req);
        ConsumptionProbe probe = resolveBucket(clientIp).tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long wait = probe.getNanosToWaitForRefill() / 1_000_000_000;
            resp.setStatus(429);
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in " + wait + " seconds.\"}");
            return;
        }

        // Proxy to backend
        proxyPost(getApiBase() + "api/structured-data/extract", body, resp);
    }

    private void proxyPost(String urlString, String body, HttpServletResponse resp) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            resp.setStatus(status);

            String content = (status >= 200 && status < 300)
                ? readResponse(conn.getInputStream())
                : readResponse(conn.getErrorStream());
            resp.getWriter().write(content);
        } catch (java.net.SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Extraction timed out. The page took too long to load.\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Structured data API unavailable\"}");
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    private String readResponse(java.io.InputStream inputStream) throws IOException {
        if (inputStream == null) return "";
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }
}
