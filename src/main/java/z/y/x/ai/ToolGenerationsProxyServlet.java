package z.y.x.ai;

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
 * Proxies per-tool AI generation history to the Go gateway.
 * Currently enabled for TikZ viewer only ({@code math/tikz-viewer}).
 * <ul>
 *   <li>{@code GET /api/tools/tikz/generations/recent} → Go recent list</li>
 *   <li>{@code POST /api/tools/tikz/generations} → Go save (fire-and-forget from browser)</li>
 * </ul>
 */
public class ToolGenerationsProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOG = Logger.getLogger(ToolGenerationsProxyServlet.class.getName());

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
        if (!"/api/tools/tikz/generations/recent".equals(req.getServletPath())) {
            notFound(resp);
            return;
        }
        String qs = req.getQueryString();
        String target = gatewayBase() + "/v1/tools/tikz/generations/recent";
        if (qs != null && !qs.trim().isEmpty()) {
            target = target + "?" + qs;
        }
        proxy(req, resp, "GET", target, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!"/api/tools/tikz/generations".equals(req.getServletPath())) {
            notFound(resp);
            return;
        }
        proxy(req, resp, "POST", gatewayBase() + "/v1/tools/tikz/generations", readBody(req));
    }

    private void proxy(HttpServletRequest req, HttpServletResponse resp, String method, String url, String body)
            throws IOException {
        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(5000)
                .setSocketTimeout(15000)
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

            HttpSession session = req.getSession(false);
            if (session != null) {
                String userId = (String) session.getAttribute("oauth_user_sub");
                if (userId != null && !userId.isEmpty()) {
                    outbound.setHeader("X-User-Id", userId);
                }
            }
            copyHeader(req, outbound, "X-Anonymous-Id");
            copyHeader(req, outbound, "X-Tool-Id");

            HttpResponse gatewayResp = client.execute(outbound);
            int status = gatewayResp.getStatusLine().getStatusCode();
            String responseBody = gatewayResp.getEntity() != null
                    ? EntityUtils.toString(gatewayResp.getEntity(), StandardCharsets.UTF_8) : "";

            resp.setStatus(status);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(responseBody != null ? responseBody : "");
        } catch (Exception e) {
            LOG.log(Level.WARNING, "Tool generations proxy failed: " + url, e);
            resp.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"tool generations gateway unavailable\"}");
        }
    }

    private static void notFound(HttpServletResponse resp) throws IOException {
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"error\":\"not found\"}");
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
