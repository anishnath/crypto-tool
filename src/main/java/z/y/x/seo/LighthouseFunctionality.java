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
 * Servlet proxy for Lighthouse API (async since v2).
 * Rate-limited: 3 audits per IP per 10 minutes (Lighthouse runs are expensive — real Chrome).
 *
 * Actions:
 *   POST action=audit               -> POST /api/lighthouse            (enqueue, returns 202 with job_id)
 *   GET  action=job&id=N            -> GET  /api/lighthouse/jobs/{id}  (poll job status)
 *   GET  action=audits              -> GET  /api/lighthouse/audits[?url=&limit=]
 *   GET  action=get&id=N            -> GET  /api/lighthouse/audits/{id}
 */
public class LighthouseFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Rate limit: 3 Lighthouse audits per IP per 10 minutes
    private static final int AUDITS_PER_WINDOW = 3;
    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> auditBuckets = new ConcurrentHashMap<>();

    private static final int CONNECT_TIMEOUT = 10000;
    private static final int READ_TIMEOUT = 20000;

    private Bucket resolveBucket(String ip) {
        if (auditBuckets.size() > MAX_BUCKETS) {
            auditBuckets.clear();
        }
        return auditBuckets.computeIfAbsent(ip, k ->
            Bucket.builder()
                .addLimit(Bandwidth.classic(AUDITS_PER_WINDOW,
                    Refill.intervally(AUDITS_PER_WINDOW, Duration.ofMinutes(10))))
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
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("onecompiler");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }
        return apiBase;
    }

    private String getApiKey() {
        // First try environment variable (more secure)
        String apiKey = System.getenv("ONE_COMPILER_API_KEY");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        // Fallback to property file
        apiKey = LoadPropertyFileFunctionality.getConfigProperty().get("ONE_COMPILER_API_KEY");
        return apiKey != null ? apiKey : "";
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");
        if (!"audit".equals(action)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid action for POST. Use action=audit\"}");
            return;
        }

        // Read request body
        String body = readRequestBody(req);

        if (body.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing request body with url field\"}");
            return;
        }

        // Extract and validate URL from JSON body
        java.util.regex.Matcher urlMatcher = java.util.regex.Pattern.compile("\"url\"\\s*:\\s*\"([^\"]+)\"").matcher(body);
        if (!urlMatcher.find()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing url field in request body\"}");
            return;
        }

        String auditUrl = urlMatcher.group(1);
        try {
            java.net.URL parsed = new java.net.URL(auditUrl);
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
                resp.getWriter().write("{\"error\":\"Cannot audit private or local addresses\"}");
                return;
            }
        } catch (java.net.MalformedURLException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid URL format\"}");
            return;
        }

        // Quick reachability check — DNS resolve + TCP connect (5s timeout)
        // Runs BEFORE rate limiter so bad URLs don't burn tokens
        try {
            java.net.URL parsed = new java.net.URL(auditUrl);
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

        // Rate limit — only consumed after URL is validated and reachable
        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = probe.getNanosToWaitForRefill() / 1_000_000_000;
            resp.setStatus(429);
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Lighthouse audits are expensive — try again in " + waitSeconds + " seconds.\"}");
            return;
        }

        proxyPost(getApiBase() + "api/lighthouse", body, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: action\"}");
            return;
        }

        String apiBase = getApiBase();
        String url;

        switch (action) {
            case "audits":
                // List recent audits, optionally filtered by URL
                url = apiBase + "api/lighthouse/audits";
                String filterUrl = req.getParameter("url");
                String limit = req.getParameter("limit");
                String sep = "?";
                if (filterUrl != null && !filterUrl.trim().isEmpty()) {
                    url += sep + "url=" + java.net.URLEncoder.encode(filterUrl, "UTF-8");
                    sep = "&";
                }
                if (limit != null && limit.matches("\\d+")) {
                    url += sep + "limit=" + limit;
                }
                proxyGet(url, resp);
                return;

            case "get":
                String id = req.getParameter("id");
                if (id == null || !id.matches("\\d+")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing or invalid parameter: id\"}");
                    return;
                }
                url = apiBase + "api/lighthouse/audits/" + id;
                proxyGet(url, resp);
                return;

            case "job":
                String jobId = req.getParameter("id");
                if (jobId == null || !jobId.matches("\\d+")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing or invalid parameter: id\"}");
                    return;
                }
                url = apiBase + "api/lighthouse/jobs/" + jobId;
                proxyGet(url, resp);
                return;

            default:
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Unknown action: " + action + "\"}");
        }
    }

    private void proxyGet(String urlString, HttpServletResponse resp) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setRequestProperty("Accept", "application/json");

            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                conn.setRequestProperty("X-API-Key", apiKey);
            }

            int status = conn.getResponseCode();
            resp.setStatus(status);

            String content;
            if (status >= 200 && status < 300) {
                content = readResponse(conn.getInputStream());
            } else {
                content = readResponse(conn.getErrorStream());
            }
            resp.getWriter().write(content);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Lighthouse API unavailable\"}");
        } finally {
            if (conn != null) conn.disconnect();
        }
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

            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                conn.setRequestProperty("X-API-Key", apiKey);
            }

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = body.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int status = conn.getResponseCode();
            resp.setStatus(status);

            String content;
            if (status >= 200 && status < 300) {
                content = readResponse(conn.getInputStream());
            } else {
                content = readResponse(conn.getErrorStream());
            }
            resp.getWriter().write(content);
        } catch (java.net.SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Lighthouse audit timed out. The page took too long to load.\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Lighthouse API unavailable\"}");
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }

    private String readResponse(java.io.InputStream inputStream) throws IOException {
        if (inputStream == null) return "";
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}
