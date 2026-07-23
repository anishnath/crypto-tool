package z.y.x.billing;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

/**
 * Server-side Pro entitlement for JSP pages and servlets.
 * Uses the same billing gateway as {@code AIGatewayProxyServlet} and {@code ManicServlet}.
 */
public final class BillingPageSupport {

    private static final Logger LOG = Logger.getLogger(BillingPageSupport.class.getName());
    private static final long PREMIUM_CACHE_TTL_MS = 6L * 60 * 60 * 1000L; // Pro status: 6 h
    private static final ConcurrentHashMap<String, long[]> PREMIUM = new ConcurrentHashMap<>();

    private BillingPageSupport() {
    }

    public static String oauthUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object sub = session.getAttribute("oauth_user_sub");
        if (sub == null) {
            return null;
        }
        String s = sub.toString().trim();
        return s.isEmpty() ? null : s;
    }

    /** True when the logged-in user has an active Pro subscription. Guests are never Pro. */
    public static boolean isPremiumUser(HttpServletRequest req) {
        if (req == null) {
            return false;
        }
        String userId = oauthUserId(req.getSession(false));
        if (userId == null) {
            return false;
        }
        return isPremiumUser(userId);
    }

    public static boolean isPremiumUser(String userId) {
        if (userId == null || userId.isEmpty()) {
            return false;
        }
        long now = System.currentTimeMillis();
        long[] cached = PREMIUM.get(userId);
        if (cached != null && cached[1] > now) {
            return cached[0] == 1L;
        }
        boolean premium = fetchPremiumStatus(userId);
        PREMIUM.put(userId, new long[]{ premium ? 1L : 0L, now + PREMIUM_CACHE_TTL_MS });
        return premium;
    }

    private static boolean fetchPremiumStatus(String userId) {
        String gateway = System.getenv("AI_GATEWAY");
        if (gateway == null || gateway.isEmpty()) {
            return false;
        }
        if (gateway.endsWith("/")) {
            gateway = gateway.substring(0, gateway.length() - 1);
        }
        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(3000)
                .setSocketTimeout(4000)
                .build();
        try (CloseableHttpClient client = HttpClients.custom().setDefaultRequestConfig(config).build()) {
            HttpGet get = new HttpGet(gateway + "/v1/billing/status");
            get.setHeader("X-User-Id", userId);
            String secret = System.getenv("BILLING_INTERNAL_SECRET");
            if (secret != null && !secret.isEmpty()) {
                get.setHeader("X-Billing-Internal-Secret", secret);
            }
            HttpResponse upstream = client.execute(get);
            if (upstream.getStatusLine().getStatusCode() >= 400) {
                return false;
            }
            JsonObject obj = new JsonParser().parse(readBody(upstream)).getAsJsonObject();
            if (obj == null || !obj.has("is_premium") || obj.get("is_premium").isJsonNull()) {
                return false;
            }
            try {
                return obj.get("is_premium").getAsBoolean();
            } catch (Exception ex) {
                return obj.get("is_premium").getAsInt() != 0;
            }
        } catch (Exception e) {
            LOG.fine("billing status check failed for " + userId + ": " + e.getMessage());
            return false;
        }
    }

    private static String readBody(HttpResponse response) throws java.io.IOException {
        if (response.getEntity() == null) {
            return "{}";
        }
        java.io.BufferedReader br = new java.io.BufferedReader(
                new java.io.InputStreamReader(response.getEntity().getContent()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            content.append(line);
        }
        return content.toString();
    }
}
