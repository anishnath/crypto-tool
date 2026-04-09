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
import java.net.URL;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Servlet proxy for SEO Crawl API.
 * Routes requests to the backend Go service based on "action" parameter.
 * Rate-limited: 3 crawl starts per IP per 5 minutes; status/findings polling unlimited.
 *
 * Actions:
 *   POST action=crawl       -> POST /api/seo/crawl
 *   GET  action=status&id=N -> GET  /api/seo/crawl/{id}
 *   GET  action=findings&id=N -> GET /api/seo/crawl/{id}/findings
 *   GET  action=pages&id=N&type=X -> GET /api/seo/crawl/{id}/issues/pages?type=X
 */
public class SEOCrawlFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Rate limit: 3 crawl starts per IP per 5 minutes
    private static final int CRAWLS_PER_WINDOW = 3;
    private static final int MAX_BUCKETS = 10_000;
    private static final Map<String, Bucket> crawlBuckets = new ConcurrentHashMap<>();

    private static final RequestConfig REQUEST_CONFIG = RequestConfig.custom()
            .setConnectTimeout(30000)
            .setSocketTimeout(120000)
            .build();

    private Bucket resolveBucket(String ip) {
        if (crawlBuckets.size() > MAX_BUCKETS) {
            crawlBuckets.clear();
        }
        return crawlBuckets.computeIfAbsent(ip, k ->
            Bucket.builder()
                .addLimit(Bandwidth.classic(CRAWLS_PER_WINDOW,
                    Refill.intervally(CRAWLS_PER_WINDOW, Duration.ofMinutes(5))))
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

        // Rate limit crawl starts
        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = probe.getNanosToWaitForRefill() / 1_000_000_000;
            resp.setStatus(429);
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in " + waitSeconds + " seconds.\"}");
            return;
        }

        String action = req.getParameter("action");

        if ("cancel".equals(action)) {
            // Cancel doesn't consume rate limit
            String id = req.getParameter("id");
            if (id == null || !id.matches("\\d+")) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Missing or invalid parameter: id\"}");
                return;
            }
            proxyPost(getApiBase() + "api/seo/crawl/" + id + "/cancel", null, resp);
            return;
        }

        if (!"crawl".equals(action)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid action for POST. Use action=crawl or action=cancel\"}");
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
        // Simple extraction — look for "url":"value"
        java.util.regex.Matcher urlMatcher = java.util.regex.Pattern.compile("\"url\"\\s*:\\s*\"([^\"]+)\"").matcher(bodyStr);
        if (urlMatcher.find()) {
            String crawlUrl = urlMatcher.group(1);
            try {
                java.net.URL parsed = new java.net.URL(crawlUrl);
                String scheme = parsed.getProtocol().toLowerCase();
                String host = parsed.getHost().toLowerCase();
                if (!"http".equals(scheme) && !"https".equals(scheme)) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Only http and https URLs are supported\"}");
                    return;
                }
                if (host.equals("localhost") || host.equals("127.0.0.1") || host.equals("0.0.0.0") ||
                    host.equals("::1") || host.startsWith("192.168.") || host.startsWith("10.") ||
                    host.endsWith(".local") || host.endsWith(".internal")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Cannot scan private or local addresses\"}");
                    return;
                }
            } catch (java.net.MalformedURLException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Invalid URL format\"}");
                return;
            }
        }

        proxyPost(getApiBase() + "api/seo/crawl", bodyStr, resp);
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

        // History action doesn't require id
        if ("history".equals(action)) {
            url = apiBase + "api/seo/crawls";
            String filterUrl = req.getParameter("url");
            String limit = req.getParameter("limit");
            String sep = "?";
            if (filterUrl != null && !filterUrl.trim().isEmpty()) {
                url += sep + "url=" + filterUrl;
                sep = "&";
            }
            if (limit != null && limit.matches("\\d+")) {
                url += sep + "limit=" + limit;
            }
            proxyGet(url, resp);
            return;
        }

        // Preflight: quick reachability check + URL validation
        if ("preflight".equals(action)) {
            String targetUrl = req.getParameter("url");
            if (targetUrl == null || targetUrl.trim().isEmpty()) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Missing url parameter\"}");
                return;
            }
            targetUrl = targetUrl.trim();

            // Validate URL format
            java.net.URL parsed;
            try {
                parsed = new java.net.URL(targetUrl);
            } catch (java.net.MalformedURLException e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Invalid URL format\"}");
                return;
            }

            // Block non-http(s) schemes
            String scheme = parsed.getProtocol().toLowerCase();
            if (!"http".equals(scheme) && !"https".equals(scheme)) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Only http and https URLs are supported\"}");
                return;
            }

            // Block private/local addresses (SSRF protection)
            String host = parsed.getHost().toLowerCase();
            if (host.equals("localhost") || host.equals("127.0.0.1") || host.equals("0.0.0.0") ||
                host.equals("::1") || host.startsWith("192.168.") || host.startsWith("10.") ||
                host.startsWith("172.16.") || host.startsWith("172.17.") || host.startsWith("172.18.") ||
                host.startsWith("172.19.") || host.startsWith("172.2") || host.startsWith("172.30.") ||
                host.startsWith("172.31.") || host.endsWith(".local") || host.endsWith(".internal") ||
                host.equals("[::1]")) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Cannot scan private or local addresses\"}");
                return;
            }

            // Quick HEAD request with short timeout
            RequestConfig shortTimeout = RequestConfig.custom()
                    .setConnectTimeout(8000)
                    .setSocketTimeout(8000)
                    .build();

            CloseableHttpClient httpClient = HttpClients.createDefault();
            try {
                org.apache.http.client.methods.HttpHead head = new org.apache.http.client.methods.HttpHead(targetUrl);
                head.setConfig(shortTimeout);
                head.addHeader("User-Agent", "Mozilla/5.0 (compatible; SEOCrawlBot/1.0; preflight)");
                HttpResponse response = httpClient.execute(head);
                int status = response.getStatusLine().getStatusCode();

                if (status >= 200 && status < 600) {
                    resp.getWriter().write("{\"reachable\":true,\"status\":" + status + "}");
                } else {
                    resp.getWriter().write("{\"reachable\":false,\"error\":\"Unexpected status: " + status + "\"}");
                }
            } catch (java.net.UnknownHostException e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Domain not found: " + host + "\"}");
            } catch (org.apache.http.conn.ConnectTimeoutException e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Connection timed out. Site may be down.\"}");
            } catch (java.net.SocketTimeoutException e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Site did not respond in time.\"}");
            } catch (javax.net.ssl.SSLException e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"SSL/TLS error: " + e.getMessage().replace("\"", "'") + "\"}");
            } catch (Exception e) {
                resp.getWriter().write("{\"reachable\":false,\"error\":\"Cannot reach site: " + e.getClass().getSimpleName() + "\"}");
            } finally {
                httpClient.close();
            }
            return;
        }

        // All other actions require id
        String id = req.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: id\"}");
            return;
        }
        if (!id.matches("\\d+")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Parameter id must be numeric\"}");
            return;
        }

        switch (action) {
            case "status":
                url = apiBase + "api/seo/crawl/" + id;
                break;
            case "findings":
                url = apiBase + "api/seo/crawl/" + id + "/findings";
                break;
            case "pages":
                String type = req.getParameter("type");
                if (type == null || type.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing required parameter: type\"}");
                    return;
                }
                url = apiBase + "api/seo/crawl/" + id + "/issues/pages?type=" + type;
                String limit = req.getParameter("limit");
                if (limit != null && limit.matches("\\d+")) {
                    url += "&limit=" + limit;
                }
                break;
            case "page":
                String pageId = req.getParameter("pid");
                if (pageId == null || !pageId.matches("\\d+")) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing or invalid parameter: pid\"}");
                    return;
                }
                url = apiBase + "api/seo/crawl/" + id + "/page/" + pageId;
                break;
            default:
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Unknown action: " + action + "\"}");
                return;
        }

        proxyGet(url, resp);
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
            resp.getWriter().write("{\"error\":\"SEO crawl API unavailable\"}");
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
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"SEO crawl API unavailable\"}");
        } finally {
            httpClient.close();
        }
    }
}
