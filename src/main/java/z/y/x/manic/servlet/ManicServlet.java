package z.y.x.manic.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * HTTP proxy for the <b>manic</b> render API (hosted by the onecompiler
 * service — see {@code onecompiler/MANIC_API.md}).  The browser talks only to
 * this servlet; the servlet forwards to the upstream API, injecting the
 * server-held API key so the key never reaches the client.
 *
 * <p><b>Entitlement is decided here, server-side.</b>  The browser cannot be
 * trusted to claim a plan, so this servlet derives the caller's plan from their
 * logged-in identity: the OAuth {@code oauth_user_sub} in the session →
 * an active Pro subscription (billing status, same source as
 * {@code AIGatewayProxyServlet}) → {@code plan=pro}, otherwise {@code plan=free}.
 * The plan (and, for logged-in users, a stable {@code userid}) is injected into
 * every upstream call; the client-sent {@code plan} is ignored.  A client that
 * asks for a render tier above its plan is rejected upstream (403).
 *
 * <p>Endpoints (dispatched on {@code ?action=}):
 * <pre>
 *   POST ?action=submit                 → POST {base}/api/manic   (plan+userid injected)
 *   GET  ?action=job&amp;id=N               → GET  {base}/api/manic/jobs/{id}
 *   GET  ?action=jobs&amp;limit=             → GET  {base}/api/manic/jobs?user=&amp;limit=
 *   GET  ?action=files&amp;limit=            → GET  {base}/api/manic/files?user=&amp;limit=
 *   GET  ?action=limits                  → GET  {base}/api/manic/limits?plan=&amp;user=   (CACHED)
 * </pre>
 *
 * <p>Only {@code limits} is cached (per resolved user+plan, briefly, so usage
 * counts stay fresh).  Job status, listings and submits are never cached.
 *
 * <p>Configuration (environment variables):
 * <pre>
 *   AI_ENDPOINT              base URL of the onecompiler API (default http://localhost:8081)
 *   AI_API_KEY               forwarded as the X-API-Key header
 *   AI_GATEWAY               base URL of the billing/AI gateway (for Pro status; optional)
 *   BILLING_INTERNAL_SECRET  forwarded to the billing status endpoint (optional)
 * </pre>
 *
 * <p>Registered in web.xml at {@code /ManicFunctionality}.
 */
public class ManicServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final java.util.logging.Logger log =
        java.util.logging.Logger.getLogger(ManicServlet.class.getName());

    private static final int CONNECT_TIMEOUT_MS = 5_000;
    private static final int SOCKET_TIMEOUT_MS = 30_000; // API returns immediately (async render)

    private static final long CACHE_TTL_LIMITS_MS = 20_000L;       // limits (with usage): 20 s
    private static final long PREMIUM_CACHE_TTL_MS = 5 * 60_000L;  // Pro status: 5 min

    /** In-memory cache for the limits endpoint (key = "limits|plan|user"). */
    private static final ConcurrentHashMap<String, CacheEntry> CACHE = new ConcurrentHashMap<>();
    /** Pro-status cache: userId → [isPro(0/1), expiresAtMillis]. */
    private static final ConcurrentHashMap<String, long[]> PREMIUM = new ConcurrentHashMap<>();

    private static final class CacheEntry {
        final int status; final String body; final long expiresAt;
        CacheEntry(int status, String body, long expiresAt) {
            this.status = status; this.body = body; this.expiresAt = expiresAt;
        }
    }

    /** Resolved caller identity + entitlement. */
    private static final class Identity {
        final String userId;   // OAuth sub (logged in) or browser id (anon); may be null
        final String plan;     // "pro" | "free"
        final boolean loggedIn;
        Identity(String userId, String plan, boolean loggedIn) {
            this.userId = userId; this.plan = plan; this.loggedIn = loggedIn;
        }
    }

    private static String getBase() {
        String base = System.getenv("AI_ENDPOINT");
        if (base == null || base.isEmpty()) base = "http://localhost:8081";
        if (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base;
    }

    private static String getApiKey() {
        String key = System.getenv("AI_API_KEY");
        return key != null ? key : "";
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("ManicServlet ready — proxying to " + getBase() + "/api/manic"
            + (getApiKey().isEmpty() ? " (no API key set)" : " (API key configured)"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) { sendError(resp, 400, "missing_action", "missing action"); return; }
        Identity id = resolve(req);

        switch (action) {
            case "job": {
                String jid = req.getParameter("id");
                if (jid == null || !jid.matches("\\d+")) {
                    sendError(resp, 400, "invalid_job_id", "id must be an integer");
                    return;
                }
                proxyGet("/api/manic/jobs/" + jid, req, resp, null, 0);
                return;
            }
            case "jobs":
                proxyGet("/api/manic/jobs" + userLimitQuery(id, req), req, resp, null, 0);
                return;
            case "files":
                proxyGet("/api/manic/files" + userLimitQuery(id, req), req, resp, null, 0);
                return;
            case "limits": {
                StringBuilder q = new StringBuilder();
                append(q, "plan", id.plan);
                if (id.userId != null) append(q, "user", id.userId);
                String cacheKey = "limits|" + id.plan + "|" + (id.userId == null ? "" : id.userId);
                proxyGet("/api/manic/limits" + q, req, resp, cacheKey, CACHE_TTL_LIMITS_MS);
                return;
            }
            default:
                sendError(resp, 400, "unknown_action", "unknown action '" + action + "'");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (!"submit".equals(action)) {
            sendError(resp, 400, "unknown_action", "POST only supports action=submit");
            return;
        }
        Identity id = resolve(req);
        proxyPost("/api/manic", injectPlan(readBody(req), id), req, resp);
    }

    /* ── identity + entitlement (trusted, server-side) ─────────────── */

    private Identity resolve(HttpServletRequest req) {
        String sub = sessionUserId(req);
        if (sub != null) {
            String plan = isPremiumUser(sub) ? "pro" : "free";
            return new Identity(sub, plan, true);
        }
        String bid = req.getHeader("X-Browser-Id");
        if (bid != null && bid.trim().isEmpty()) bid = null;
        return new Identity(bid, "free", false);
    }

    /** Logged-in user id from the session (trusted), or null for anonymous. */
    private static String sessionUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object sub = session.getAttribute("oauth_user_sub");
        if (sub == null) return null;
        String s = sub.toString().trim();
        return s.isEmpty() ? null : s;
    }

    /** Overwrite plan (and, for logged-in users, userid) on the submit body. */
    private static String injectPlan(String body, Identity id) {
        try {
            JsonObject obj = new JsonParser().parse(body == null ? "{}" : body).getAsJsonObject();
            obj.addProperty("plan", id.plan);
            if (id.loggedIn && id.userId != null) obj.addProperty("userid", id.userId);
            return obj.toString();
        } catch (Exception e) {
            // malformed body — forward as-is so the API returns its own invalid_json
            return body;
        }
    }

    private boolean isPremiumUser(String userId) {
        if (userId == null || userId.isEmpty()) return false;
        long now = System.currentTimeMillis();
        long[] cached = PREMIUM.get(userId);
        if (cached != null && cached[1] > now) return cached[0] == 1L;
        boolean pro = fetchPremiumStatus(userId);
        PREMIUM.put(userId, new long[]{ pro ? 1L : 0L, now + PREMIUM_CACHE_TTL_MS });
        return pro;
    }

    /** Query the billing gateway for Pro status. Fails closed to free. */
    private boolean fetchPremiumStatus(String userId) {
        String gateway = System.getenv("AI_GATEWAY");
        if (gateway == null || gateway.isEmpty()) return false;
        if (gateway.endsWith("/")) gateway = gateway.substring(0, gateway.length() - 1);
        RequestConfig cfg = RequestConfig.custom()
            .setConnectTimeout(3000).setSocketTimeout(4000).build();
        try (CloseableHttpClient client = HttpClients.custom().setDefaultRequestConfig(cfg).build()) {
            HttpGet get = new HttpGet(gateway + "/v1/billing/status");
            get.setHeader("X-User-Id", userId);
            String secret = System.getenv("BILLING_INTERNAL_SECRET");
            if (secret != null && !secret.isEmpty()) get.setHeader("X-Billing-Internal-Secret", secret);
            HttpResponse upstream = client.execute(get);
            if (upstream.getStatusLine().getStatusCode() >= 400) return false;
            JsonObject obj = new JsonParser().parse(bodyOf(upstream)).getAsJsonObject();
            if (obj == null || !obj.has("is_premium") || obj.get("is_premium").isJsonNull()) return false;
            try { return obj.get("is_premium").getAsBoolean(); }
            catch (Exception ex) { return obj.get("is_premium").getAsInt() != 0; }
        } catch (Exception e) {
            log.fine("manic: billing status check failed for " + userId + ": " + e.getMessage());
            return false;
        }
    }

    /* ── proxy helpers ─────────────────────────────────────────────── */

    private void proxyGet(String path, HttpServletRequest req, HttpServletResponse resp,
                          String cacheKey, long ttlMs) throws IOException {
        if (cacheKey != null) {
            CacheEntry hit = CACHE.get(cacheKey);
            if (hit != null && hit.expiresAt > System.currentTimeMillis()) {
                sendJson(resp, hit.status, hit.body);
                return;
            }
        }
        String url = getBase() + path;
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpGet get = new HttpGet(url);
            get.setConfig(requestConfig());
            applyHeaders(get, req);

            HttpResponse upstream = client.execute(get);
            int status = upstream.getStatusLine().getStatusCode();
            String body = bodyOf(upstream);

            if (cacheKey != null && status == 200) {
                CACHE.put(cacheKey, new CacheEntry(status, body, System.currentTimeMillis() + ttlMs));
            }
            sendJson(resp, status, body);
        } catch (HttpHostConnectException ex) {
            sendError(resp, 503, "upstream_unavailable", "manic service unavailable at " + getBase());
        } catch (ConnectTimeoutException | java.net.SocketTimeoutException ex) {
            sendError(resp, 504, "upstream_timeout", "manic request timed out");
        } catch (IOException ex) {
            sendError(resp, 502, "upstream_error", "manic upstream error: " + ex.getMessage());
        }
    }

    private void proxyPost(String path, String body, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String url = getBase() + path;
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(url);
            post.setConfig(requestConfig());
            applyHeaders(post, req);
            post.setEntity(new StringEntity(body == null ? "" : body, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            sendJson(resp, upstream.getStatusLine().getStatusCode(), bodyOf(upstream));
        } catch (HttpHostConnectException ex) {
            sendError(resp, 503, "upstream_unavailable", "manic service unavailable at " + getBase());
        } catch (ConnectTimeoutException | java.net.SocketTimeoutException ex) {
            sendError(resp, 504, "upstream_timeout", "manic request timed out");
        } catch (IOException ex) {
            sendError(resp, 502, "upstream_error", "manic upstream error: " + ex.getMessage());
        }
    }

    private static RequestConfig requestConfig() {
        return RequestConfig.custom()
            .setConnectTimeout(CONNECT_TIMEOUT_MS)
            .setSocketTimeout(SOCKET_TIMEOUT_MS)
            .build();
    }

    /** Inject the server API key and forward the client's browser id (anon continuity). */
    private static void applyHeaders(org.apache.http.client.methods.HttpRequestBase r,
                                     HttpServletRequest req) {
        r.setHeader("Content-Type", "application/json");
        r.setHeader("Accept", "application/json");
        String apiKey = getApiKey();
        if (!apiKey.isEmpty()) r.setHeader("X-API-Key", apiKey);
        String bid = req.getHeader("X-Browser-Id");
        if (bid != null && !bid.isEmpty()) r.setHeader("X-Browser-Id", bid);
    }

    private static String bodyOf(HttpResponse upstream) throws IOException {
        return upstream.getEntity() == null
            ? ""
            : EntityUtils.toString(upstream.getEntity(), StandardCharsets.UTF_8);
    }

    /* ── request/response utilities ────────────────────────────────── */

    /** user= (server-resolved, overrides any client value) + limit=. */
    private static String userLimitQuery(Identity id, HttpServletRequest req) {
        StringBuilder q = new StringBuilder();
        if (id.userId != null) append(q, "user", id.userId);
        String limit = trimToNull(req.getParameter("limit"));
        if (limit != null && limit.matches("\\d+")) append(q, "limit", limit);
        return q.toString();
    }

    private static void append(StringBuilder q, String k, String v) {
        try {
            q.append(q.length() == 0 ? "?" : "&")
             .append(k).append('=').append(URLEncoder.encode(v, "UTF-8"));
        } catch (java.io.UnsupportedEncodingException ignored) { /* UTF-8 always present */ }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    private static void sendJson(HttpServletResponse resp, int status, String body) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=utf-8");
        try (PrintWriter pw = resp.getWriter()) { pw.print(body == null ? "" : body); }
    }

    /** Emit an error in the same {code,message,retryable,details} shape the API uses. */
    private static void sendError(HttpServletResponse resp, int status, String code, String message)
            throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=utf-8");
        boolean retryable = status >= 500;
        try (PrintWriter pw = resp.getWriter()) {
            pw.print("{\"code\":\"" + escape(code) + "\",\"message\":\"" + escape(message)
                + "\",\"retryable\":" + retryable + ",\"details\":{}}");
        }
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
