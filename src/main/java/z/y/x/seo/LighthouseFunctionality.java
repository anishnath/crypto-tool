package z.y.x.seo;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;
import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Servlet proxy for Lighthouse API (async since v2).
 * Rate-limited: 3 audits per IP per 10 minutes (Lighthouse runs are expensive — real Chrome).
 *
 * Actions:
 *   POST action=audit               -> POST /api/lighthouse            (enqueue, returns 202 with job_id)
 *   GET  action=job&id=N            -> GET  /api/lighthouse/jobs/{id}  (poll job status)
 *   GET  action=audits              -> GET  /api/lighthouse/audits[?url=&limit=]
 *   GET  action=get&id=N            -> GET  /api/lighthouse/audits/{id}
 */
public class LighthouseFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Rate limit: 3 Lighthouse audits per IP per 10 minutes
    private static final int AUDITS_PER_WINDOW = 3;
    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> auditBuckets = new ConcurrentHashMap<>();

    // Async API: POST returns 202 immediately; polling calls are fast
    private static final RequestConfig REQUEST_CONFIG = RequestConfig.custom()
            .setConnectTimeout(10000)
            .setSocketTimeout(20000)
            .build();

    private Bucket resolveBucket(String ip) {
        if (auditBuckets.size() > MAX_BUCKETS) {
            auditBuckets.clear();
        }
        return auditBuckets.computeIfAbsent(ip, k ->
            Bucket.builder()
                .addLimit(Bandwidth.classic(AUDITS_PER_WINDOW,
                    Refill.intervally(AUDITS_PER_WINDOW, Duration.ofMinutes(10))))
                .build()
        );
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

    private String getApiBase() {
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }
        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }
        return apiBase;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");
        if (!"audit".equals(action)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid action for POST. Use action=audit\"}");
            return;
        }

        // Rate limit Lighthouse audit starts
        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = probe.getNanosToWaitForRefill() / 1_000_000_000;
            resp.setStatus(429);
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Lighthouse audits are expensive — try again in " + waitSeconds + " seconds.\"}");
            return;
        }

        // Read request body
        StringBuilder body = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            body.append(line);
        }

        if (body.length() == 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing request body with url field\"}");
            return;
        }

        // Extract and validate URL from JSON body
        String bodyStr = body.toString();
        java.util.regex.Matcher urlMatcher = java.util.regex.Pattern.compile("\"url\"\\s*:\\s*\"([^\"]+)\"").matcher(bodyStr);
        if (urlMatcher.find()) {
            String auditUrl = urlMatcher.group(1);
            try {
                java.net.URL parsed = new java.net.URL(auditUrl);
                String scheme = parsed.getProtocol().toLowerCase();
                String host = parsed.getHost().toLowerCase();
                if (!"http".equals(scheme) && !"https".equals(scheme)) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Only http and https URLs are supported\"}");
                    return;
                }
                if (host.equals("localhost") || host.equals("127.0.0.1") || host.equals("0.0.0.0") ||
                    host.equals("::1") || host.startsWith("192.168.") || host.startsWith("10.") ||
                    host.startsWith("172.16.") || host.startsWith("172.17.") || host.startsWith("172.18.") ||
                    host.startsWith("172.19.") || host.startsWith("172.2") || host.startsWith("172.30.") ||
                    host.startsWith("172.31.") || host.endsWith(".local") || host.endsWith(".internal")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Cannot audit private or local addresses\"}");
                    return;
                }
            } catch (java.net.MalformedURLException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Invalid URL format\"}");
                return;
            }
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing url field in request body\"}");
            return;
        }

        proxyPost(getApiBase() + "api/lighthouse", bodyStr, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: action\"}");
            return;
        }

        String apiBase = getApiBase();
        String url;

        switch (action) {
            case "audits":
                // List recent audits, optionally filtered by URL
                url = apiBase + "api/lighthouse/audits";
                String filterUrl = req.getParameter("url");
                String limit = req.getParameter("limit");
                String sep = "?";
                if (filterUrl != null && !filterUrl.trim().isEmpty()) {
                    url += sep + "url=" + java.net.URLEncoder.encode(filterUrl, "UTF-8");
                    sep = "&";
                }
                if (limit != null && limit.matches("\\d+")) {
                    url += sep + "limit=" + limit;
                }
                proxyGet(url, resp);
                return;

            case "get":
                String id = req.getParameter("id");
                if (id == null || !id.matches("\\d+")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing or invalid parameter: id\"}");
                    return;
                }
                url = apiBase + "api/lighthouse/audits/" + id;
                proxyGet(url, resp);
                return;

            case "job":
                String jobId = req.getParameter("id");
                if (jobId == null || !jobId.matches("\\d+")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing or invalid parameter: id\"}");
                    return;
                }
                url = apiBase + "api/lighthouse/jobs/" + jobId;
                proxyGet(url, resp);
                return;

            default:
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Unknown action: " + action + "\"}");
        }
    }

    private void proxyGet(String url, HttpServletResponse resp) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        try {
            HttpGet getRequest = new HttpGet(url);
            getRequest.setConfig(REQUEST_CONFIG);
            getRequest.addHeader("Accept", "application/json");

            HttpResponse response = httpClient.execute(getRequest);
            int status = response.getStatusLine().getStatusCode();
            resp.setStatus(status);

            BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
            resp.getWriter().write(content.toString());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Lighthouse API unavailable\"}");
        } finally {
            httpClient.close();
        }
    }

    private void proxyPost(String url, String body, HttpServletResponse resp) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(url);
            post.setConfig(REQUEST_CONFIG);
            if (body != null && !body.isEmpty()) {
                post.setEntity(new StringEntity(body, ContentType.APPLICATION_JSON));
            }
            post.addHeader("Accept", "application/json");

            HttpResponse response = httpClient.execute(post);
            int status = response.getStatusLine().getStatusCode();
            resp.setStatus(status);

            BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
            resp.getWriter().write(content.toString());
        } catch (java.net.SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Lighthouse audit timed out. The page took too long to load.\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Lighthouse API unavailable\"}");
        } finally {
            httpClient.close();
        }
    }
}
