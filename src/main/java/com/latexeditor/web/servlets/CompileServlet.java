package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;
import com.latexeditor.web.model.CompileRequest;
import com.latexeditor.web.model.CompileResponse;
import com.latexeditor.web.util.JsonUtil;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class CompileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ── Rate limit config ──
    // 10 compiles per IP per minute, bucket refills 10 tokens every 60 seconds
    private static final int COMPILES_PER_MINUTE = 10;
    // Burst: allow up to 3 rapid compiles before throttling kicks in
    private static final int BURST_CAPACITY = 3;

    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    // Evict stale buckets every ~1000 new IPs to prevent unbounded growth
    private static final int MAX_BUCKETS = 10_000;

    private Bucket resolveBucket(String ip) {
        // Evict all if map grows too large (simple strategy)
        if (buckets.size() > MAX_BUCKETS) {
            buckets.clear();
        }
        return buckets.computeIfAbsent(ip, k -> createBucket());
    }

    private static Bucket createBucket() {
        // Sustained: 10 tokens, refills gradually over 1 minute
        Bandwidth sustained = Bandwidth.classic(COMPILES_PER_MINUTE,
                Refill.greedy(COMPILES_PER_MINUTE, Duration.ofMinutes(1)));
        // Burst: 3 tokens, refills all-at-once every 10 seconds
        Bandwidth burst = Bandwidth.classic(BURST_CAPACITY,
                Refill.intervally(BURST_CAPACITY, Duration.ofSeconds(10)));
        return Bucket.builder()
                .addLimit(sustained)
                .addLimit(burst)
                .build();
    }

    private String getClientIp(HttpServletRequest req) {
        // Check X-Forwarded-For (reverse proxy / load balancer)
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isEmpty()) {
            // Take the first (leftmost) IP — the original client
            String ip = xff.split(",")[0].trim();
            if (!ip.isEmpty()) return ip;
        }
        String realIp = req.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isEmpty()) {
            return realIp.trim();
        }
        return req.getRemoteAddr();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // ── Rate limit check ──
        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            resp.setStatus(429);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in "
                    + waitSeconds + " seconds.\",\"retryAfter\":" + waitSeconds + "}");
            return;
        }

        // Set remaining tokens header for client awareness
        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        String body = sb.toString().trim();

        if (body.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Empty request body\"}");
            return;
        }

        // Extract source and optional fileIds
        String latexSource;
        List<String> fileIds = null;
        String contentType = req.getContentType();

        if (contentType != null && contentType.contains("application/json")) {
            CompileRequest compileReq = JsonUtil.fromJson(body, CompileRequest.class);
            latexSource = compileReq != null ? compileReq.getSource() : null;
            fileIds = compileReq != null ? compileReq.getFileIds() : null;
        } else {
            latexSource = body;
        }

        if (latexSource == null || latexSource.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Empty LaTeX source\"}");
            return;
        }

        try {
            ApiClient client = new ApiClient();
            CompileResponse result = client.compile(latexSource, fileIds);
            resp.getWriter().write(JsonUtil.toJson(result));
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Compilation service unavailable\"}");
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Compilation timed out\"}");
        } catch (ApiException e) {
            resp.setStatus(502);
            resp.getWriter().write("{\"error\":" + JsonUtil.toJson(e.getMessage()) + "}");
        }
    }
}
