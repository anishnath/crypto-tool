package z.y.x.onecompiler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * OneCompiler Servlet - Proxies requests to the OneCompiler backend API.
 *
 * API Documentation Reference: API_DOCUMENTATION.md
 *
 * GET Endpoints:
 * - action=languages                              → GET /languages
 * - action=metadata&lang=X&version=Y              → GET /languages/{lang}/metadata?version=Y
 * - action=templates                              → GET /templates (all templates)
 * - action=template&lang=X                        → GET /templates/{lang}
 * - action=snippet_get&id=X                       → GET /snippets/{id}
 *
 * POST Endpoints:
 * - action=execute                                → POST /execute
 * - action=format                                 → POST /format
 * - action=snippet_create                         → POST /snippets
 * - action=snippet_execute&id=X                   → POST /snippets/{id}/execute
 *
 * DELETE Endpoints:
 * - action=snippet_delete&id=X                    → DELETE /snippets/{id}
 */
public class OneCompilerFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int CONNECT_TIMEOUT = 30000;
    private static final int READ_TIMEOUT = 120000;

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
                getLanguages(request, response);
                break;
            case "metadata":
                getLanguageMetadata(request, response);
                break;
            case "templates":
                getAllTemplates(request, response);
                break;
            case "template":
                getTemplate(request, response);
                break;
            case "snippet_get":
                getSnippet(request, response);
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

        switch (action.toLowerCase()) {
            case "execute":
                executeCode(request, response);
                break;
            case "format":
                formatCode(request, response);
                break;
            case "snippet_create":
                createSnippet(request, response);
                break;
            case "snippet_execute":
                executeSnippet(request, response);
                break;
            case "snippet_delete":
                // Allow DELETE via POST for browsers that don't support DELETE
                deleteSnippet(request, response);
                break;
            default:
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Unknown POST action: " + action);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            // Default to snippet_delete for DELETE method
            action = "snippet_delete";
        }

        if ("snippet_delete".equalsIgnoreCase(action)) {
            deleteSnippet(request, response);
        } else {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Unknown DELETE action: " + action);
        }
    }

    // ==================== GET Endpoints ====================

    /**
     * GET /languages - Get list of supported languages
     * Response: Array of { name, default_version, icon, versions[], metadata }
     */
    private void getLanguages(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "languages";

        try {
            String result = makeGetRequest(url);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to fetch languages: " + e.getMessage());
        }
    }

    /**
     * GET /languages/{language}/metadata?version={version} - Get language metadata
     * Response: { language, version, compilerVersion, os, osVersion, packageVersions }
     */
    private void getLanguageMetadata(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String language = request.getParameter("lang");
        String version = request.getParameter("version");

        if (language == null || language.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Language parameter (lang) is required");
            return;
        }

        String apiBase = getApiBase();
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(ensureTrailingSlash(apiBase))
                  .append("languages/")
                  .append(URLEncoder.encode(language, "UTF-8"))
                  .append("/metadata");

        if (version != null && !version.isEmpty()) {
            urlBuilder.append("?version=").append(URLEncoder.encode(version, "UTF-8"));
        }

        try {
            String result = makeGetRequest(urlBuilder.toString());
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to fetch language metadata: " + e.getMessage());
        }
    }

    /**
     * GET /templates - Get all templates
     * Response: { language1: template1, language2: template2, ... }
     */
    private void getAllTemplates(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "templates";

        try {
            String result = makeGetRequest(url);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to fetch templates: " + e.getMessage());
        }
    }

    /**
     * GET /templates/{language} - Get template for a specific language
     * Response: { language, template }
     */
    private void getTemplate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String language = request.getParameter("lang");

        if (language == null || language.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Language parameter (lang) is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "templates/" + URLEncoder.encode(language, "UTF-8");

        try {
            String result = makeGetRequest(url);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to fetch template: " + e.getMessage());
        }
    }

    /**
     * GET /snippets/{id} - Get a saved snippet
     * Response: { id, title, description, language, version, code/files, input, compilerArgs, createdAt, views, ... }
     */
    private void getSnippet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String snippetId = request.getParameter("id");

        if (snippetId == null || snippetId.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Snippet ID parameter (id) is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "snippets/" + URLEncoder.encode(snippetId, "UTF-8");

        try {
            String result = makeGetRequest(url);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            if (e.getMessage().contains("404")) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Snippet not found: " + snippetId);
            } else {
                sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to fetch snippet: " + e.getMessage());
            }
        }
    }

    // ==================== POST Endpoints ====================

    /**
     * POST /execute - Execute code synchronously
     * Request: { language, version, code/files, input, compilerArgs }
     * Response: { stdout, stderr, exitCode }
     */
    private void executeCode(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);

        if (requestBody == null || requestBody.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Request body is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "execute";

        try {
            String result = makePostRequest(url, requestBody);
            System.out.println(result);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to execute code: " + e.getMessage());
        }
    }

    /**
     * POST /format - Format code
     * Request: { language, version, code }
     * Response: { formattedCode, success, error? }
     */
    private void formatCode(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);

        if (requestBody == null || requestBody.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Request body is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "format";

        try {
            String result = makePostRequest(url, requestBody);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to format code: " + e.getMessage());
        }
    }

    /**
     * POST /snippets - Create a new snippet
     * Request: { language, version, code/files, title, description, input, compilerArgs, expiresIn }
     * Response: { id, url, createdAt, expiresAt }
     */
    private void createSnippet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);

        if (requestBody == null || requestBody.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Request body is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "snippets";

        try {
            String result = makePostRequest(url, requestBody);
            sendJsonResponse(response, HttpServletResponse.SC_CREATED, result);
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Failed to create snippet: " + e.getMessage());
        }
    }

    /**
     * POST /snippets/{id}/execute - Execute a saved snippet
     * Request: { input?, compilerArgs? } (optional overrides)
     * Response: { stdout, stderr, exitCode }
     */
    private void executeSnippet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String snippetId = request.getParameter("id");

        if (snippetId == null || snippetId.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Snippet ID parameter (id) is required");
            return;
        }

        String requestBody = readRequestBody(request);
        // Empty body is OK for snippet execution (uses saved settings)
        if (requestBody == null) {
            requestBody = "{}";
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "snippets/" + URLEncoder.encode(snippetId, "UTF-8") + "/execute";

        try {
            String result = makePostRequest(url, requestBody);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            if (e.getMessage().contains("404")) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Snippet not found: " + snippetId);
            } else {
                sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to execute snippet: " + e.getMessage());
            }
        }
    }

    /**
     * DELETE /snippets/{id} - Delete a snippet
     * Response: { success: true }
     */
    private void deleteSnippet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String snippetId = request.getParameter("id");

        if (snippetId == null || snippetId.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Snippet ID parameter (id) is required");
            return;
        }

        String apiBase = getApiBase();
        String url = ensureTrailingSlash(apiBase) + "snippets/" + URLEncoder.encode(snippetId, "UTF-8");

        try {
            String result = makeDeleteRequest(url);
            sendJsonResponse(response, HttpServletResponse.SC_OK, result);
        } catch (Exception e) {
            if (e.getMessage().contains("404")) {
                sendError(response, HttpServletResponse.SC_NOT_FOUND, "Snippet not found: " + snippetId);
            } else {
                sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to delete snippet: " + e.getMessage());
            }
        }
    }

    // ==================== Helper Methods ====================

    private String getApiBase() {
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("onecompiler");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
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

    private String ensureTrailingSlash(String base) {
        if (base.endsWith("/")) return base;
        return base + "/";
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

    private String makeGetRequest(String urlString) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setRequestProperty("Accept", "application/json");

            // Add API Key header
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                conn.setRequestProperty("X-API-Key", apiKey);
            }

            int responseCode = conn.getResponseCode();

            if (responseCode >= 200 && responseCode < 300) {
                return readResponse(conn.getInputStream());
            } else {
                String errorResponse = readResponse(conn.getErrorStream());
                throw new IOException("API returned status " + responseCode + ": " + errorResponse);
            }
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String makePostRequest(String urlString, String body) throws IOException {
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

            // Add API Key header
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                conn.setRequestProperty("X-API-Key", apiKey);
            }

            // Write request body
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = body.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();

            if (responseCode >= 200 && responseCode < 300) {
                return readResponse(conn.getInputStream());
            } else {
                String errorResponse = readResponse(conn.getErrorStream());
                throw new IOException("API returned status " + responseCode + ": " + errorResponse);
            }
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String makeDeleteRequest(String urlString) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            conn.setRequestProperty("Accept", "application/json");

            // Add API Key header
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) {
                conn.setRequestProperty("X-API-Key", apiKey);
            }

            int responseCode = conn.getResponseCode();

            if (responseCode >= 200 && responseCode < 300) {
                return readResponse(conn.getInputStream());
            } else {
                String errorResponse = readResponse(conn.getErrorStream());
                throw new IOException("API returned status " + responseCode + ": " + errorResponse);
            }
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String readResponse(java.io.InputStream inputStream) throws IOException {
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

    private void sendJsonResponse(HttpServletResponse response, int status, String json)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        response.setHeader("Access-Control-Allow-Origin", "*");

        try (PrintWriter writer = response.getWriter()) {
            writer.write(json);
        }
    }

    private void sendError(HttpServletResponse response, int status, String message)
            throws IOException {
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
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle CORS preflight
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
