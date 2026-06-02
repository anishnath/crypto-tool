package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/**
 * Unified JSON API for crypto tool pages (hash, HMAC, cipher, KDF, asymmetric).
 * Used by the shared {@code crypto-tools-ai.js} AI assistant (lazy-loaded).
 *
 * POST /api/crypto/execute
 * Body: { "tool": "message-digest", "operation": "hash", "params": { ... } }
 */
public class CryptoApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson GSON = new Gson();
    private static final int MAX_BODY = 512 * 1024;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String path = req.getServletPath();
        if (!"/api/crypto/execute".equals(path)) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"ok\":false,\"error\":\"not found\"}");
            return;
        }

        JsonObject body = readJsonBody(req);
        String baseUrl = buildAppBaseUrl(req);
        JsonObject result = CryptoBackendClient.execute(baseUrl, body);
        int status = result.has("ok") && result.get("ok").getAsBoolean()
                ? HttpServletResponse.SC_OK
                : HttpServletResponse.SC_BAD_REQUEST;
        writeJson(resp, status, result);
    }

    static String buildAppBaseUrl(HttpServletRequest req) {
        String scheme = req.getScheme();
        int port = req.getServerPort();
        String host = req.getServerName();
        String ctx = req.getContextPath();
        boolean def = ("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443);
        return scheme + "://" + host + (def ? "" : ":" + port) + ctx;
    }

    private static JsonObject readJsonBody(HttpServletRequest req) throws IOException {
        InputStream in = req.getInputStream();
        byte[] buf = new byte[8192];
        StringBuilder sb = new StringBuilder();
        int total = 0;
        int n;
        while ((n = in.read(buf)) >= 0) {
            total += n;
            if (total > MAX_BODY) {
                throw new IOException("Request body too large");
            }
            sb.append(new String(buf, 0, n, StandardCharsets.UTF_8));
        }
        String raw = sb.toString().trim();
        if (raw.isEmpty()) {
            return new JsonObject();
        }
        return new JsonParser().parse(raw).getAsJsonObject();
    }

    private static void writeJson(HttpServletResponse resp, int status, JsonObject body) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write(GSON.toJson(body));
    }
}
