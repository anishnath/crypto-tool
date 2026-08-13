package z.y.x.manic.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Small private bridge from the Manic Cloudflare Worker to the render-host
 * proxy. It deliberately has no browser/session authentication surface: the
 * Worker authenticates with a dedicated API key, and this servlet uses the
 * existing OneCompiler endpoint/API key when it activates the render host.
 *
 * <p>Endpoint: {@code POST /ManicRenderBridgeFunctionality}
 * Body: {@code {"job_id":"rnd_..."}}
 *
 * <p>Required environment variables:
 * <ul>
 *   <li>{@code MANIC_RENDER_BRIDGE_KEY}: Cloudflare Worker → this servlet</li>
 *   <li>{@code AI_ENDPOINT}: existing OneCompiler base URL</li>
 *   <li>{@code AI_API_KEY}: existing OneCompiler API key</li>
 * </ul>
 */
public final class ManicRenderBridgeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int CONNECT_TIMEOUT_MS = 5_000;
    private static final int SOCKET_TIMEOUT_MS = 15_000;
    private static final int MAX_BODY_CHARS = 4_096;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String bridgeKey = requiredEnv("MANIC_RENDER_BRIDGE_KEY");
        String proxyUrl = renderSystemUrl();
        String proxyKey = requiredEnv("AI_API_KEY");
        if (bridgeKey == null || proxyUrl == null || proxyKey == null) {
            sendError(resp, 503, "bridge_not_configured", "Manic render bridge is not configured.");
            return;
        }

        if (!matchesApiKey(req.getHeader("X-API-Key"), bridgeKey)) {
            sendError(resp, 401, "unauthorized", "Invalid render bridge credential.");
            return;
        }

        String jobId = jobId(readBody(req));
        if (jobId == null) {
            sendError(resp, 400, "invalid_job_id", "Body must contain a valid rnd_ job_id.");
            return;
        }

        RequestConfig config = RequestConfig.custom()
            .setConnectTimeout(CONNECT_TIMEOUT_MS)
            .setSocketTimeout(SOCKET_TIMEOUT_MS)
            .build();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(proxyUrl);
            post.setConfig(config);
            post.setHeader("X-API-Key", proxyKey);
            post.setHeader("Content-Type", "application/json");
            post.setHeader("Accept", "application/json");
            String requestId = req.getHeader("X-Request-Id");
            if (requestId != null && requestId.matches("[A-Za-z0-9._:-]{1,128}")) {
                post.setHeader("X-Request-Id", requestId);
            }
            post.setEntity(new StringEntity("{\"job_id\":\"" + escape(jobId) + "\"}",
                ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();
            String body = upstream.getEntity() == null ? ""
                : EntityUtils.toString(upstream.getEntity(), StandardCharsets.UTF_8);
            sendJson(resp, status, body.isEmpty() ? "{\"job_id\":\"" + escape(jobId) + "\"}" : body);
        } catch (java.net.SocketTimeoutException ex) {
            sendError(resp, 504, "render_proxy_timeout", "Render proxy timed out.");
        } catch (IOException ex) {
            sendError(resp, 503, "render_proxy_unavailable", "Render proxy is unavailable.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        sendError(resp, 405, "method_not_allowed", "POST is required.");
    }

    private static String requiredEnv(String name) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private static String renderSystemUrl() {
        String base = requiredEnv("AI_ENDPOINT");
        if (base == null) return null;
        while (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base + "/api/manic/render-system";
    }

    private static boolean matchesApiKey(String apiKey, String expected) {
        if (apiKey == null) return false;
        byte[] actual = apiKey.getBytes(StandardCharsets.UTF_8);
        byte[] wanted = expected.getBytes(StandardCharsets.UTF_8);
        return MessageDigest.isEqual(actual, wanted);
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        StringBuilder value = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            char[] buffer = new char[512];
            int count;
            while ((count = reader.read(buffer)) != -1) {
                if (value.length() + count > MAX_BODY_CHARS) return null;
                value.append(buffer, 0, count);
            }
        }
        return value.toString();
    }

    private static String jobId(String body) {
        if (body == null) return null;
        try {
            JsonObject value = new JsonParser().parse(body).getAsJsonObject();
            if (value == null || !value.has("job_id") || value.get("job_id").isJsonNull()) return null;
            String jobId = value.get("job_id").getAsString();
            return jobId != null && jobId.matches("rnd_[A-Za-z0-9_-]{8,128}") ? jobId : null;
        } catch (Exception ignored) {
            return null;
        }
    }

    private static void sendJson(HttpServletResponse resp, int status, String body) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=utf-8");
        resp.setHeader("Cache-Control", "no-store");
        try (PrintWriter writer = resp.getWriter()) {
            writer.print(body);
        }
    }

    private static void sendError(HttpServletResponse resp, int status, String code, String message)
            throws IOException {
        sendJson(resp, status, "{\"error\":{\"code\":\"" + escape(code)
            + "\",\"message\":\"" + escape(message) + "\"}}");
    }

    private static String escape(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
            .replace("\n", "\\n").replace("\r", "\\r");
    }
}
