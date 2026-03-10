package com.pastebin.web.servlets;

import com.latexeditor.web.client.ApiClientConfig;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.SocketTimeoutException;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Generic proxy servlet for the Pastebin backend API.
 *
 * Mapped to /api/pastebin/* — forwards all requests to the backend
 * API server configured via the "api" property in 8gwifi.prop.
 *
 * Proxied endpoints:
 *   POST   /api/pastebin           → create paste (JSON or multipart)
 *   POST   /api/pastebin/keys      → generate API key
 *   GET    /api/pastebin/{id}      → get paste
 *   GET    /api/pastebin/{id}/raw  → get raw paste content
 *   GET    /api/pastebin/mine      → list my pastes
 *   GET    /api/pastebin/stats     → public stats
 *   GET    /api/pastebin/health    → health check
 *   DELETE /api/pastebin/{id}      → delete paste
 */
public class PastebinProxyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int CONNECT_TIMEOUT = 5000;
    private static final int READ_TIMEOUT = 30000;

    // ── Rate limiting ──
    // Writes (POST create/delete): 30 per minute, burst of 5
    private static final int WRITES_PER_MINUTE = 30;
    private static final int WRITE_BURST = 5;
    // Reads (GET): 60 per minute, burst of 10
    private static final int READS_PER_MINUTE = 60;
    private static final int READ_BURST = 10;

    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> writeBuckets = new ConcurrentHashMap<>();
    private static final Map<String, Bucket> readBuckets = new ConcurrentHashMap<>();

    private Bucket resolveWriteBucket(String ip) {
        if (writeBuckets.size() > MAX_BUCKETS) writeBuckets.clear();
        return writeBuckets.computeIfAbsent(ip, k -> Bucket.builder()
                .addLimit(Bandwidth.classic(WRITES_PER_MINUTE, Refill.greedy(WRITES_PER_MINUTE, Duration.ofMinutes(1))))
                .addLimit(Bandwidth.classic(WRITE_BURST, Refill.intervally(WRITE_BURST, Duration.ofSeconds(10))))
                .build());
    }

    private Bucket resolveReadBucket(String ip) {
        if (readBuckets.size() > MAX_BUCKETS) readBuckets.clear();
        return readBuckets.computeIfAbsent(ip, k -> Bucket.builder()
                .addLimit(Bandwidth.classic(READS_PER_MINUTE, Refill.greedy(READS_PER_MINUTE, Duration.ofMinutes(1))))
                .addLimit(Bandwidth.classic(READ_BURST, Refill.intervally(READ_BURST, Duration.ofSeconds(10))))
                .build());
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

    /**
     * Check rate limit and write 429 if exceeded. Returns true if allowed.
     */
    private boolean checkRateLimit(HttpServletRequest req, HttpServletResponse resp, boolean isWrite) throws IOException {
        String ip = getClientIp(req);
        Bucket bucket = isWrite ? resolveWriteBucket(ip) : resolveReadBucket(ip);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            sendError(resp, 429, "RATE_LIMITED",
                    "Too many requests. Try again in " + waitSeconds + " seconds.");
            return false;
        }
        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));
        return true;
    }

    // Headers to forward from the client request to the backend
    private static final String[] FORWARD_HEADERS = {
        "X-API-Key", "X-Delete-Token", "Content-Type"
    };

    // Headers to copy back from backend response to client
    private static final String[] RESPONSE_HEADERS = {
        "Content-Type", "Content-Disposition", "X-RateLimit-Remaining", "Retry-After"
    };

    private String getBackendUrl() {
        return ApiClientConfig.getApiBaseUrl();
    }

    private RequestConfig defaultConfig() {
        return RequestConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT)
                .setSocketTimeout(READ_TIMEOUT)
                .build();
    }

    /**
     * Extract the path portion after /api/pastebin.
     * e.g. /api/pastebin/abc123/raw → /abc123/raw
     */
    private String getSubPath(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return (pathInfo != null) ? pathInfo : "";
    }

    /**
     * Build the full backend URL including query string.
     */
    private String buildBackendUrl(HttpServletRequest req) {
        String sub = getSubPath(req);
        String backendUrl = getBackendUrl() + "/api/pastebin" + sub;
        String qs = req.getQueryString();
        if (qs != null && !qs.isEmpty()) {
            backendUrl += "?" + qs;
        }
        return backendUrl;
    }

    // ── GET ──
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkRateLimit(req, resp, false)) return;

        String url = buildBackendUrl(req);

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpGet get = new HttpGet(url);
            get.setConfig(defaultConfig());
            copyRequestHeaders(req, get);

            HttpResponse backendResp = executeWithErrorHandling(client, resp, get);
            if (backendResp == null) return; // error already written

            streamResponse(backendResp, resp);
        } finally {
            client.close();
        }
    }

    // ── POST ──
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkRateLimit(req, resp, true)) return;

        String url = buildBackendUrl(req);

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(url);
            post.setConfig(defaultConfig());
            copyRequestHeaders(req, post);

            // Forward the request body as-is (JSON or multipart)
            String contentType = req.getContentType();
            if (contentType != null && contentType.contains("multipart/form-data")) {
                // Stream multipart body directly
                long contentLength = req.getContentLength();
                InputStreamEntity entity = new InputStreamEntity(
                    req.getInputStream(), contentLength,
                    ContentType.parse(contentType)
                );
                post.setEntity(entity);
            } else {
                // Read text body (JSON)
                String body = readRequestBody(req);
                if (body != null && !body.isEmpty()) {
                    post.setEntity(new StringEntity(body, ContentType.APPLICATION_JSON));
                }
            }

            HttpResponse backendResp = executeWithErrorHandling(client, resp, post);
            if (backendResp == null) return;

            streamResponse(backendResp, resp);
        } finally {
            client.close();
        }
    }

    // ── DELETE ──
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkRateLimit(req, resp, true)) return;

        String url = buildBackendUrl(req);

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpDelete delete = new HttpDelete(url);
            delete.setConfig(defaultConfig());
            copyRequestHeaders(req, delete);

            HttpResponse backendResp = executeWithErrorHandling(client, resp, delete);
            if (backendResp == null) return;

            streamResponse(backendResp, resp);
        } finally {
            client.close();
        }
    }

    // ── Helpers ──

    /**
     * Copy relevant headers from client request to backend request.
     */
    private void copyRequestHeaders(HttpServletRequest req, HttpUriRequest backendReq) {
        for (String header : FORWARD_HEADERS) {
            String value = req.getHeader(header);
            if (value != null) {
                // Don't forward Content-Type for GET/DELETE (already set or not needed)
                if ("Content-Type".equals(header) && !(backendReq instanceof HttpPost)) continue;
                backendReq.setHeader(header, value);
            }
        }
        // Forward cookies for session-based auth
        String cookie = req.getHeader("Cookie");
        if (cookie != null) {
            backendReq.setHeader("Cookie", cookie);
        }
    }

    /**
     * Execute the request, handling connection errors.
     * Returns null if an error response was already written.
     */
    private HttpResponse executeWithErrorHandling(CloseableHttpClient client, HttpServletResponse resp, HttpUriRequest request) throws IOException {
        try {
            return client.execute(request);
        } catch (HttpHostConnectException e) {
            sendError(resp, 503, "SERVICE_UNAVAILABLE", "Pastebin service unavailable");
            return null;
        } catch (ConnectTimeoutException | SocketTimeoutException e) {
            sendError(resp, 504, "TIMEOUT", "Pastebin service timed out");
            return null;
        }
    }

    /**
     * Stream the backend response (status, headers, body) to the client.
     */
    private void streamResponse(HttpResponse backendResp, HttpServletResponse resp) throws IOException {
        int status = backendResp.getStatusLine().getStatusCode();
        resp.setStatus(status);

        // Copy response headers
        for (String header : RESPONSE_HEADERS) {
            org.apache.http.Header h = backendResp.getFirstHeader(header);
            if (h != null) {
                resp.setHeader(h.getName(), h.getValue());
            }
        }

        // Copy Set-Cookie headers (for session cookies)
        org.apache.http.Header[] cookies = backendResp.getHeaders("Set-Cookie");
        if (cookies != null) {
            for (org.apache.http.Header c : cookies) {
                resp.addHeader("Set-Cookie", c.getValue());
            }
        }

        // Stream body
        HttpEntity entity = backendResp.getEntity();
        if (entity != null) {
            InputStream in = entity.getContent();
            OutputStream out = resp.getOutputStream();
            byte[] buf = new byte[8192];
            int n;
            while ((n = in.read(buf)) != -1) {
                out.write(buf, 0, n);
            }
            out.flush();
            in.close();
        }
    }

    /**
     * Read the full request body as a string.
     */
    private String readRequestBody(HttpServletRequest req) throws IOException {
        BufferedReader reader = req.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append('\n');
        }
        return sb.toString().trim();
    }

    /**
     * Write a JSON error response.
     */
    private void sendError(HttpServletResponse resp, int status, String code, String message) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"error\":\"" + escapeJson(message) + "\",\"code\":\"" + code + "\"}");
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
