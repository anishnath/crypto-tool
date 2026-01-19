package z.y.x.Security;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * Google OAuth Servlet - Handles Google OAuth 2.0 authentication flow
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 * 
 * Environment Variables Required:
 * - GOOGLE_OAUTH_CLIENT_ID
 * - GOOGLE_OAUTH_CLIENT_SECRET
 */
public class GoogleOAuthFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Google OAuth endpoints
    private static final String GOOGLE_AUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USERINFO_ENDPOINT = "https://www.googleapis.com/oauth2/v2/userinfo";
    
    // OAuth scopes
    private static final String SCOPE_PROFILE = "https://www.googleapis.com/auth/userinfo.profile";
    private static final String SCOPE_EMAIL = "https://www.googleapis.com/auth/userinfo.email";
    private static final String SCOPE_OPENID = "openid";
    
    // Session attribute keys
    private static final String SESSION_STATE = "oauth_state";
    private static final String SESSION_ACCESS_TOKEN = "oauth_access_token";
    private static final String SESSION_REFRESH_TOKEN = "oauth_refresh_token";
    private static final String SESSION_REDIRECT_PATH = "oauth_redirect_path";
    private static final String SESSION_USER_INFO = "oauth_user_info";
    private static final String SESSION_USER_SUB = "oauth_user_sub";
    private static final String SESSION_USER_EMAIL = "oauth_user_email";
    
    private final Gson gson = new Gson();
    
    /**
     * Get client ID from environment variable
     */
    private String getClientId() {
        String clientId = System.getenv("GOOGLE_OAUTH_CLIENT_ID");
        if (clientId == null || clientId.trim().isEmpty()) {
            throw new IllegalStateException("GOOGLE_OAUTH_CLIENT_ID environment variable is not set");
        }
        return clientId;
    }
    
    /**
     * Get client secret from environment variable
     */
    private String getClientSecret() {
        String clientSecret = System.getenv("GOOGLE_OAUTH_CLIENT_SECRET");
        if (clientSecret == null || clientSecret.trim().isEmpty()) {
            throw new IllegalStateException("GOOGLE_OAUTH_CLIENT_SECRET environment variable is not set");
        }
        return clientSecret;
    }
    
    /**
     * Generate a random state string for CSRF protection
     */
    private String generateState() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    
    /**
     * Build redirect URI based on request
     * Uses the callback path which is always the same
     */
    private String getRedirectUri(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder redirectUri = new StringBuilder();
        redirectUri.append(scheme).append("://").append(serverName);
        if ((scheme.equals("http") && serverPort != 80) || 
            (scheme.equals("https") && serverPort != 443)) {
            redirectUri.append(":").append(serverPort);
        }
        redirectUri.append(contextPath).append("/GoogleOAuthFunctionality?action=callback");
        
        return redirectUri.toString();
    }
    
    /**
     * Get the path to redirect to after successful authentication
     * Defaults to root if not specified
     */
    private String getRedirectPath(HttpServletRequest request) {
        String redirectPath = request.getParameter("redirect_path");
        if (redirectPath == null || redirectPath.trim().isEmpty()) {
            // Try to get from referrer or default to root
            String referer = request.getHeader("Referer");
            if (referer != null) {
                try {
                    java.net.URL refererUrl = new java.net.URL(referer);
                    String path = refererUrl.getPath();
                    String contextPath = request.getContextPath();
                    if (path.startsWith(contextPath)) {
                        redirectPath = path.substring(contextPath.length());
                        if (redirectPath.isEmpty()) {
                            redirectPath = "/";
                        }
                    }
                } catch (Exception e) {
                    // Ignore, use default
                }
            }
            if (redirectPath == null || redirectPath.trim().isEmpty()) {
                redirectPath = "/";
            }
        }
        // Ensure it starts with /
        if (!redirectPath.startsWith("/")) {
            redirectPath = "/" + redirectPath;
        }
        return redirectPath;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "login"; // Default action
        }
        
        // For login and logout actions, we redirect, so don't set content type yet
        if (!"login".equalsIgnoreCase(action) && !"logout".equalsIgnoreCase(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        }
        PrintWriter out = response.getWriter();
        
        try {
            switch (action.toLowerCase()) {
                case "login":
                    handleLogin(request, response);
                    return; // Already redirected
                case "callback":
                    handleCallback(request, response);
                    return; // Already redirected or handled
                case "logout":
                    handleLogout(request, response);
                    return; // Already redirected
                case "userinfo":
                    handleUserInfo(request, response);
                    break;
                case "check_session":
                    handleCheckSession(request, response);
                    break;
                default:
                    Map<String, Object> error = new HashMap<>();
                    error.put("error", "invalid_action");
                    error.put("message", "Unknown action: " + action);
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
     * Handle login - redirect to Google OAuth
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        String state = generateState();
        session.setAttribute(SESSION_STATE, state);
        
        // Store the redirect path for after authentication
        String redirectPath = getRedirectPath(request);
        session.setAttribute(SESSION_REDIRECT_PATH, redirectPath);
        
        String clientId = getClientId();
        String redirectUri = getRedirectUri(request);
        String scope = SCOPE_OPENID + " " + SCOPE_PROFILE + " " + SCOPE_EMAIL;
        
        // Build authorization URL
        StringBuilder authUrl = new StringBuilder(GOOGLE_AUTH_ENDPOINT);
        authUrl.append("?client_id=").append(URLEncoder.encode(clientId, "UTF-8"));
        authUrl.append("&redirect_uri=").append(URLEncoder.encode(redirectUri, "UTF-8"));
        authUrl.append("&response_type=code");
        authUrl.append("&scope=").append(URLEncoder.encode(scope, "UTF-8"));
        authUrl.append("&state=").append(URLEncoder.encode(state, "UTF-8"));
        authUrl.append("&access_type=offline"); // Request refresh token
        authUrl.append("&prompt=consent"); // Force consent screen to get refresh token
        
        response.sendRedirect(authUrl.toString());
    }
    
    /**
     * Handle OAuth callback - exchange authorization code for tokens
     */
    private void handleCallback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        
        // Verify state
        String state = request.getParameter("state");
        String sessionState = (String) session.getAttribute(SESSION_STATE);
        
        if (sessionState == null || !sessionState.equals(state)) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "invalid_state");
            error.put("message", "Invalid state parameter. Possible CSRF attack.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println(gson.toJson(error));
            return;
        }
        
        // Clear state from session
        session.removeAttribute(SESSION_STATE);
        
        // Get authorization code
        String code = request.getParameter("code");
        String errorParam = request.getParameter("error");
        
        if (errorParam != null) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", errorParam);
            error.put("message", request.getParameter("error_description"));
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println(gson.toJson(error));
            return;
        }
        
        if (code == null || code.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "missing_code");
            error.put("message", "Authorization code is missing");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println(gson.toJson(error));
            return;
        }
        
        // Exchange code for tokens
        try {
            String clientId = getClientId();
            String clientSecret = getClientSecret();
            String redirectUri = getRedirectUri(request);
            
            // Build token request
            StringBuilder tokenRequest = new StringBuilder();
            tokenRequest.append("grant_type=authorization_code");
            tokenRequest.append("&code=").append(URLEncoder.encode(code, "UTF-8"));
            tokenRequest.append("&redirect_uri=").append(URLEncoder.encode(redirectUri, "UTF-8"));
            tokenRequest.append("&client_id=").append(URLEncoder.encode(clientId, "UTF-8"));
            tokenRequest.append("&client_secret=").append(URLEncoder.encode(clientSecret, "UTF-8"));
            
            // Make token request
            java.net.URL url = new java.net.URL(GOOGLE_TOKEN_ENDPOINT);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            
            try (java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = tokenRequest.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == 200) {
                // Read response
                StringBuilder responseBody = new StringBuilder();
                try (java.io.BufferedReader br = new java.io.BufferedReader(
                        new java.io.InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBody.append(responseLine.trim());
                    }
                }
                
                // Parse JSON response
                @SuppressWarnings("unchecked")
                Map<String, Object> tokenResponse = gson.fromJson(responseBody.toString(), Map.class);
                
                // Store tokens in session
                String accessToken = null;
                if (tokenResponse.containsKey("access_token")) {
                    accessToken = (String) tokenResponse.get("access_token");
                    session.setAttribute(SESSION_ACCESS_TOKEN, accessToken);
                }
                if (tokenResponse.containsKey("refresh_token")) {
                    session.setAttribute(SESSION_REFRESH_TOKEN, tokenResponse.get("refresh_token"));
                }
                
                // Automatically fetch user info after successful token exchange
                if (accessToken != null) {
                    try {
                        Map<String, Object> userInfo = fetchUserInfo(accessToken);
                        if (userInfo != null) {
                            // Store full user info in session
                            session.setAttribute(SESSION_USER_INFO, userInfo);
                            
                            // Store user ID and email separately for easy access
                            // Google OAuth returns 'id' field, OIDC returns 'sub' - check both
                            String visitorId = null;
                            if (userInfo.containsKey("sub")) {
                                Object subValue = userInfo.get("sub");
                                if (subValue != null) {
                                    visitorId = subValue.toString();
                                }
                            }
                            if (visitorId == null && userInfo.containsKey("id")) {
                                Object idValue = userInfo.get("id");
                                if (idValue != null) {
                                    visitorId = idValue.toString();
                                }
                            }
                            if (visitorId != null) {
                                session.setAttribute(SESSION_USER_SUB, visitorId);
                                System.out.println("OAuth: Stored userId (sub/id): " + visitorId);
                            } else {
                                System.out.println("OAuth: No 'sub' or 'id' found. Available keys: " + userInfo.keySet());
                            }
                            if (userInfo.containsKey("email")) {
                                Object emailValue = userInfo.get("email");
                                if (emailValue != null) {
                                    session.setAttribute(SESSION_USER_EMAIL, emailValue.toString());
                                    System.out.println("OAuth: Stored userEmail: " + emailValue.toString());
                                }
                            }
                        } else {
                            System.out.println("OAuth: fetchUserInfo returned null");
                        }
                    } catch (Exception e) {
                        // Log error but don't fail the authentication flow
                        System.err.println("Failed to fetch user info: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                // Get redirect path from session and redirect user
                String redirectPath = (String) session.getAttribute(SESSION_REDIRECT_PATH);
                if (redirectPath == null || redirectPath.isEmpty()) {
                    redirectPath = "/";
                }
                session.removeAttribute(SESSION_REDIRECT_PATH);
                
                // Build full redirect URL
                String scheme = request.getScheme();
                String serverName = request.getServerName();
                int serverPort = request.getServerPort();
                String contextPath = request.getContextPath();
                
                StringBuilder fullRedirectUrl = new StringBuilder();
                fullRedirectUrl.append(scheme).append("://").append(serverName);
                if ((scheme.equals("http") && serverPort != 80) || 
                    (scheme.equals("https") && serverPort != 443)) {
                    fullRedirectUrl.append(":").append(serverPort);
                }
                fullRedirectUrl.append(contextPath).append(redirectPath);
                
                // Redirect to the original path
                response.sendRedirect(fullRedirectUrl.toString());
                return;
            } else {
                // Read error response
                StringBuilder errorBody = new StringBuilder();
                try (java.io.BufferedReader br = new java.io.BufferedReader(
                        new java.io.InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        errorBody.append(responseLine.trim());
                    }
                }
                
                Map<String, Object> error = new HashMap<>();
                error.put("error", "token_exchange_failed");
                error.put("message", "Failed to exchange authorization code for tokens");
                error.put("details", errorBody.toString());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println(gson.toJson(error));
            }
            
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "token_exchange_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        }
    }
    
    /**
     * Fetch user info from Google using access token
     * Returns a Map with user information including 'sub' and 'email'
     */
    private Map<String, Object> fetchUserInfo(String accessToken) throws IOException {
        // Make userinfo request
        java.net.URL url = new java.net.URL(GOOGLE_USERINFO_ENDPOINT);
        java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == 200) {
            // Read response
            StringBuilder responseBody = new StringBuilder();
            try (java.io.BufferedReader br = new java.io.BufferedReader(
                    new java.io.InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseBody.append(responseLine.trim());
                }
            }
            
            // Parse and return user info
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = gson.fromJson(responseBody.toString(), Map.class);
            System.out.println("OAuth: Fetched user info: " + userInfo);
            return userInfo;
        } else {
            // Read error response for debugging
            StringBuilder errorBody = new StringBuilder();
            try (java.io.InputStream errorStream = conn.getErrorStream();
                 java.io.BufferedReader br = errorStream != null ? 
                     new java.io.BufferedReader(new java.io.InputStreamReader(errorStream, StandardCharsets.UTF_8)) : null) {
                if (br != null) {
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        errorBody.append(responseLine.trim());
                    }
                }
            }
            throw new IOException("Failed to fetch user info. Response code: " + responseCode + 
                (errorBody.length() > 0 ? ", Error: " + errorBody.toString() : ""));
        }
    }
    
    /**
     * Handle user info request - get user information using access token
     */
    private void handleUserInfo(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        
        // First try to get from session (if already fetched)
        @SuppressWarnings("unchecked")
        Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute(SESSION_USER_INFO);
        
        if (userInfo != null) {
            // Return cached user info
            out.println(gson.toJson(userInfo));
            return;
        }
        
        // If not in session, fetch using access token
        String accessToken = (String) session.getAttribute(SESSION_ACCESS_TOKEN);
        
        if (accessToken == null || accessToken.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "not_authenticated");
            error.put("message", "No access token found. Please authenticate first.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.println(gson.toJson(error));
            return;
        }
        
        try {
            userInfo = fetchUserInfo(accessToken);
            
            // Store in session for future use
            session.setAttribute(SESSION_USER_INFO, userInfo);
            // Google OAuth returns 'id' field, OIDC returns 'sub' - check both
            String visitorId = null;
            if (userInfo.containsKey("sub")) {
                visitorId = (String) userInfo.get("sub");
            }
            if (visitorId == null && userInfo.containsKey("id")) {
                visitorId = String.valueOf(userInfo.get("id"));
            }
            if (visitorId != null) {
                session.setAttribute(SESSION_USER_SUB, visitorId);
            }
            if (userInfo.containsKey("email")) {
                session.setAttribute(SESSION_USER_EMAIL, userInfo.get("email"));
            }
            
            out.println(gson.toJson(userInfo));
            
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "userinfo_error");
            error.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println(gson.toJson(error));
        }
    }
    
    /**
     * Handle session check request
     * Returns JSON with logged_in status
     */
    private void handleCheckSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        Map<String, Object> result = new HashMap<>();
        
        if (session != null) {
            String userSub = (String) session.getAttribute(SESSION_USER_SUB);
            String userEmail = (String) session.getAttribute(SESSION_USER_EMAIL);
            // User is logged in if either userSub OR userEmail exists (some OAuth flows may only set email)
            boolean isLoggedIn = (userSub != null && !userSub.isEmpty()) || (userEmail != null && !userEmail.isEmpty());
            result.put("logged_in", isLoggedIn);
            if (isLoggedIn) {
                if (userSub != null) {
                    result.put("user_sub", userSub);
                }
                if (userEmail != null) {
                    result.put("user_email", userEmail);
                }
            }
        } else {
            result.put("logged_in", false);
        }
        
        PrintWriter out = response.getWriter();
        out.println(gson.toJson(result));
    }
    
    /**
     * Handle logout - clear session and redirect
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        
        // Get redirect path from request parameter or default to root
        String redirectPath = request.getParameter("redirect_path");
        if (redirectPath == null || redirectPath.trim().isEmpty()) {
            // Try to get from referrer
            String referer = request.getHeader("Referer");
            if (referer != null) {
                try {
                    java.net.URL refererUrl = new java.net.URL(referer);
                    String path = refererUrl.getPath();
                    String contextPath = request.getContextPath();
                    if (path.startsWith(contextPath)) {
                        redirectPath = path.substring(contextPath.length());
                        if (redirectPath.isEmpty()) {
                            redirectPath = "/";
                        }
                    }
                } catch (Exception e) {
                    // Ignore, use default
                }
            }
            if (redirectPath == null || redirectPath.trim().isEmpty()) {
                redirectPath = "/";
            }
        }
        
        // Clear session
        session.removeAttribute(SESSION_ACCESS_TOKEN);
        session.removeAttribute(SESSION_REFRESH_TOKEN);
        session.removeAttribute(SESSION_STATE);
        session.removeAttribute(SESSION_USER_INFO);
        session.removeAttribute(SESSION_USER_SUB);
        session.removeAttribute(SESSION_USER_EMAIL);
        session.removeAttribute(SESSION_REDIRECT_PATH);
        
        // Build full redirect URL
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder fullRedirectUrl = new StringBuilder();
        fullRedirectUrl.append(scheme).append("://").append(serverName);
        if ((scheme.equals("http") && serverPort != 80) || 
            (scheme.equals("https") && serverPort != 443)) {
            fullRedirectUrl.append(":").append(serverPort);
        }
        fullRedirectUrl.append(contextPath).append(redirectPath);
        
        // Redirect to the original path
        response.sendRedirect(fullRedirectUrl.toString());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST requests are redirected to GET
        doGet(request, response);
    }
}

