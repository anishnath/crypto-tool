package z.y.x.onecompiler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * Proxies algorithm visualization requests to the OneCompiler backend ({@code /viz/*}).
 * Separate from {@link OneCompilerFunctionality} which handles compile/run ({@code /execute}).
 *
 * GET:
 * - action=languages
 * - action=metadata&amp;lang=X&amp;version=Y
 * - action=capabilities[&amp;language=X]
 * - action=language_capabilities&amp;lang=X
 *
 * POST:
 * - action=execute — body: { language, version?, code?, files? }
 *
 * Crypto-visualization passthrough (OneCompiler {@code /crypto/*}, separate from {@code /viz/*}):
 * - GET  action=crypto_algorithms — catalog/form-schema for the FE
 * - GET/POST action=crypto_trace — body/query: { algorithm, mode, message, key }
 */
public class OneCompilerVizFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int CONNECT_TIMEOUT = 30000;
    /** Viz runs Docker containers; allow same headroom as compile/run. */
    private static final int READ_TIMEOUT = 120000;

    /**
     * In-memory cache for GET metadata responses (languages, capabilities,
     * language_capabilities, metadata). These change only on a backend deploy, so
     * we cache successful responses forever — the cache is cleared only when the
     * server (JVM) restarts.
     */
    private static final java.util.concurrent.ConcurrentHashMap<String, UpstreamResponse> GET_CACHE =
            new java.util.concurrent.ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Action parameter is required");
            return;
        }

        switch (action.toLowerCase()) {
            case "languages":
                proxyGet("languages", null, request, response);
                break;
            case "metadata":
                proxyLanguageMetadata(request, response);
                break;
            case "capabilities":
                proxyCapabilities(request, response);
                break;
            case "language_capabilities":
                proxyLanguageCapabilities(request, response);
                break;
            case "crypto_algorithms":
                // Catalog rarely changes (backend deploy) — reuse the GET cache.
                proxyCryptoGet("algorithms", null, response);
                break;
            case "crypto_trace":
                proxyCryptoTraceGet(request, response);
                break;
            default:
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Unknown GET action: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Action parameter is required");
            return;
        }

        if ("execute".equalsIgnoreCase(action)) {
            proxyExecute(request, response);
            return;
        }

        if ("crypto_trace".equalsIgnoreCase(action)) {
            proxyCryptoTracePost(request, response);
            return;
        }

        sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Unknown POST action: " + action);
    }

    private void proxyLanguageMetadata(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String language = request.getParameter("lang");
        if (language == null || language.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Language parameter (lang) is required");
            return;
        }

        String version = request.getParameter("version");
        String path = "languages/" + urlEncode(language) + "/metadata";
        String query = null;
        if (version != null && !version.isEmpty()) {
            query = "version=" + urlEncode(version);
        }
        proxyGet(path, query, request, response);
    }

    private void proxyCapabilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String language = request.getParameter("language");
        String query = null;
        if (language != null && !language.isEmpty()) {
            query = "language=" + urlEncode(language);
        }
        proxyGet("capabilities", query, request, response);
    }

    private void proxyLanguageCapabilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String language = request.getParameter("lang");
        if (language == null || language.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Language parameter (lang) is required");
            return;
        }
        String path = "languages/" + urlEncode(language) + "/capabilities";
        proxyGet(path, null, request, response);
    }

    private void proxyExecute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String body = readRequestBody(request);
        if (body == null || body.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Request body is required");
            return;
        }

        String url = vizUrl("execute", null);
        try {
            UpstreamResponse upstream = makePostRequest(url, body);
            sendJsonResponse(response, upstream.statusCode, upstream.body);
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY,
                    "Failed to run visualization: " + e.getMessage());
        }
    }

    /** GET passthrough to {@code /crypto/<path>} (cached like the other viz metadata). */
    private void proxyCryptoGet(String path, String query, HttpServletResponse response) throws IOException {
        String cacheKey = "crypto/" + ((query == null || query.isEmpty()) ? path : path + "?" + query);
        UpstreamResponse cached = GET_CACHE.get(cacheKey);
        if (cached != null) {
            sendJsonResponse(response, cached.statusCode, cached.body);
            return;
        }
        try {
            UpstreamResponse upstream = makeGetRequest(cryptoUrl(path, query));
            if (upstream.statusCode >= 200 && upstream.statusCode < 300) {
                GET_CACHE.put(cacheKey, upstream);
            }
            sendJsonResponse(response, upstream.statusCode, upstream.body);
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY, "Crypto API request failed: " + e.getMessage());
        }
    }

    /** GET /crypto/trace — forwards algorithm/mode/message/key as query params (never cached). */
    private void proxyCryptoTraceGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder q = new StringBuilder();
        appendParam(q, "algorithm", request.getParameter("algorithm"));
        appendParam(q, "mode", request.getParameter("mode"));
        appendParam(q, "message", request.getParameter("message"));
        appendParam(q, "key", request.getParameter("key"));
        try {
            UpstreamResponse upstream = makeGetRequest(cryptoUrl("trace", q.length() == 0 ? null : q.toString()));
            sendJsonResponse(response, upstream.statusCode, upstream.body);
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY, "Crypto trace failed: " + e.getMessage());
        }
    }

    /** POST /crypto/trace — forwards the JSON body verbatim. */
    private void proxyCryptoTracePost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String body = readRequestBody(request);
        if (body == null || body.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Request body is required");
            return;
        }
        try {
            UpstreamResponse upstream = makePostRequest(cryptoUrl("trace", null), body);
            sendJsonResponse(response, upstream.statusCode, upstream.body);
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY, "Crypto trace failed: " + e.getMessage());
        }
    }

    private void appendParam(StringBuilder q, String name, String value) {
        if (value == null || value.isEmpty()) {
            return;
        }
        if (q.length() > 0) {
            q.append('&');
        }
        q.append(name).append('=').append(urlEncode(value));
    }

    private String cryptoUrl(String path, String query) {
        StringBuilder url = new StringBuilder();
        url.append(ensureTrailingSlash(getApiBase())).append("crypto/").append(path);
        if (query != null && !query.isEmpty()) {
            url.append('?').append(query);
        }
        return url.toString();
    }

    private void proxyGet(String path, String query, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String cacheKey = (query == null || query.isEmpty()) ? path : path + "?" + query;
        UpstreamResponse cached = GET_CACHE.get(cacheKey);
        if (cached != null) {
            sendJsonResponse(response, cached.statusCode, cached.body);
            return;
        }
        String url = vizUrl(path, query);
        try {
            UpstreamResponse upstream = makeGetRequest(url);
            // Cache only successful responses (errors are transient — don't pin them).
            if (upstream.statusCode >= 200 && upstream.statusCode < 300) {
                GET_CACHE.put(cacheKey, upstream);
            }
            sendJsonResponse(response, upstream.statusCode, upstream.body);
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY,
                    "Viz API request failed: " + e.getMessage());
        }
    }

    private String vizUrl(String path, String query) {
        StringBuilder url = new StringBuilder();
        url.append(ensureTrailingSlash(getApiBase())).append("viz/").append(path);
        if (query != null && !query.isEmpty()) {
            url.append('?').append(query);
        }
        return url.toString();
    }

    private String getApiBase() {
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("onecompiler");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        return apiBase;
    }

    private String getApiKey() {
        String apiKey = System.getenv("ONE_COMPILER_API_KEY");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        apiKey = LoadPropertyFileFunctionality.getConfigProperty().get("ONE_COMPILER_API_KEY");
        return apiKey != null ? apiKey : "";
    }

    private String ensureTrailingSlash(String base) {
        return base.endsWith("/") ? base : base + "/";
    }

    private String urlEncode(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (java.io.UnsupportedEncodingException e) {
            throw new IllegalStateException(e);
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

    private UpstreamResponse makeGetRequest(String urlString) throws IOException {
        HttpURLConnection conn = null;
        try {
            conn = openConnection(urlString, "GET");
            int status = conn.getResponseCode();
            String body = readResponse(status >= 200 && status < 300
                    ? conn.getInputStream()
                    : conn.getErrorStream());
            return new UpstreamResponse(status, body != null ? body : "");
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private UpstreamResponse makePostRequest(String urlString, String body) throws IOException {
        HttpURLConnection conn = null;
        try {
            conn = openConnection(urlString, "POST");
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = body.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int status = conn.getResponseCode();
            String responseBody = readResponse(status >= 200 && status < 300
                    ? conn.getInputStream()
                    : conn.getErrorStream());
            return new UpstreamResponse(status, responseBody != null ? responseBody : "");
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private HttpURLConnection openConnection(String urlString, String method) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlString).openConnection();
        conn.setRequestMethod(method);
        conn.setConnectTimeout(CONNECT_TIMEOUT);
        conn.setReadTimeout(READ_TIMEOUT);
        conn.setRequestProperty("Accept", "application/json");
        if ("POST".equals(method)) {
            conn.setRequestProperty("Content-Type", "application/json");
        }
        String apiKey = getApiKey();
        if (!apiKey.isEmpty()) {
            conn.setRequestProperty("X-API-Key", apiKey);
        }
        return conn;
    }

    private String readResponse(InputStream inputStream) throws IOException {
        if (inputStream == null) {
            return "";
        }
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

    private void sendJsonResponse(HttpServletResponse response, int status, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        response.setHeader("Access-Control-Allow-Origin", "*");
        try (PrintWriter writer = response.getWriter()) {
            writer.write(json != null ? json : "");
        }
    }

    private void sendError(HttpServletResponse response, int status, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        response.setHeader("Access-Control-Allow-Origin", "*");
        String errorJson = "{\"error\": \"" + escapeJson(message) + "\"}";
        try (PrintWriter writer = response.getWriter()) {
            writer.write(errorJson);
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private static final class UpstreamResponse {
        private final int statusCode;
        private final String body;

        private UpstreamResponse(int statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
    }
}
