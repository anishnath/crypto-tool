package z.y.x.exam;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.google.gson.JsonElement;

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
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * CF Exam Marker Servlet - Proxy/Wrapper for CF Exam Marker API
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 * 
 * Environment Variables Required:
 * - CF_EXAM_MARKER_API - Base URL of the CF Exam Marker API (e.g., https://exam-marker.8gwifi.org)
 * - CF_EXAM_MARKER_API_KEY - API key for protected endpoints
 */
public class CFExamMarkerFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final Gson gson = new Gson();
    
    /**
     * Get API base URL from environment variable
     */
    private String getApiBaseUrl() {
        String apiUrl = System.getenv("CF_EXAM_MARKER_API");
        if (apiUrl == null || apiUrl.trim().isEmpty()) {
            throw new IllegalStateException("CF_EXAM_MARKER_API environment variable is not set");
        }
        // Remove trailing slash if present
        if (apiUrl.endsWith("/")) {
            apiUrl = apiUrl.substring(0, apiUrl.length() - 1);
        }
        //System.out.println("CFExamMarkerFunctionality: resolved CF_EXAM_MARKER_API=" + apiUrl);
        return apiUrl;
    }
    
    /**
     * Get API key from environment variable
     */
    private String getApiKey() {
        String apiKey = System.getenv("CF_EXAM_MARKER_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IllegalStateException("CF_EXAM_MARKER_API_KEY environment variable is not set");
        }
        String keySuffix = apiKey.length() > 4 ? apiKey.substring(apiKey.length() - 4) : apiKey;
        System.out.println("CFExamMarkerFunctionality: resolved CF_EXAM_MARKER_API_KEY=****" + keySuffix);
        return apiKey;
    }
    
    /**
     * Check if endpoint requires API key
     */
    private boolean requiresApiKey(String path) {
        // Protected endpoints that require X-API-Key header
        return path.contains("/api/user/") ||
               path.contains("/api/attempts/") && path.contains("/submit") ||
               path.contains("/api/mark") ||
               path.contains("/api/mark-batch") ||
               path.contains("/api/mark-exam") ||
               path.contains("/api/math-steps");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "proxy"; // Default action
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action.toLowerCase()) {
                case "proxy":
                    handleProxy(request, response, "GET");
                    return;
                case "health":
                    handleHealthCheck(request, response);
                    break;
                case "chapters":
                    handleChapters(request, response);
                    break;
                case "topics":
                    handleTopics(request, response);
                    break;
                case "sets":
                    handleSets(request, response);
                    break;
                case "set":
                    handleSet(request, response);
                    break;
                case "questions":
                    handleQuestions(request, response);
                    break;
                case "attempt":
                    handleAttempt(request, response);
                    break;
                case "user_attempts":
                    handleUserAttempts(request, response);
                    break;
                default:
                    Map<String, Object> error = new HashMap<>();
                    error.put("error", "invalid_action");
                    error.put("message", "Unknown action: " + action);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.println(gson.toJson(error));
            }
        } catch (IllegalStateException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "configuration_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "server_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "proxy"; // Default action
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action.toLowerCase()) {
                case "proxy":
                    handleProxy(request, response, "POST");
                    return;
                case "start_attempt":
                    handleStartAttempt(request, response);
                    break;
                case "save_answers":
                    handleSaveAnswers(request, response);
                    break;
                case "submit":
                    handleSubmit(request, response);
                    break;
                case "mark":
                    handleMark(request, response);
                    break;
                case "mark_batch":
                    handleMarkBatch(request, response);
                    break;
                case "mark_exam":
                    handleMarkExam(request, response);
                    break;
                case "math_steps":
                    handleMathSteps(request, response);
                    break;
                case "upsert_user":
                    handleUpsertUser(request, response);
                    break;
                default:
                    Map<String, Object> error = new HashMap<>();
                    error.put("error", "invalid_action");
                    error.put("message", "Unknown action: " + action);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.println(gson.toJson(error));
            }
        } catch (IllegalStateException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "configuration_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "server_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        }
    }
    
    /**
     * Generic proxy handler - forwards request to CF Exam Marker API
     */
    private void handleProxy(HttpServletRequest request, HttpServletResponse response, String method) 
            throws IOException {
        
        String apiPath = request.getParameter("path");
        if (apiPath == null || apiPath.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_path");
            error.put("message", "Path parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        
        // Build query string from request parameters (excluding 'action' and 'path')
        StringBuilder queryString = new StringBuilder();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (!paramName.equals("action") && !paramName.equals("path")) {
                if (queryString.length() > 0) {
                    queryString.append("&");
                }
                queryString.append(paramName).append("=")
                    .append(java.net.URLEncoder.encode(request.getParameter(paramName), "UTF-8"));
            }
        }
        
        String fullUrl = getApiBaseUrl() + apiPath;
        if (queryString.length() > 0) {
            fullUrl += "?" + queryString.toString();
        }
        
        makeApiRequest(fullUrl, method, request, response, requiresApiKey(apiPath));
    }
    
    /**
     * Health check endpoint
     */
    private void handleHealthCheck(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        makeApiRequest(getApiBaseUrl() + "/health", "GET", request, response, false);
    }
    
    /**
     * List chapters
     */
    private void handleChapters(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        StringBuilder url = new StringBuilder(getApiBaseUrl() + "/api/chapters");
        String queryString = buildQueryString(request, "action");
        if (queryString.length() > 0) {
            url.append("?").append(queryString);
        }
        makeApiRequest(url.toString(), "GET", request, response, false);
    }
    
    /**
     * List topics for a chapter
     */
    private void handleTopics(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String chapterId = request.getParameter("chapter_id");
        if (chapterId == null || chapterId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_chapter_id");
            error.put("message", "chapter_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        makeApiRequest(getApiBaseUrl() + "/api/chapters/" + chapterId + "/topics", "GET", request, response, false);
    }
    
    /**
     * List exam sets
     */
    private void handleSets(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        StringBuilder url = new StringBuilder(getApiBaseUrl() + "/api/sets");
        String queryString = buildQueryString(request, "action");
        if (queryString.length() > 0) {
            url.append("?").append(queryString);
        }
        System.out.println("CFExamMarkerFunctionality: handleSets -> " + url);
        makeApiRequest(url.toString(), "GET", request, response, false);
    }
    
    /**
     * Get single exam set
     */
    private void handleSet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String setId = request.getParameter("set_id");
        if (setId == null || setId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_set_id");
            error.put("message", "set_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        makeApiRequest(getApiBaseUrl() + "/api/sets/" + setId, "GET", request, response, false);
    }
    
    /**
     * Get questions for a set
     */
    private void handleQuestions(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String setId = request.getParameter("set_id");
        if (setId == null || setId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_set_id");
            error.put("message", "set_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        makeApiRequest(getApiBaseUrl() + "/api/sets/" + setId + "/questions", "GET", request, response, false);
    }
    
    /**
     * Get attempt details
     */
    private void handleAttempt(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String attemptId = request.getParameter("attempt_id");
        if (attemptId == null || attemptId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_attempt_id");
            error.put("message", "attempt_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        makeApiRequest(getApiBaseUrl() + "/api/attempts/" + attemptId, "GET", request, response, false);
    }
    
    /**
     * Get user's test history
     */
    private void handleUserAttempts(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String userId = request.getParameter("user_id");
        if (userId == null || userId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_user_id");
            error.put("message", "user_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        StringBuilder url = new StringBuilder(getApiBaseUrl() + "/api/user/" + userId + "/attempts");
        String queryString = buildQueryString(request, "action", "user_id");
        if (queryString.length() > 0) {
            url.append("?").append(queryString);
        }
        makeApiRequest(url.toString(), "GET", request, response, true);
    }
    
    /**
     * Start new test attempt
     */
    private void handleStartAttempt(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            String requestBody = readRequestBody(request);
            System.out.println("Start attempt - Request body: " + requestBody);
            String apiUrl = getApiBaseUrl() + "/api/attempts";
            System.out.println("Start attempt - API URL: " + apiUrl);
            makeApiRequest(apiUrl, "POST", requestBody, response, false);
        } catch (Exception e) {
            System.err.println("Error in handleStartAttempt: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "start_attempt_failed");
            error.put("message", e.getMessage() != null ? e.getMessage() : "Failed to start attempt");
            out.println(gson.toJson(error));
        }
    }
    
    /**
     * Save answers
     */
    private void handleSaveAnswers(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String attemptId = request.getParameter("attempt_id");
        if (attemptId == null || attemptId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_attempt_id");
            error.put("message", "attempt_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        String requestBody = readRequestBody(request);
        makeApiRequest(getApiBaseUrl() + "/api/attempts/" + attemptId + "/answers", "POST", requestBody, response, false);
    }
    
    /**
     * Submit attempt for grading
     */
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String attemptId = request.getParameter("attempt_id");
        if (attemptId == null || attemptId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_attempt_id");
            error.put("message", "attempt_id parameter is required");
            out.println(gson.toJson(error));
            return;
        }
        makeApiRequest(getApiBaseUrl() + "/api/attempts/" + attemptId + "/submit", "POST", (String) null, response, true);
    }
    
    /**
     * Mark single answer
     */
    private void handleMark(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String requestBody = readRequestBody(request);
        makeApiRequest(getApiBaseUrl() + "/api/mark", "POST", requestBody, response, true);
    }
    
    /**
     * Batch mark (up to 10 questions)
     */
    private void handleMarkBatch(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String requestBody = readRequestBody(request);
        makeApiRequest(getApiBaseUrl() + "/api/mark-batch", "POST", requestBody, response, true);
    }
    
    /**
     * Mark full exam
     */
    private void handleMarkExam(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);
        makeApiRequest(getApiBaseUrl() + "/api/mark-exam", "POST", requestBody, response, true);
    }

    // ---- Math steps validation constants ----
    private static final Set<String> ALLOWED_OPERATIONS = new HashSet<>(
            Arrays.asList("integrate", "differentiate", "limit", "simplify", "solve", "logarithm", "linear_system"));
    private static final Set<String> ALLOWED_VARIABLES = new HashSet<>(
            Arrays.asList("x", "y", "t", "u", "z", "r", "s", "n"));
    private static final Set<String> ALLOWED_MODES = new HashSet<>(
            Arrays.asList("solve", "expand", "condense", "simplify", "evaluate", "gaussian", "gauss_jordan", "lu", "cramer", "inverse", "least_squares"));
    // Only math characters: digits, letters, operators, parens, dots, spaces, *, /, ^, =, _, etc.
    private static final Pattern MATH_EXPR_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9\\s\\+\\-\\*/\\^\\(\\)\\.,|\\\\!=_]+$");
    // Bounds: simple number or math const like pi, e, -3, 2.5, pi/2, sqrt(2)
    private static final Pattern BOUND_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9\\s\\+\\-\\*/\\^\\(\\)\\.]+$");
    private static final int MAX_EXPR_LENGTH = 200;
    private static final int MAX_ANSWER_LENGTH = 500;
    private static final int MAX_BOUND_LENGTH = 30;

    /**
     * Math step-by-step solutions (generic - integrals, derivatives, etc.)
     * Validates all input before proxying to CF Worker to prevent spam/abuse.
     */
    private void handleMathSteps(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);

        // Parse and validate JSON
        JsonObject payload;
        try {
            JsonElement parsed = new JsonParser().parse(requestBody);
            payload = parsed.getAsJsonObject();
        } catch (JsonSyntaxException | IllegalStateException e) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_json", "Request body must be valid JSON");
            return;
        }

        // 1. expression (required, must look like math)
        String expression = getJsonString(payload, "expression");
        if (expression == null || expression.isEmpty()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "missing_field", "expression is required");
            return;
        }
        if (expression.length() > MAX_EXPR_LENGTH) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "expression too long (max " + MAX_EXPR_LENGTH + " chars)");
            return;
        }
        if (!MATH_EXPR_PATTERN.matcher(expression).matches()) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "expression contains invalid characters");
            return;
        }

        // 2. operation (optional, must be from whitelist) — parsed before answer since answer is optional for logarithm
        String operation = getJsonString(payload, "operation");
        if (operation != null && !operation.isEmpty() && !ALLOWED_OPERATIONS.contains(operation)) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "operation must be one of: " + ALLOWED_OPERATIONS);
            return;
        }

        // 3. answer (required for most operations, optional for logarithm)
        String answer = getJsonString(payload, "answer");
        boolean isLogarithm = "logarithm".equals(operation);
        boolean isLinearSystem = "linear_system".equals(operation);
        if (!isLogarithm && !isLinearSystem && (answer == null || answer.isEmpty())) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "missing_field", "answer is required");
            return;
        }
        if (answer != null && !answer.isEmpty()) {
            if (answer.length() > MAX_ANSWER_LENGTH) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "answer too long (max " + MAX_ANSWER_LENGTH + " chars)");
                return;
            }
            if (!MATH_EXPR_PATTERN.matcher(answer).matches()) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "answer contains invalid characters");
                return;
            }
        }

        // 4. variable (optional, single letter from whitelist)
        String variable = getJsonString(payload, "variable");
        if (variable != null && !variable.isEmpty() && !ALLOWED_VARIABLES.contains(variable)) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "variable must be one of: " + ALLOWED_VARIABLES);
            return;
        }

        // 5. mode (optional, for logarithm — must be from whitelist)
        String mode = getJsonString(payload, "mode");
        if (mode != null && !mode.isEmpty() && !ALLOWED_MODES.contains(mode)) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "mode must be one of: " + ALLOWED_MODES);
            return;
        }

        // 6. bounds (optional object with lower/upper)
        if (payload.has("bounds") && !payload.get("bounds").isJsonNull()) {
            try {
                JsonObject bounds = payload.getAsJsonObject("bounds");
                String lower = getJsonString(bounds, "lower");
                String upper = getJsonString(bounds, "upper");

                if (lower != null && (lower.length() > MAX_BOUND_LENGTH || !BOUND_PATTERN.matcher(lower).matches())) {
                    sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "bounds.lower is invalid");
                    return;
                }
                if (upper != null && (upper.length() > MAX_BOUND_LENGTH || !BOUND_PATTERN.matcher(upper).matches())) {
                    sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "bounds.upper is invalid");
                    return;
                }
            } catch (Exception e) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "invalid_field", "bounds must be an object with lower and upper");
                return;
            }
        }

        // All checks passed — forward to CF Worker
        makeApiRequest(getApiBaseUrl() + "/api/math-steps", "POST", requestBody, response, true);
    }

    /**
     * Helper: get a string value from JsonObject (returns null if missing or not a string)
     */
    private String getJsonString(JsonObject obj, String key) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) return null;
        try {
            return obj.get(key).getAsString().trim();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Helper: send a JSON error response
     */
    private void sendError(HttpServletResponse response, int status, String error, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("error", error);
        errorMap.put("message", message);
        out.println(gson.toJson(errorMap));
    }

    /**
     * Upsert user (create or update)
     */
    private void handleUpsertUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestBody = readRequestBody(request);
        makeApiRequest(getApiBaseUrl() + "/api/users/upsert", "POST", requestBody, response, true);
    }

    /**
     * Build query string from request parameters, excluding specified parameters
     */
    private String buildQueryString(HttpServletRequest request, String... excludeParams) {
        StringBuilder queryString = new StringBuilder();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            boolean exclude = false;
            for (String excludeParam : excludeParams) {
                if (paramName.equals(excludeParam)) {
                    exclude = true;
                    break;
                }
            }
            if (!exclude) {
                if (queryString.length() > 0) {
                    queryString.append("&");
                }
                try {
                    queryString.append(paramName).append("=")
                        .append(java.net.URLEncoder.encode(request.getParameter(paramName), "UTF-8"));
                } catch (java.io.UnsupportedEncodingException e) {
                    // UTF-8 is always supported, but handle it just in case
                    throw new RuntimeException("UTF-8 encoding not supported", e);
                }
            }
        }
        return queryString.toString();
    }
    
    /**
     * Read request body
     */
    private String readRequestBody(HttpServletRequest request) throws IOException {
        try {
            StringBuilder body = new StringBuilder();
            BufferedReader reader = request.getReader();
            if (reader == null) {
                System.err.println("Warning: request.getReader() returned null");
                return "";
            }
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
            return body.toString();
        } catch (IllegalStateException e) {
            // Request body might have already been read
            System.err.println("Warning: Request body may have already been read: " + e.getMessage());
            return "";
        } catch (Exception e) {
            System.err.println("Error reading request body: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Failed to read request body: " + e.getMessage(), e);
        }
    }
    
    /**
     * Make API request (GET)
     */
    private void makeApiRequest(String url, String method, HttpServletRequest request, 
                                HttpServletResponse response, boolean requiresAuth) throws IOException {
        makeApiRequest(url, method, (String) null, response, requiresAuth);
    }
    
    /**
     * Make API request
     */
    private void makeApiRequest(String url, String method, String requestBody, 
                                HttpServletResponse response, boolean requiresAuth) throws IOException {
        
        try {
            System.out.println("CFExamMarkerFunctionality: outbound " + method + " " + url + " auth=" + requiresAuth);
            URL apiUrl = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) apiUrl.openConnection();
            conn.setRequestMethod(method);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");
            
            // Add API key if required
            if (requiresAuth) {
                conn.setRequestProperty("X-API-Key", getApiKey());
            }
            
            // For POST/PUT requests with body
            if ((method.equals("POST") || method.equals("PUT")) && requestBody != null && !requestBody.isEmpty()) {
                conn.setDoOutput(true);
                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                    os.write(input, 0, input.length);
                }
            }
            
            int responseCode = conn.getResponseCode();
            
            // Read response
            StringBuilder responseBody = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    responseCode >= 200 && responseCode < 300 ? conn.getInputStream() : conn.getErrorStream(),
                    StandardCharsets.UTF_8))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseBody.append(responseLine.trim());
                }
            }
            
            // Set response status
            response.setStatus(responseCode);
            
            // Write response
            PrintWriter out = response.getWriter();
            out.println(responseBody.toString());
            
        } catch (Exception e) {
            // Log the full exception for debugging
            System.err.println("API request failed for URL: " + url);
            System.err.println("Method: " + method);
            System.err.println("Exception type: " + e.getClass().getName());
            System.err.println("Exception message: " + e.getMessage());
            e.printStackTrace();
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("error", "api_request_failed");
            error.put("message", e.getMessage() != null ? e.getMessage() : "Internal server error");
            error.put("exception_type", e.getClass().getSimpleName());
            out.println(gson.toJson(error));
        }
    }
}
