package z.y.x.Network;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Live cloud GPU prices from GridPup (https://gridpup.com), for gpu-prices.jsp.
 *
 * Calls GridPup's price API server-side with a read-only key and caches the answer, so every page
 * view is served from memory and the API sees at most one request per cache period.
 *
 *   GET /GpuPricesFunctionality            -> {"generated_at", "last_collected_at", "clouds": {id: name}, "items": [...]}
 *
 * gpu-prices.jsp also calls {@link #snapshot()} directly to render the table on the server (for search engines).
 */
public class GpuPricesFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOG = Logger.getLogger(GpuPricesFunctionality.class.getName());

    private static final String API = "https://api.gridpup.com/v1";
    // Read-only GridPup key (prices:read only). GRIDPUP_API_KEY overrides it.
    private static final String DEFAULT_KEY = "gp_live_6b9c0efb47af_zDR6fTaIlXTM5H_7LOlXUCAPbXqXEo-cB10HeEaz";
    private static final long TTL_MS = 10 * 60 * 1000L;        // GridPup collects prices every few minutes
    private static final long RETRY_MS = 60 * 1000L;           // after a failed refresh, keep the old data a minute

    private static volatile JsonObject cached;
    private static volatile long fetchedAt;
    private static volatile long nextTry;

    private static String key() {
        String k = System.getenv("GRIDPUP_API_KEY");
        return k != null && !k.trim().isEmpty() ? k.trim() : DEFAULT_KEY;
    }

    /** The board plus cloud names, from the cache when fresh. Null only if GridPup never answered. */
    public static JsonObject snapshot() {
        long now = System.currentTimeMillis();
        JsonObject c = cached;
        if (c != null && now - fetchedAt < TTL_MS) {
            return c;
        }
        synchronized (GpuPricesFunctionality.class) {
            if (cached != null && now - fetchedAt < TTL_MS) {
                return cached;
            }
            if (now < nextTry) {
                return cached;           // stale data beats an error page
            }
            try {
                JsonObject board = get("/gpus?limit=500").getAsJsonObject();
                JsonObject clouds = get("/clouds").getAsJsonObject();
                JsonObject names = new JsonObject();
                for (JsonElement p : clouds.getAsJsonArray("providers")) {
                    JsonObject o = p.getAsJsonObject();
                    names.addProperty(o.get("id").getAsString(), o.get("display_name").getAsString());
                }
                JsonObject out = new JsonObject();
                out.add("generated_at", board.get("generated_at"));
                out.add("last_collected_at", board.get("last_collected_at"));
                out.add("clouds", names);
                out.add("items", trim(board.getAsJsonArray("items")));
                cached = out;
                fetchedAt = now;
            } catch (Exception e) {
                LOG.log(Level.WARNING, "GridPup price API failed: " + e.getMessage());
                nextTry = now + RETRY_MS;
            }
            return cached;
        }
    }

    private static final long MODELS_TTL_MS = 60 * 60 * 1000L;   // the model catalog changes daily
    private static final Map<String, Object[]> MODELS = new ConcurrentHashMap<>();   // task -> {items, fetchedAt, nextTry}

    /**
     * The most downloaded open models GridPup can deploy for a Hugging Face task (e.g. "text-generation"):
     * id, size, GPU memory needed and the cheapest machine that runs it now. Empty if GridPup never answered.
     */
    public static JsonArray models(String task) {
        long now = System.currentTimeMillis();
        Object[] c = MODELS.get(task);
        if (c != null && (now - (Long) c[1] < MODELS_TTL_MS || now < (Long) c[2])) {
            return (JsonArray) c[0];
        }
        synchronized (MODELS) {
            c = MODELS.get(task);
            if (c != null && (now - (Long) c[1] < MODELS_TTL_MS || now < (Long) c[2])) {
                return (JsonArray) c[0];
            }
            try {
                JsonArray items = get("/models?deployable=true&sort=downloads&task=" + task)
                        .getAsJsonObject().getAsJsonArray("items");
                MODELS.put(task, new Object[]{items, now, 0L});
                return items;
            } catch (Exception e) {
                LOG.log(Level.WARNING, "GridPup model API failed: " + e.getMessage());
                JsonArray old = c == null ? new JsonArray() : (JsonArray) c[0];
                MODELS.put(task, new Object[]{old, c == null ? 0L : (Long) c[1], now + RETRY_MS});
                return old;
            }
        }
    }

    /** The priced GPU with GridPup id {@code modelId} (e.g. "nvidia-h100"), or null. */
    public static JsonObject gpu(JsonObject data, String modelId) {
        if (data == null) {
            return null;
        }
        for (JsonElement e : data.getAsJsonArray("items")) {
            JsonObject o = e.getAsJsonObject();
            if (modelId.equals(o.get("model_id").getAsString())) {
                return o;
            }
        }
        return null;
    }

    /** Name for headings: "Nvidia H100" -> "NVIDIA H100", "RTX 4090" -> "NVIDIA RTX 4090". */
    public static String fullName(JsonObject gpu) {
        String name = gpu.get("display_name").getAsString();
        JsonElement v = gpu.get("vendor");
        if (name.startsWith("Nvidia ")) {
            return "NVIDIA " + name.substring("Nvidia ".length());
        }
        if (v != null && !v.isJsonNull() && "nvidia".equals(v.getAsString()) && !name.toUpperCase().startsWith("NVIDIA")) {
            return "NVIDIA " + name;
        }
        return name;
    }

    /** Only the fields the page shows. */
    private static JsonArray trim(JsonArray items) {
        String[] keep = {"model_id", "display_name", "vendor", "gpu_class", "architecture", "memory_gb",
                "cheapest_usd_per_gpu_hour", "cheapest_provider", "median_usd_per_gpu_hour",
                "spot_from_usd_per_gpu_hour", "move_24h_pct", "offers", "in_stock_offers", "priced_providers"};
        JsonArray out = new JsonArray();
        for (JsonElement e : items) {
            JsonObject src = e.getAsJsonObject();
            if (src.get("cheapest_usd_per_gpu_hour") == null || src.get("cheapest_usd_per_gpu_hour").isJsonNull()) {
                continue;               // no price yet
            }
            JsonObject o = new JsonObject();
            for (String k : keep) {
                if (src.has(k)) {
                    o.add(k, src.get(k));
                }
            }
            JsonArray by = new JsonArray();
            if (src.has("by_provider")) {
                for (JsonElement b : src.getAsJsonArray("by_provider")) {
                    JsonObject bo = b.getAsJsonObject();
                    JsonObject x = new JsonObject();
                    x.add("provider", bo.get("provider"));
                    x.add("from", bo.get("from_usd_per_gpu_hour"));
                    x.add("median", bo.get("median_usd_per_gpu_hour"));
                    x.add("offers", bo.get("offers"));
                    by.add(x);
                }
            }
            o.add("by_provider", by);
            out.add(o);
        }
        return out;
    }

    private static JsonElement get(String path) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(API + path).openConnection();
        c.setRequestProperty("Authorization", "Bearer " + key());
        c.setRequestProperty("Accept", "application/json");
        c.setRequestProperty("User-Agent", "8gwifi.org gpu-prices");
        c.setConnectTimeout(5000);
        c.setReadTimeout(10000);
        int status = c.getResponseCode();
        if (status != 200) {
            throw new IOException("HTTP " + status + " for " + path);
        }
        try (InputStream in = c.getInputStream()) {
            ByteArrayOutputStream buf = new ByteArrayOutputStream();
            byte[] b = new byte[8192];
            int n;
            while ((n = in.read(b)) > 0) {
                buf.write(b, 0, n);
            }
            return new JsonParser().parse(new String(buf.toByteArray(), StandardCharsets.UTF_8));
        } finally {
            c.disconnect();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject data = snapshot();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (data == null) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            response.setHeader("Cache-Control", "no-store");
            response.getWriter().write("{\"error\":\"GPU prices are not available right now. Try again in a minute.\"}");
            return;
        }
        response.setHeader("Cache-Control", "public, max-age=300");
        response.getWriter().write(data.toString());
    }
}
