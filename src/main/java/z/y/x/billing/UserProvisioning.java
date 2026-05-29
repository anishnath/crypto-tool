package z.y.x.billing;

import com.latexeditor.web.util.JsonUtil;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Upserts Google OAuth users via the Go billing API (D1 writes only in Go).
 */
public final class UserProvisioning {
    private static final Logger LOG = Logger.getLogger(UserProvisioning.class.getName());

    private UserProvisioning() {}

    public static void upsertGoogleUser(String userId, String email, String name) {
        if (userId == null || userId.trim().isEmpty()) {
            return;
        }
        String base = gatewayBase();
        String url = base + "/v1/billing/users/upsert";

        Map<String, String> body = new HashMap<>();
        body.put("user_id", userId);
        if (email != null && !email.trim().isEmpty()) {
            body.put("email", email.trim());
        }
        if (name != null && !name.trim().isEmpty()) {
            body.put("name", name.trim());
        }

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(15000);

            String secret = System.getenv("BILLING_INTERNAL_SECRET");
            if (secret != null && !secret.isEmpty()) {
                conn.setRequestProperty("X-Billing-Internal-Secret", secret);
            }

            byte[] bytes = JsonUtil.toJson(body).getBytes(StandardCharsets.UTF_8);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(bytes);
            }

            int code = conn.getResponseCode();
            if (code >= 400) {
                String err = readStream(conn, code >= 400);
                LOG.log(Level.WARNING, "User upsert failed HTTP " + code + ": " + err);
            }
        } catch (Exception e) {
            LOG.log(Level.WARNING, "User upsert failed for " + userId + ": " + e.getMessage());
        }
    }

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

    private static String readStream(HttpURLConnection conn, boolean error) throws Exception {
        java.io.InputStream stream = error ? conn.getErrorStream() : conn.getInputStream();
        if (stream == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}
