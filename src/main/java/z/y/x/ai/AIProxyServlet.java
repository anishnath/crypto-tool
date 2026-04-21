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

    // Rate limit: 5 AI requests per IP per minute, max 2 burst
    private static final int REQUESTS_PER_MINUTE = 5;
    private static final int BURST_CAPACITY = 2;
    private static final int MAX_BUCKETS = 10_000;

    private static final java.util.logging.Logger log =
        java.util.logging.Logger.getLogger(AIProxyServlet.class.getName());

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

    private static String getOcrEndpoint() {
        String base = System.getenv("AI_ENDPOINT2");
        if (base == null || base.isEmpty()) {
            return null; // OCR not configured
        }
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/ocr";
    }

    private static String getVisionEndpoint() {
        String base = System.getenv("AI_ENDPOINT2");
        if (base == null || base.isEmpty()) {
            return null;
        }
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/ai";
    }

    private static String getTranscribeEndpoint() {
        String base = System.getenv("AI_ENDPOINT2");
        if (base == null || base.isEmpty()) {
            return null;
        }
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/transcribe";
    }

    // Max base64 image size: ~10MB decoded ≈ ~13.3MB base64
    private static final long MAX_IMAGE_BASE64_LENGTH = 14_000_000;
    private static final java.util.Set<String> VALID_OCR_MODES =
        new java.util.HashSet<>(java.util.Arrays.asList("text", "formula", "table"));

    // Max base64 audio size for the mic-recording / short-clip endpoint: ~5MB decoded ≈ ~6.7MB base64.
    // Video studio uses its own (larger) limit in VideoServiceServlet.
    private static final long MAX_AUDIO_BASE64_LENGTH = 7_000_000;

    private Bucket resolveBucket(String ip) {
        if (buckets.size() > MAX_BUCKETS) {
            buckets.clear();
        }
        return buckets.computeIfAbsent(ip, k -> {
            log.info("AI rate-limit: new bucket for IP " + ip);
            return Bucket.builder()
                // Hard cap: 5 tokens, all refill at once every 60 seconds
                .addLimit(Bandwidth.classic(REQUESTS_PER_MINUTE,
                        Refill.intervally(REQUESTS_PER_MINUTE, Duration.ofMinutes(1))))
                // Burst: max 2 rapid-fire, refills 2 every 30 seconds
                .addLimit(Bandwidth.classic(BURST_CAPACITY,
                        Refill.intervally(BURST_CAPACITY, Duration.ofSeconds(30))))
                .build();
        });
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

        log.fine("AI rate-limit: IP=" + clientIp + " remaining=" + probe.getRemainingTokens() + " consumed=" + probe.isConsumed());

        if (!probe.isConsumed()) {
            log.warning("AI rate-limit: BLOCKED IP=" + clientIp);
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            resp.setContentType("application/json");
            resp.setStatus(429);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in "
                    + waitSeconds + " seconds.\",\"retryAfter\":" + waitSeconds + "}");
            return;
        }

        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));

        // ── Route by action ──
        String action = req.getParameter("action");
        if ("ocr".equals(action)) {
            handleOcr(req, resp);
            return;
        }
        if ("transcribe".equals(action)) {
            handleTranscribe(req, resp);
            return;
        }
        if ("vision".equals(action)) {
            handleVision(req, resp);
            return;
        }

        // ── Default: AI chat ──
        handleChat(req, resp);
    }

    /**
     * Handle AI chat requests (default action) — forwards to AI_ENDPOINT/ai.
     */
    private void handleChat(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // ── Read request body ──
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

        if (!payload.containsKey("model") || payload.get("model") == null
                || payload.get("model").toString().trim().isEmpty()) {
            payload.put("model", DEFAULT_MODEL);
        }

        boolean stream = Boolean.TRUE.equals(payload.get("stream"));
        String ollamaJson = JsonUtil.toJson(payload);
        String aiUrl = getAiEndpoint();

        if (stream) {
            forwardStreaming(aiUrl, ollamaJson, resp);
        } else {
            forwardBlocking(aiUrl, ollamaJson, resp);
        }
    }

    /**
     * Handle OCR requests (action=ocr) — forwards to AI_ENDPOINT2/ocr.
     *
     * Validates:
     *   - image field present and non-empty
     *   - image base64 size ≤ 10MB decoded (~13.3MB base64)
     *   - mode is one of: text, formula, table (defaults to formula)
     */
    private void handleOcr(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ocrUrl = getOcrEndpoint();
        if (ocrUrl == null) {
            resp.setContentType("application/json");
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Image to LaTeX is temporarily unavailable. Please try again later.\"}");
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

        // ── Validate image ──
        Object imageObj = payload.get("image");
        if (imageObj == null || imageObj.toString().trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required field: image (base64-encoded)\"}");
            return;
        }

        String imageB64 = imageObj.toString().trim();

        // Strip data URI prefix if present (e.g. "data:image/png;base64,...")
        if (imageB64.startsWith("data:")) {
            int commaIdx = imageB64.indexOf(',');
            if (commaIdx > 0) {
                imageB64 = imageB64.substring(commaIdx + 1);
                payload.put("image", imageB64);
            }
        }

        // Validate base64 size (rough check: base64 is ~1.33x the binary size)
        if (imageB64.length() > MAX_IMAGE_BASE64_LENGTH) {
            long approxMB = imageB64.length() * 3 / 4 / 1024 / 1024;
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Image too large (~" + approxMB + "MB). Maximum is 10MB.\"}");
            return;
        }

        // Validate base64 characters (quick check on first 100 chars)
        String sample = imageB64.length() > 100 ? imageB64.substring(0, 100) : imageB64;
        if (!sample.matches("[A-Za-z0-9+/=\\s]+")) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid base64 image data\"}");
            return;
        }

        // ── Validate mode ──
        Object modeObj = payload.get("mode");
        String mode = (modeObj != null) ? modeObj.toString().trim().toLowerCase() : "formula";
        if (!VALID_OCR_MODES.contains(mode)) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid mode. Use: text, formula, or table\"}");
            return;
        }
        payload.put("mode", mode);

        // ── Forward to OCR endpoint ──
        boolean stream = Boolean.TRUE.equals(payload.get("stream"));
        String ocrJson = JsonUtil.toJson(payload);

        log.info("OCR request: mode=" + mode + " imageSize=" + (imageB64.length() / 1024) + "KB stream=" + stream);

        if (stream) {
            forwardStreaming(ocrUrl, ocrJson, resp);
        } else {
            forwardBlocking(ocrUrl, ocrJson, resp);
        }
    }

    /**
     * Handle image analyse requests (action=analyse) — forwards to AI_ENDPOINT2/ai with image.
     *
     * Uses Ollama chat format with images in the user message.
     * Caller provides: image (base64), messages (optional system+user), model (optional), stream.
     */
    private void handleVision(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String analyseUrl = getVisionEndpoint();
        if (analyseUrl == null) {
            resp.setContentType("application/json");
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Image analysis is temporarily unavailable. Please try again later.\"}");
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

        // ── Validate image ──
        Object imageObj = payload.get("image");
        if (imageObj == null || imageObj.toString().trim().isEmpty()) {
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required field: image (base64-encoded)\"}");
            return;
        }

        String imageB64 = imageObj.toString().trim();
        if (imageB64.startsWith("data:")) {
            int commaIdx = imageB64.indexOf(',');
            if (commaIdx > 0) imageB64 = imageB64.substring(commaIdx + 1);
        }

        if (imageB64.length() > MAX_IMAGE_BASE64_LENGTH) {
            long approxMB = imageB64.length() * 3 / 4 / 1024 / 1024;
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Image too large (~" + approxMB + "MB). Maximum is 10MB.\"}");
            return;
        }

        // ── Build Ollama chat payload with images ──
        // The caller may pass messages (with system prompt) or just a prompt string.
        // We ensure the user message has the images array.
        @SuppressWarnings("unchecked")
        java.util.List<Map<String, Object>> messages = (java.util.List<Map<String, Object>>) payload.get("messages");
        if (messages == null || messages.isEmpty()) {
            String prompt = payload.get("prompt") != null ? payload.get("prompt").toString() : "Describe this image.";
            messages = new java.util.ArrayList<>();
            Map<String, Object> userMsg = new java.util.HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", prompt);
            userMsg.put("images", java.util.Collections.singletonList(imageB64));
            messages.add(userMsg);
        } else {
            // Attach image to the last user message
            for (int i = messages.size() - 1; i >= 0; i--) {
                if ("user".equals(messages.get(i).get("role"))) {
                    messages.get(i).put("images", java.util.Collections.singletonList(imageB64));
                    break;
                }
            }
        }
        payload.put("messages", messages);
        payload.remove("image"); // don't send raw image field to Ollama

        if (!payload.containsKey("model") || payload.get("model") == null
                || payload.get("model").toString().trim().isEmpty()) {
            payload.put("model", "gemma4:latest");
        }

        boolean stream = Boolean.TRUE.equals(payload.get("stream"));
        String analyseJson = JsonUtil.toJson(payload);

        log.info("Analyse request: imageSize=" + (imageB64.length() / 1024) + "KB model=" + payload.get("model") + " stream=" + stream);

        if (stream) {
            forwardStreaming(analyseUrl, analyseJson, resp);
        } else {
            // Vision is slow AND upstream queue can eat up to OLLAMA_QUEUE_TIMEOUT (5 min today)
            // before inference even starts. Total budget: queue + inference + headroom.
            forwardBlocking(analyseUrl, analyseJson, resp, 360000); // 6 min
        }
    }

    /**
     * Handle transcribe requests (action=transcribe). Delegates to {@link TranscribeService}
     * so the same validation + forwarding is shared with {@code VideoServiceServlet}.
     * This endpoint keeps the legacy ~5 MB cap (mic recordings / short audio).
     */
    private void handleTranscribe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        TranscribeService.handle(req, resp, MAX_AUDIO_BASE64_LENGTH);
    }

    private String readRequestBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        return sb.toString().trim();
    }

    private void forwardBlocking(String aiUrl, String payload, HttpServletResponse resp) throws IOException {
        forwardBlocking(aiUrl, payload, resp, 120000);
    }

    /**
     * Non-streaming: forward to /ai, wait for full response, return JSON to client.
     */
    private void forwardBlocking(String aiUrl, String payload, HttpServletResponse resp, int socketTimeoutMs) throws IOException {
        resp.setContentType("application/json");

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(5000)
                .setSocketTimeout(socketTimeoutMs)
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
