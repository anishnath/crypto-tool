package com.arduino.web.servlets;

import com.latexeditor.web.client.ApiClientConfig;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import org.apache.http.HttpEntity;
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
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.GZIPOutputStream;
import java.net.SocketTimeoutException;
import java.time.Duration;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

/**
 * Proxy servlet for Arduino sketch compilation.
 *
 * Mapped to /api/arduino/compile — validates the request, applies rate
 * limiting, then forwards to the backend compile API (CF Worker / VPS)
 * which runs arduino-cli.
 *
 * Request:
 *   POST /api/arduino/compile
 *   { "sketch": "...", "board": "arduino:avr:uno", "libraries": ["Servo"] }
 *
 * Response:
 *   { "success": true, "hex": ":10000000...", "programSize": 924, ... }
 *   or
 *   { "success": false, "error": "compile", "errors": [...] }
 */
public class ArduinoCompileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ── Timeouts ──
    private static final int CONNECT_TIMEOUT = 5_000;   // 5s
    private static final int READ_TIMEOUT    = 60_000;  // 60s — compilation can be slow

    // ── Rate limiting: 200 compiles per hour, burst of 20 ──
    private static final int COMPILES_PER_HOUR = 200;
    private static final int COMPILE_BURST     = 20;
    private static final int MAX_BUCKETS       = 10_000;
    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    // ── Validation limits ──
    private static final int MAX_SKETCH_SIZE   = 50 * 1024;  // 50KB
    private static final int MAX_LIBRARIES     = 10;

    // ── Board allowlist (V1) ──
    private static final Set<String> ALLOWED_BOARDS = new HashSet<>(Arrays.asList(
        "arduino:avr:uno",
        "arduino:avr:nano",
        "arduino:avr:mega",
        "rp2040:rp2040:rpipico",
        "rp2040:rp2040:rpipicow"
    ));

    // ── Library allowlist (V1) ──
    private static final Set<String> ALLOWED_LIBRARIES = new HashSet<>(Arrays.asList(
        "Servo",
        "Wire",
        "SPI",
        "EEPROM",
        "SoftwareSerial",
        "LiquidCrystal",
        "Stepper",
        "Adafruit_NeoPixel",
        "DHT"
    ));

    // ── Shell injection patterns ──
    private static final Pattern SHELL_INJECTION = Pattern.compile(
        "[`]|\\$\\(|\\$\\{|;\\s*rm|;\\s*cat|;\\s*curl|;\\s*wget|\\|\\s*sh|\\|\\s*bash|>/dev/"
    );

    // ── Helpers ──

    private Bucket resolveBucket(String ip) {
        if (buckets.size() > MAX_BUCKETS) buckets.clear();
        return buckets.computeIfAbsent(ip, k -> Bucket.builder()
                .addLimit(Bandwidth.classic(COMPILES_PER_HOUR, Refill.greedy(COMPILES_PER_HOUR, Duration.ofHours(1))))
                .addLimit(Bandwidth.classic(COMPILE_BURST, Refill.intervally(COMPILE_BURST, Duration.ofSeconds(30))))
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

    private RequestConfig defaultConfig() {
        return RequestConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT)
                .setSocketTimeout(READ_TIMEOUT)
                .build();
    }

    private String getBackendUrl() {
        return ApiClientConfig.getApiBaseUrl() + "/api/arduino-compile";
    }

    // ── POST /api/arduino/compile ──

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        System.out.println("Arduino compile request received");

        // Rate limit
        String ip = getClientIp(req);
        Bucket bucket = resolveBucket(ip);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            sendError(resp, 429, "RATE_LIMITED",
                    "Too many compile requests. Try again in " + waitSeconds + " seconds.");
            return;
        }
        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));

        // Read body
        String body = readRequestBody(req);
        if (body == null || body.isEmpty()) {
            sendError(resp, 400, "EMPTY_BODY", "Request body is required.");
            return;
        }

        // Validate — extract fields with minimal JSON parsing (no dependency needed)
        String sketch = extractJsonString(body, "sketch");
        String board  = extractJsonString(body, "board");
        String[] files = extractJsonArray(body, "files");

        // Multi-file: sketch can be empty if files[] contains sketch.ino
        boolean hasSketch = sketch != null && !sketch.isEmpty();
        boolean hasFiles = files != null && files.length > 0;

        if (!hasSketch && !hasFiles) {
            sendError(resp, 400, "MISSING_SKETCH", "\"sketch\" or \"files\" with sketch.ino is required.");
            return;
        }

        // Size check: sketch + all file contents combined
        long totalSize = hasSketch ? sketch.length() : 0;
        if (hasFiles) {
            for (String f : files) totalSize += f.length();
        }
        if (totalSize > MAX_SKETCH_SIZE) {
            sendError(resp, 400, "SKETCH_TOO_LARGE",
                    "Combined sketch size exceeds maximum (" + (MAX_SKETCH_SIZE / 1024) + "KB limit).");
            return;
        }

        // Board validation (default to uno)
        if (board == null || board.isEmpty()) {
            board = "arduino:avr:uno";
        }
        if (!ALLOWED_BOARDS.contains(board)) {
            sendError(resp, 400, "INVALID_BOARD",
                    "Board \"" + escapeJson(board) + "\" is not supported. Allowed: " + ALLOWED_BOARDS);
            return;
        }

        // Library validation
        String[] libraries = extractJsonArray(body, "libraries");
        if (libraries != null) {
            if (libraries.length > MAX_LIBRARIES) {
                sendError(resp, 400, "TOO_MANY_LIBRARIES",
                        "Maximum " + MAX_LIBRARIES + " libraries allowed.");
                return;
            }
            for (String lib : libraries) {
                if (!ALLOWED_LIBRARIES.contains(lib)) {
                    sendError(resp, 400, "INVALID_LIBRARY",
                            "Library \"" + escapeJson(lib) + "\" is not available. Allowed: " + ALLOWED_LIBRARIES);
                    return;
                }
            }
        }

        // Sketch must contain setup() or loop() or main() (check sketch + files)
        String allContent = (hasSketch ? sketch : "") + (hasFiles ? String.join(" ", files) : "");
        if (!allContent.contains("setup") && !allContent.contains("loop") && !allContent.contains("main")) {
            sendError(resp, 400, "INVALID_SKETCH",
                    "Sketch must contain setup(), loop(), or main().");
            return;
        }

        // Shell injection check on all content
        if (hasSketch && SHELL_INJECTION.matcher(sketch).find()) {
            sendError(resp, 400, "INVALID_SKETCH", "Sketch contains disallowed characters.");
            return;
        }
        if (hasFiles) {
            for (String f : files) {
                if (SHELL_INJECTION.matcher(f).find()) {
                    sendError(resp, 400, "INVALID_SKETCH", "File contains disallowed characters.");
                    return;
                }
            }
        }

        // Null byte check
        if (hasSketch && sketch.indexOf('\0') >= 0) {
            sendError(resp, 400, "INVALID_SKETCH", "Sketch contains null bytes.");
            return;
        }

        // Forward to backend
        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(getBackendUrl());
            post.setConfig(defaultConfig());
            post.setEntity(new StringEntity(body, ContentType.APPLICATION_JSON));

            // Request uncompressed from backend — we gzip ourselves if client supports it
            post.setHeader("Accept-Encoding", "identity");

            HttpResponse backendResp;
            try {
                backendResp = client.execute(post);
            } catch (HttpHostConnectException e) {
                sendError(resp, 503, "COMPILER_UNAVAILABLE",
                        "Arduino compiler service is unavailable. Try a preset sketch.");
                return;
            } catch (ConnectTimeoutException | SocketTimeoutException e) {
                sendError(resp, 504, "COMPILE_TIMEOUT",
                        "Compilation timed out. Sketch may be too complex.");
                return;
            }

            // Read backend response body into buffer
            int status = backendResp.getStatusLine().getStatusCode();
            resp.setStatus(status);

            org.apache.http.Header ct = backendResp.getFirstHeader("Content-Type");
            if (ct != null) resp.setHeader("Content-Type", ct.getValue());

            HttpEntity entity = backendResp.getEntity();
            if (entity != null) {
                // Read full response into byte array
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                InputStream in = entity.getContent();
                byte[] buf = new byte[8192];
                int n;
                while ((n = in.read(buf)) != -1) {
                    baos.write(buf, 0, n);
                }
                in.close();
                byte[] responseBytes = baos.toByteArray();

                // Gzip if client supports it and response is worth compressing (>256 bytes)
                boolean clientAcceptsGzip = acceptsGzip(req);
                if (clientAcceptsGzip && responseBytes.length > 256) {
                    ByteArrayOutputStream gzipBuf = new ByteArrayOutputStream();
                    GZIPOutputStream gzos = new GZIPOutputStream(gzipBuf);
                    gzos.write(responseBytes);
                    gzos.close();
                    byte[] compressed = gzipBuf.toByteArray();

                    resp.setHeader("Content-Encoding", "gzip");
                    resp.setContentLength(compressed.length);
                    resp.getOutputStream().write(compressed);
                } else {
                    resp.setContentLength(responseBytes.length);
                    resp.getOutputStream().write(responseBytes);
                }
                resp.getOutputStream().flush();
            }
        } finally {
            client.close();
        }
    }

    // Only POST is supported
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        sendError(resp, 405, "METHOD_NOT_ALLOWED", "Use POST to compile Arduino sketches.");
    }

    // ── Gzip Helper ──

    private boolean acceptsGzip(HttpServletRequest req) {
        String ae = req.getHeader("Accept-Encoding");
        return ae != null && ae.contains("gzip");
    }

    // ── JSON Helpers (minimal, no external dependency) ──

    /**
     * Extract a string value from JSON by key. Handles escaped quotes.
     * e.g. extractJsonString({"sketch":"code"}, "sketch") → "code"
     */
    static String extractJsonString(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIdx = json.indexOf(pattern);
        if (keyIdx < 0) return null;

        int colonIdx = json.indexOf(':', keyIdx + pattern.length());
        if (colonIdx < 0) return null;

        // Find the opening quote of the value
        int startQuote = json.indexOf('"', colonIdx + 1);
        if (startQuote < 0) return null;

        // Find the closing quote (handle escaped quotes)
        StringBuilder sb = new StringBuilder();
        for (int i = startQuote + 1; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '\\' && i + 1 < json.length()) {
                char next = json.charAt(i + 1);
                if (next == '"') {
                    sb.append('"');
                    i++;
                } else if (next == 'n') {
                    sb.append('\n');
                    i++;
                } else if (next == 't') {
                    sb.append('\t');
                    i++;
                } else if (next == '\\') {
                    sb.append('\\');
                    i++;
                } else {
                    sb.append(c);
                }
            } else if (c == '"') {
                break;
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    /**
     * Extract a string array from JSON by key.
     * e.g. extractJsonArray({"libraries":["Servo","Wire"]}, "libraries") → ["Servo","Wire"]
     */
    static String[] extractJsonArray(String json, String key) {
        String pattern = "\"" + key + "\"";
        int keyIdx = json.indexOf(pattern);
        if (keyIdx < 0) return null;

        int bracketStart = json.indexOf('[', keyIdx + pattern.length());
        if (bracketStart < 0) return null;

        int bracketEnd = json.indexOf(']', bracketStart);
        if (bracketEnd < 0) return null;

        String inner = json.substring(bracketStart + 1, bracketEnd).trim();
        if (inner.isEmpty()) return new String[0];

        // Split by comma, strip quotes
        String[] parts = inner.split(",");
        String[] result = new String[parts.length];
        for (int i = 0; i < parts.length; i++) {
            result[i] = parts[i].trim().replaceAll("^\"|\"$", "");
        }
        return result;
    }

    // ── Response Helpers ──

    private String readRequestBody(HttpServletRequest req) throws IOException {
        BufferedReader reader = req.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append('\n');
        }
        return sb.toString().trim();
    }

    private void sendError(HttpServletResponse resp, int status, String code, String message) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write("{\"success\":false,\"error\":\"" + code + "\",\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
