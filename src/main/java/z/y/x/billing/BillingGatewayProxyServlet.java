package z.y.x.billing;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Proxies billing routes to the Go gateway (single D1 writer).
 * <ul>
 *   <li>{@code POST /api/dodo/webhook} → {@code POST /v1/billing/webhook}</li>
 *   <li>{@code POST /api/dodo/checkout} → {@code POST /v1/billing/checkout}</li>
 *   <li>{@code GET /api/billing/status} → {@code GET /v1/billing/status}</li>
 *   <li>{@code GET /api/billing/plans} → {@code GET /v1/billing/plans}</li>
 * </ul>
 */
public class BillingGatewayProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOG = Logger.getLogger(BillingGatewayProxyServlet.class.getName());

    private static String gatewayBase() {
        String base = System.getenv("AI_GATEWAY");
        if (base == null || base.isEmpty()) {
            base = "http://localhost:8084";
        }
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/api/billing/status".equals(path)) {
            proxy(req, resp, "GET", gatewayBase() + "/v1/billing/status", null, true);
            return;
        }
        if ("/api/billing/plans".equals(path)) {
            String qs = req.getQueryString();
            String target = gatewayBase() + "/v1/billing/plans";
            if (qs != null && !qs.trim().isEmpty()) {
                target = target + "?" + qs;
            }
            proxy(req, resp, "GET", target, null, false);
            return;
        }
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"error\":\"not found\"}");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String body = readBody(req);
        if ("/api/dodo/webhook".equals(path)) {
            proxy(req, resp, "POST", gatewayBase() + "/v1/billing/webhook", body, false);
            return;
        }
        if ("/api/dodo/checkout".equals(path)) {
            proxy(req, resp, "POST", gatewayBase() + "/v1/billing/checkout", body, true);
            return;
        }
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"error\":\"not found\"}");
    }

    private void proxy(HttpServletRequest req, HttpServletResponse resp, String method, String url,
                       String body, boolean requireLogin) throws IOException {

        if (requireLogin) {
            HttpSession session = req.getSession(false);
            String userId = session != null ? (String) session.getAttribute("oauth_user_sub") : null;
            if (userId == null || userId.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"login required\",\"login_url\":\"/GoogleOAuthFunctionality?action=login\"}");
                return;
            }
        }

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(10000)
                .setSocketTimeout(60000)
                .build();

        try (CloseableHttpClient client = HttpClients.custom().setDefaultRequestConfig(config).build()) {
            HttpUriRequest outbound;
            if ("GET".equals(method)) {
                outbound = new HttpGet(url);
            } else {
                HttpPost post = new HttpPost(url);
                if (body != null) {
                    post.setEntity(new StringEntity(body, StandardCharsets.UTF_8));
                }
                post.setHeader("Content-Type", "application/json");
                outbound = post;
            }

            if (requireLogin) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    String userId = (String) session.getAttribute("oauth_user_sub");
                    String email = (String) session.getAttribute("oauth_user_email");
                    if (userId != null) {
                        outbound.setHeader("X-User-Id", userId);
                    }
                    if (email != null) {
                        outbound.setHeader("X-User-Email", email);
                    }
                }
            }

            // Forward Dodo webhook headers verbatim
            copyHeader(req, outbound, "webhook-id");
            copyHeader(req, outbound, "webhook-signature");
            copyHeader(req, outbound, "webhook-timestamp");

            // Tell Go the ORIGINAL public host/proto so it builds checkout return/cancel
            // URLs against the public site (e.g. localhost:8080 / 8gwifi.org) instead of
            // the internal gateway address (127.0.0.1:8084). Prefer pre-existing
            // X-Forwarded-* (set by an upstream reverse proxy) when present.
            String fwdHost = firstNonEmpty(req.getHeader("X-Forwarded-Host"), req.getHeader("Host"), buildHostHeader(req));
            if (fwdHost != null) {
                outbound.setHeader("X-Forwarded-Host", fwdHost);
            }
            String fwdProto = firstNonEmpty(req.getHeader("X-Forwarded-Proto"), req.getScheme());
            if (fwdProto != null) {
                outbound.setHeader("X-Forwarded-Proto", fwdProto);
            }

            String internalSecret = System.getenv("BILLING_INTERNAL_SECRET");
            if (internalSecret != null && !internalSecret.isEmpty()) {
                outbound.setHeader("X-Billing-Internal-Secret", internalSecret);
            }

            HttpResponse gatewayResp = client.execute(outbound);
            int status = gatewayResp.getStatusLine().getStatusCode();
            String responseBody = gatewayResp.getEntity() != null
                    ? EntityUtils.toString(gatewayResp.getEntity(), StandardCharsets.UTF_8) : "";

            resp.setStatus(status);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(responseBody != null ? responseBody : "");
        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Billing gateway proxy failed: " + url, e);
            resp.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"billing gateway unavailable\"}");
        }
    }

    private static String firstNonEmpty(String... values) {
        if (values == null) return null;
        for (String v : values) {
            if (v != null && !v.trim().isEmpty()) return v.trim();
        }
        return null;
    }

    /** Reconstruct "host[:port]" from the request when no Host/X-Forwarded-Host is set. */
    private static String buildHostHeader(HttpServletRequest req) {
        String name = req.getServerName();
        if (name == null || name.isEmpty()) return null;
        int port = req.getServerPort();
        String scheme = req.getScheme();
        boolean defaultPort = ("http".equals(scheme) && port == 80)
                || ("https".equals(scheme) && port == 443);
        return defaultPort ? name : name + ":" + port;
    }

    private static void copyHeader(HttpServletRequest req, HttpUriRequest outbound, String name) {
        String v = req.getHeader(name);
        if (v != null && !v.trim().isEmpty()) {
            outbound.setHeader(name, v.trim());
        }
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        InputStream in = req.getInputStream();
        byte[] buf = new byte[8192];
        StringBuilder sb = new StringBuilder();
        int n;
        while ((n = in.read(buf)) >= 0) {
            sb.append(new String(buf, 0, n, StandardCharsets.UTF_8));
        }
        return sb.toString();
    }
}
