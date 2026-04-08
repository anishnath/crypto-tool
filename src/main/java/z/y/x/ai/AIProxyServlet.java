package z.y.x.ai;

import com.latexeditor.web.util.JsonUtil;


import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
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
 * Generic AI proxy servlet — forwards requests to the OneCompiler /ai endpoint (Ollama).
 *
 * The client sends the full Ollama-compatible payload (model, messages, stream).
 * This servlet handles:
 *   - Rate limiting (per IP)
 *   - Default model injection if missing
 *   - Streaming (NDJSON passthrough) and non-streaming forwarding
 *   - Error translation for upstream failures
 *
 * Any tool on the site (LaTeX editor, code runner, etc.) can call POST /ai
 * with its own system prompt and user content.
 *
 * Request body (Ollama-compatible JSON):
 *   {
 *     "messages": [{"role":"system","content":"..."},{"role":"user","content":"..."}],
 *     "stream": true|false,
 *     "model": "qwen3-coder:latest"  (optional, defaults to DEFAULT_MODEL)
 *   }
 *
 * Or shorthand:
 *   { "prompt": "...", "stream": false }
 */
public class AIProxyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String DEFAULT_MODEL = "qwen3-coder:latest";

    // Rate limit: 5 AI requests per IP per minute, burst of 2
    private static final int REQUESTS_PER_MINUTE = 5;
    private static final int BURST_CAPACITY = 2;
    private static final int MAX_BUCKETS = 10_000;

    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    private static String getApiKey() {
        String key = System.getenv("AI_API_KEY");
        return key != null ? key : "";
    }

    private static String getAiEndpoint() {
        String base = System.getenv("AI_ENDPOINT");
        if (base == null || base.isEmpty()) {
            base = "http://localhost:8081";
        }
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/ai";
    }

    private Bucket resolveBucket(String ip) {
        if (buckets.size() > MAX_BUCKETS) {
            buckets.clear();
        }
        return buckets.computeIfAbsent(ip, k -> Bucket.builder()
                .addLimit(Bandwidth.classic(REQUESTS_PER_MINUTE,
                        Refill.greedy(REQUESTS_PER_MINUTE, Duration.ofMinutes(1))))
                .addLimit(Bandwidth.classic(BURST_CAPACITY,
                        Refill.intervally(BURST_CAPACITY, Duration.ofSeconds(10))))
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");

        // ── Rate limit ──
        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            resp.setContentType("application/json");
            resp.setStatus(429);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in "
                    + waitSeconds + " seconds.\",\"retryAfter\":" + waitSeconds + "}");
            return;
        }

        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));

        // ── Read request body ──
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        String body = sb.toString().trim();

        if (body.isEmpty()) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Empty request body\"}");
            return;
        }

        // ── Inject default model if not present ──
        @SuppressWarnings("unchecked")
        Map<String, Object> payload = JsonUtil.fromJson(body, Map.class);
        if (payload == null) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid JSON\"}");
            return;
        }

        if (!payload.containsKey("model") || payload.get("model") == null
                || payload.get("model").toString().trim().isEmpty()) {
            payload.put("model", DEFAULT_MODEL);
        }

        // Determine if streaming
        boolean stream = Boolean.TRUE.equals(payload.get("stream"));

        String ollamaJson = JsonUtil.toJson(payload);

        // ── Forward to AI endpoint ──
        String aiUrl = getAiEndpoint();

        if (stream) {
            forwardStreaming(aiUrl, ollamaJson, resp);
        } else {
            forwardBlocking(aiUrl, ollamaJson, resp);
        }
    }

    /**
     * Non-streaming: forward to /ai, wait for full response, return JSON to client.
     */
    private void forwardBlocking(String aiUrl, String payload, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(5000)
                .setSocketTimeout(120000)
                .build();

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(aiUrl);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                post.setHeader("X-API-Key", apiKey);
            }
            post.setEntity(new StringEntity(payload, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();

            if (status >= 400) {
                String respBody = readBody(upstream);
                resp.setStatus(status >= 500 ? 502 : status);
                resp.getWriter().write(respBody.isEmpty() ? "{\"error\":\"AI service error\"}" : respBody);
                return;
            }

            String respBody = readBody(upstream);
            resp.getWriter().write(respBody);

        } catch (HttpHostConnectException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"AI service unavailable\"}");
        } catch (ConnectTimeoutException | SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"AI request timed out\"}");
        } finally {
            client.close();
        }
    }

    /**
     * Streaming: pipe NDJSON from Ollama directly to the client.
     */
    private void forwardStreaming(String aiUrl, String payload, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/x-ndjson");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("X-Accel-Buffering", "no");

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(5000)
                .setSocketTimeout(300000)
                .build();

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(aiUrl);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                post.setHeader("X-API-Key", apiKey);
            }
            post.setEntity(new StringEntity(payload, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();

            if (status >= 400) {
                resp.setContentType("application/json");
                String respBody = readBody(upstream);
                resp.setStatus(status >= 500 ? 502 : status);
                resp.getWriter().write(respBody.isEmpty() ? "{\"error\":\"AI service error\"}" : respBody);
                return;
            }

            InputStream in = upstream.getEntity().getContent();
            OutputStream out = resp.getOutputStream();
            byte[] buf = new byte[1024];
            int n;
            while ((n = in.read(buf)) != -1) {
                out.write(buf, 0, n);
                out.flush();
            }
            in.close();

        } catch (HttpHostConnectException e) {
            resp.setContentType("application/json");
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"AI service unavailable\"}");
        } catch (ConnectTimeoutException | SocketTimeoutException e) {
            resp.setContentType("application/json");
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"AI request timed out\"}");
        } finally {
            client.close();
        }
    }

    private String readBody(HttpResponse response) throws IOException {
        if (response.getEntity() == null) return "";
        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }
}
