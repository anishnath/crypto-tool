package z.y.x.ai;

import com.latexeditor.web.util.JsonUtil;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

/**
 * Compatibility proxy that forwards Ollama-style chat payloads to the Go AI gateway
 * (OpenAI-compatible /v1/chat/completions) and translates responses back into the
 * NDJSON shape expected by existing frontends.
 *
 * Incoming (from browser): {"messages":[...], "stream":true|false, "model": "...optional..."}
 * Outgoing (to browser):
 *   - streaming: application/x-ndjson with lines like {"message":{"content":"..."}} then {"done":true}
 *   - blocking:  application/json with {"message":{"content":"..."}} (same as AIProxyServlet contract)
 */
public class AIGatewayProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final java.util.logging.Logger log =
        java.util.logging.Logger.getLogger(AIGatewayProxyServlet.class.getName());

    private static final Pattern GATEWAY_MODEL_ALLOW =
        Pattern.compile("^(mimo-|gpt-).+");

    // ── Rate limit (mirrors AIProxyServlet): 5 req/min, burst 2 ──
    // Applies to anonymous + logged-in NON-Pro users. Pro users bypass entirely.
    private static final int REQUESTS_PER_MINUTE = 5;
    private static final int BURST_CAPACITY = 2;
    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    // Premium status cache (userId -> [isPremium(0/1), expiresAtMillis]) to avoid
    // hitting the billing gateway on every chat request. TTL: 5 minutes.
    private static final long PREMIUM_CACHE_TTL_MS = 6L * 60 * 60 * 1000L;
    private static final Map<String, long[]> premiumCache = new ConcurrentHashMap<>();

    private Bucket resolveBucket(String key) {
        if (buckets.size() > MAX_BUCKETS) {
            buckets.clear();
        }
        return buckets.computeIfAbsent(key, k -> Bucket.builder()
            .addLimit(Bandwidth.classic(REQUESTS_PER_MINUTE,
                    Refill.intervally(REQUESTS_PER_MINUTE, Duration.ofMinutes(1))))
            .addLimit(Bandwidth.classic(BURST_CAPACITY,
                    Refill.intervally(BURST_CAPACITY, Duration.ofSeconds(30))))
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

    /** Logged-in user id from the session (trusted), or null for anonymous. */
    private String sessionUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object sub = session.getAttribute("oauth_user_sub");
        if (sub == null) return null;
        String s = sub.toString().trim();
        return s.isEmpty() ? null : s;
    }

    /**
     * True when the logged-in user has an active Pro subscription. Cached per user
     * for {@link #PREMIUM_CACHE_TTL_MS}. Anonymous users are never premium.
     * Fails open to {@code false} (rate-limited) when billing status is unavailable.
     */
    private boolean isPremiumUser(String userId) {
        if (userId == null || userId.isEmpty()) return false;
        long now = System.currentTimeMillis();
        long[] cached = premiumCache.get(userId);
        if (cached != null && cached[1] > now) {
            return cached[0] == 1L;
        }
        boolean premium = fetchPremiumStatus(userId);
        premiumCache.put(userId, new long[]{ premium ? 1L : 0L, now + PREMIUM_CACHE_TTL_MS });
        return premium;
    }

    private boolean fetchPremiumStatus(String userId) {
        String url = getGatewayBase() + "/v1/billing/status";
        RequestConfig config = RequestConfig.custom()
            .setConnectTimeout(3000)
            .setSocketTimeout(4000)
            .build();
        try (CloseableHttpClient client = HttpClients.custom().setDefaultRequestConfig(config).build()) {
            HttpGet get = new HttpGet(url);
            get.setHeader("X-User-Id", userId);
            String secret = System.getenv("BILLING_INTERNAL_SECRET");
            if (secret != null && !secret.isEmpty()) {
                get.setHeader("X-Billing-Internal-Secret", secret);
            }
            HttpResponse upstream = client.execute(get);
            int status = upstream.getStatusLine().getStatusCode();
            if (status >= 400) return false;
            String respBody = readBody(upstream);
            @SuppressWarnings("unchecked")
            Map<String, Object> obj = JsonUtil.fromJson(respBody, Map.class);
            if (obj == null) return false;
            Object isPremium = obj.get("is_premium");
            if (isPremium instanceof Boolean) return (Boolean) isPremium;
            if (isPremium instanceof Number) return ((Number) isPremium).intValue() != 0;
            return "true".equalsIgnoreCase(String.valueOf(isPremium));
        } catch (Exception e) {
            log.fine("billing status check failed for user " + userId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Enforce the free-tier rate limit. Returns {@code true} when the request may
     * proceed; writes a friendly upgrade-oriented 429 and returns {@code false}
     * when the caller is throttled.
     */
    private boolean enforceRateLimit(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = sessionUserId(req);
        if (isPremiumUser(userId)) {
            resp.setHeader("X-RateLimit-Tier", "pro");
            return true; // Pro: unlimited
        }

        boolean loggedIn = userId != null;
        String key = loggedIn ? ("uid:" + userId) : ("ip:" + getClientIp(req));
        Bucket bucket = resolveBucket(key);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            log.warning("AI gateway rate-limit BLOCKED key=" + key + " loggedIn=" + loggedIn);
            resp.setContentType("application/json");
            resp.setStatus(429);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            String message = loggedIn
                ? "You've reached the free AI limit. Upgrade to Pro for higher limits and no waiting."
                : "You've reached the free AI limit. Sign in for more, or upgrade to Pro for the highest limits.";
            StringBuilder sb = new StringBuilder();
            sb.append('{')
              .append("\"error\":").append(JsonUtil.toJson(message)).append(',')
              .append("\"code\":\"rate_limited\",")
              .append("\"retryAfter\":").append(waitSeconds).append(',')
              .append("\"upgrade\":true,")
              .append("\"logged_in\":").append(loggedIn)
              .append('}');
            resp.getWriter().write(sb.toString());
            return false;
        }

        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));
        resp.setHeader("X-RateLimit-Tier", loggedIn ? "free" : "anonymous");
        return true;
    }

    private static String getGatewayBase() {
        String base = System.getenv("AI_GATEWAY");
        if (base == null || base.isEmpty()) {
            base = "http://localhost:8084";
        }
        if (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base;
    }

    private static String gatewayChatURL() {
        return getGatewayBase() + "/v1/chat/completions";
    }

    private static boolean useGatewayEnabled() {
        return AiGatewayConfig.isGatewayEnabled();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!useGatewayEnabled()) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            resp.getWriter().write("{\"error\":\"AI gateway disabled\"}");
            return;
        }

        resp.setCharacterEncoding("UTF-8");

        // ── Free-tier rate limit (Pro users bypass) ──
        if (!enforceRateLimit(req, resp)) {
            return;
        }

        String body = readRequestBody(req);
        if (body.isEmpty()) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Empty request body\"}");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> payload = JsonUtil.fromJson(body, Map.class);
        if (payload == null) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid JSON\"}");
            return;
        }

        boolean stream = Boolean.TRUE.equals(payload.get("stream"));
        Map<String, Object> gatewayReq = new java.util.HashMap<>();

        // Required by gateway: messages[]
        Object messages = payload.get("messages");
        if (messages == null) {
            // Some older clients send {prompt:"..."}; map that to messages.
            Object prompt = payload.get("prompt");
            if (prompt == null || prompt.toString().trim().isEmpty()) {
                resp.setContentType("application/json");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Missing required field: messages\"}");
                return;
            }
            java.util.List<Map<String, Object>> ms = new java.util.ArrayList<>();
            Map<String, Object> userMsg = new java.util.HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", prompt.toString());
            ms.add(userMsg);
            gatewayReq.put("messages", ms);
        } else {
            gatewayReq.put("messages", messages);
        }

        // Model: only forward if it looks like a gateway model id; otherwise omit so gateway uses DEFAULT_MODEL.
        Object model = payload.get("model");
        if (model != null) {
            String m = model.toString().trim();
            if (!m.isEmpty() && GATEWAY_MODEL_ALLOW.matcher(m).matches()) {
                gatewayReq.put("model", m);
            }
        }

        gatewayReq.put("stream", stream);

        String json = JsonUtil.toJson(gatewayReq);
        String url = gatewayChatURL();

        if (stream) {
            forwardStreamingSSEToNDJSON(url, json, req, resp);
        } else {
            forwardBlockingJSONToCompatJSON(url, json, req, resp);
        }
    }

    /**
     * Forwards gateway identity headers from the browser (see openai-go-api README).
     */
    private void applyGatewayHeaders(HttpUriRequest post, HttpServletRequest req) {
        copyHeader(req, post, "X-User-Id");
        copyHeader(req, post, "X-Anonymous-Id");
        copyHeader(req, post, "Authorization");
        copyHeader(req, post, "X-Request-ID");

        String toolId = req.getHeader("X-Tool-Id");
        if (toolId != null && !toolId.trim().isEmpty()) {
            post.setHeader("X-Tool-Id", toolId.trim());
        } else {
            post.setHeader("X-Tool-Id", "electronics/arduino-simulator");
        }
    }

    private static void copyHeader(HttpServletRequest req, HttpUriRequest post, String name) {
        String v = req.getHeader(name);
        if (v != null && !v.trim().isEmpty()) {
            post.setHeader(name, v.trim());
        }
    }

    private void forwardBlockingJSONToCompatJSON(String url, String json, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");

        RequestConfig config = RequestConfig.custom()
            .setConnectTimeout(5000)
            .setSocketTimeout(180000)
            .build();

        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(url);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            applyGatewayHeaders(post, req);
            post.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();
            String respBody = readBody(upstream);

            if (status >= 400) {
                resp.setStatus(mapUpstreamStatus(status));
                resp.getWriter().write(respBody.isEmpty() ? "{\"error\":\"AI gateway error\"}" : respBody);
                return;
            }

            // Gateway returns {"content":"..."}; OpenAI returns choices[0].message.content
            String content = extractBlockingContent(respBody);
            resp.getWriter().write("{\"message\":{\"content\":" + JsonUtil.toJson(content) + "}}");
        } catch (java.net.SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"AI request timed out\"}");
        } catch (IOException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"AI gateway unavailable\"}");
        }
    }

    private static int mapUpstreamStatus(int status) {
        if (status >= 500) return 502;
        return status;
    }

    /**
     * Upstream: SSE (text/event-stream) with data: JSON lines.
     * Downstream: NDJSON with {"message":{"content":"..."}} lines + {"done":true}.
     */
    private void forwardStreamingSSEToNDJSON(String url, String json, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/x-ndjson");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("X-Accel-Buffering", "no");

        RequestConfig config = RequestConfig.custom()
            .setConnectTimeout(5000)
            .setSocketTimeout(180000)
            .build();

        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(url);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            applyGatewayHeaders(post, req);
            post.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();
            if (status >= 400) {
                resp.setContentType("application/json");
                String respBody = readBody(upstream);
                resp.setStatus(mapUpstreamStatus(status));
                resp.getWriter().write(respBody.isEmpty() ? "{\"error\":\"AI gateway error\"}" : respBody);
                return;
            }

            InputStream in = upstream.getEntity().getContent();
            BufferedReader br = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8));
            OutputStream out = resp.getOutputStream();

            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                if (line.startsWith("data:")) {
                    String data = line.substring(5).trim();
                    if ("[DONE]".equals(data)) break;
                    String delta = extractStreamTextChunk(data);
                    if (delta != null && !delta.isEmpty()) {
                        String nd = "{\"message\":{\"content\":" + JsonUtil.toJson(delta) + "}}\n";
                        out.write(nd.getBytes(StandardCharsets.UTF_8));
                        out.flush();
                    }
                }
            }

            out.write("{\"done\":true}\n".getBytes(StandardCharsets.UTF_8));
            out.flush();
        } catch (java.net.SocketTimeoutException e) {
            resp.setContentType("application/json");
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"AI request timed out\"}");
        } catch (IOException e) {
            resp.setContentType("application/json");
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"AI gateway unavailable\"}");
        }
    }

    /**
     * Text chunk from one SSE data line (Go gateway or OpenAI-compatible upstream).
     */
    private static String extractStreamTextChunk(String json) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> obj = JsonUtil.fromJson(json, Map.class);
            if (obj == null) return null;

            // Go gateway: data: {"type":"content","delta":"..."}
            Object type = obj.get("type");
            if ("content".equals(type)) {
                Object delta = obj.get("delta");
                if (delta != null) {
                    String s = delta.toString();
                    return s.isEmpty() ? null : s;
                }
            }
            if ("done".equals(type)) {
                return null;
            }
        } catch (Exception ignored) {
            // fall through to OpenAI shape
        }
        return extractOpenAIStreamDelta(json);
    }

    /** Blocking JSON: Go gateway {"content":"..."} or OpenAI choices[].message.content */
    private static String extractBlockingContent(String json) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> obj = JsonUtil.fromJson(json, Map.class);
            if (obj == null) return "";
            Object content = obj.get("content");
            if (content != null && !content.toString().isEmpty()) {
                return content.toString();
            }
        } catch (Exception ignored) {
            // fall through
        }
        return extractOpenAIBlockingContent(json);
    }

    private static String extractOpenAIBlockingContent(String json) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> obj = JsonUtil.fromJson(json, Map.class);
            if (obj == null) return "";
            Object choicesObj = obj.get("choices");
            if (!(choicesObj instanceof java.util.List)) return "";
            java.util.List<?> choices = (java.util.List<?>) choicesObj;
            if (choices.isEmpty()) return "";
            Object c0 = choices.get(0);
            if (!(c0 instanceof Map)) return "";
            @SuppressWarnings("unchecked")
            Map<String, Object> c0m = (Map<String, Object>) c0;
            Object msgObj = c0m.get("message");
            if (!(msgObj instanceof Map)) return "";
            @SuppressWarnings("unchecked")
            Map<String, Object> msg = (Map<String, Object>) msgObj;
            Object content = msg.get("content");
            return content != null ? content.toString() : "";
        } catch (Exception e) {
            return "";
        }
    }

    private static String extractOpenAIStreamDelta(String json) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> obj = JsonUtil.fromJson(json, Map.class);
            if (obj == null) return null;
            Object choicesObj = obj.get("choices");
            if (!(choicesObj instanceof java.util.List)) return null;
            java.util.List<?> choices = (java.util.List<?>) choicesObj;
            if (choices.isEmpty()) return null;
            Object c0 = choices.get(0);
            if (!(c0 instanceof Map)) return null;
            @SuppressWarnings("unchecked")
            Map<String, Object> c0m = (Map<String, Object>) c0;
            Object deltaObj = c0m.get("delta");
            if (!(deltaObj instanceof Map)) return null;
            @SuppressWarnings("unchecked")
            Map<String, Object> delta = (Map<String, Object>) deltaObj;
            Object content = delta.get("content");
            return content != null ? content.toString() : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String readRequestBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line).append("\n");
        return sb.toString().trim();
    }

    private String readBody(HttpResponse response) throws IOException {
        if (response.getEntity() == null) return "";
        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        return sb.toString();
    }
}

