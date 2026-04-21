package z.y.x.ai;

import com.latexeditor.web.util.JsonUtil;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.SocketTimeoutException;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Transcribe service — shared by {@link AIProxyServlet} (action=transcribe) and
 * {@link z.y.x.video.VideoServiceServlet} (video studio).
 *
 * The two callers need different audio-size ceilings (AIProxyServlet caps at ~5 MB decoded
 * for mic/short audio; VideoServiceServlet allows up to ~25 MB decoded for audio extracted
 * from video). Everything else — validation, format/task allow-list, timeout, backend URL —
 * is identical, so it lives here.
 *
 * Backend: POSTs JSON {audio, format, task, language?} to AI_ENDPOINT2/transcribe (Whisper).
 */
public final class TranscribeService {

    private static final Logger log = Logger.getLogger(TranscribeService.class.getName());

    private static final Set<String> VALID_FORMATS =
            new java.util.HashSet<>(java.util.Arrays.asList("mp3", "wav", "m4a", "webm", "ogg", "flac"));
    private static final Set<String> VALID_TASKS =
            new java.util.HashSet<>(java.util.Arrays.asList("transcribe", "translate"));

    private static final int TRANSCRIBE_TIMEOUT_MS = 300_000; // 5 min

    private TranscribeService() { /* static only */ }

    /**
     * Handle a transcribe POST: parse JSON body, validate audio/format/task, forward to Whisper.
     *
     * @param maxAudioBase64Length caller-chosen upper bound on base64 audio length.
     */
    public static void handle(HttpServletRequest req, HttpServletResponse resp, long maxAudioBase64Length)
            throws IOException {

        resp.setCharacterEncoding("UTF-8");

        String transcribeUrl = getTranscribeEndpoint();
        if (transcribeUrl == null) {
            resp.setContentType("application/json");
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Speech-to-text is temporarily unavailable. Please try again later.\"}");
            return;
        }

        String body = readRequestBody(req);
        if (body.isEmpty()) {
            badRequest(resp, "Empty request body");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> payload = JsonUtil.fromJson(body, Map.class);
        if (payload == null) {
            badRequest(resp, "Invalid JSON");
            return;
        }

        // ── audio field ──
        Object audioObj = payload.get("audio");
        if (audioObj == null || audioObj.toString().trim().isEmpty()) {
            badRequest(resp, "Missing required field: audio (base64-encoded)");
            return;
        }
        String audioB64 = audioObj.toString().trim();
        if (audioB64.startsWith("data:")) {
            int commaIdx = audioB64.indexOf(',');
            if (commaIdx > 0) {
                audioB64 = audioB64.substring(commaIdx + 1);
                payload.put("audio", audioB64);
            }
        }
        if (audioB64.length() > maxAudioBase64Length) {
            long approxMB = audioB64.length() * 3L / 4 / 1024 / 1024;
            long maxMB = maxAudioBase64Length * 3L / 4 / 1024 / 1024;
            badRequest(resp, "Audio too large (~" + approxMB + "MB). Maximum is " + maxMB + "MB.");
            return;
        }

        // ── format ──
        Object formatObj = payload.get("format");
        String format = (formatObj != null) ? formatObj.toString().trim().toLowerCase() : "webm";
        if (!VALID_FORMATS.contains(format)) {
            badRequest(resp, "Invalid format. Use: mp3, wav, m4a, webm, ogg, or flac");
            return;
        }
        payload.put("format", format);

        // ── task ──
        Object taskObj = payload.get("task");
        String task = (taskObj != null) ? taskObj.toString().trim().toLowerCase() : "transcribe";
        if (!VALID_TASKS.contains(task)) {
            badRequest(resp, "Invalid task. Use: transcribe or translate");
            return;
        }
        payload.put("task", task);

        String json = JsonUtil.toJson(payload);
        log.info("Transcribe: format=" + format + " task=" + task
                + " audioSize=" + (audioB64.length() / 1024) + "KB"
                + " limitKB=" + (maxAudioBase64Length / 1024));

        forwardBlocking(transcribeUrl, json, resp, TRANSCRIBE_TIMEOUT_MS);
    }

    // ── helpers ──────────────────────────────────────────────────────────

    private static void badRequest(HttpServletResponse resp, String msg) throws IOException {
        resp.setContentType("application/json");
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.getWriter().write("{\"error\":\"" + msg.replace("\"", "\\\"") + "\"}");
    }

    private static String getTranscribeEndpoint() {
        String base = System.getenv("AI_ENDPOINT2");
        if (base == null || base.isEmpty()) return null;
        if (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base + "/transcribe";
    }

    private static String getApiKey() {
        String key = System.getenv("AI_API_KEY");
        return key != null ? key : "";
    }

    private static String readRequestBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        return sb.toString().trim();
    }

    private static void forwardBlocking(String url, String payload, HttpServletResponse resp, int timeoutMs)
            throws IOException {
        resp.setContentType("application/json");

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(5000)
                .setSocketTimeout(timeoutMs)
                .build();

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(url);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            String apiKey = getApiKey();
            if (!apiKey.isEmpty()) post.setHeader("X-API-Key", apiKey);
            post.setEntity(new StringEntity(payload, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();
            String respBody = readBody(upstream);

            if (status >= 400) {
                resp.setStatus(status >= 500 ? 502 : status);
                resp.getWriter().write(respBody.isEmpty() ? "{\"error\":\"Transcribe service error\"}" : respBody);
                return;
            }
            resp.getWriter().write(respBody);

        } catch (HttpHostConnectException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Transcribe service unavailable\"}");
        } catch (ConnectTimeoutException | SocketTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Transcribe request timed out\"}");
        } finally {
            client.close();
        }
    }

    private static String readBody(HttpResponse response) throws IOException {
        if (response.getEntity() == null) return "";
        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        return sb.toString();
    }
}
