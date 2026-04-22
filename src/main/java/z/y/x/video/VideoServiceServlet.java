package z.y.x.video;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;

import z.y.x.ai.TranscribeService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

/**
 * Entry point for the Video Studio page ({@code /video/}).
 *
 * Thin dispatcher. Today it routes action=transcribe to {@link TranscribeService} with a
 * larger audio-size ceiling (25 MB decoded) than the legacy {@code /ai?action=transcribe}
 * path — video source material, even after client-side audio extraction, is bigger than
 * typical mic recordings.
 *
 * Future actions (dubbing, voice clone, subtitles, voice changer…) will be wired in here.
 */
public class VideoServiceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Logger log = Logger.getLogger(VideoServiceServlet.class.getName());

    // Video-studio transcribe: ~25 MB decoded audio ≈ ~33.5 MB base64.
    private static final long MAX_AUDIO_BASE64_LENGTH = 33_500_000L;

    // Rate-limit: transcribe is expensive (Whisper), so tighter than the generic /ai limit.
    private static final int REQUESTS_PER_MINUTE = 3;
    private static final int BURST_CAPACITY = 2;
    private static final int MAX_BUCKETS = 10_000;

    private static final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");

        String clientIp = getClientIp(req);
        Bucket bucket = resolveBucket(clientIp);
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
        if (!probe.isConsumed()) {
            long waitSeconds = Math.max(1, probe.getNanosToWaitForRefill() / 1_000_000_000);
            log.warning("VideoService rate-limit BLOCKED IP=" + clientIp);
            resp.setContentType("application/json");
            resp.setStatus(429);
            resp.setHeader("Retry-After", String.valueOf(waitSeconds));
            resp.getWriter().write("{\"error\":\"Rate limit exceeded. Try again in "
                    + waitSeconds + " seconds.\",\"retryAfter\":" + waitSeconds + "}");
            return;
        }
        resp.setHeader("X-RateLimit-Remaining", String.valueOf(probe.getRemainingTokens()));

        String action = req.getParameter("action");
        if (action == null) action = "transcribe";

        switch (action) {
            case "transcribe":
                // Segment-level timestamps, Whisper-backed.
                TranscribeService.handle(req, resp, MAX_AUDIO_BASE64_LENGTH);
                return;
            case "caption-init":
                // Word-level timestamps via WhisperX. Powers the Auto-Captions editor.
                TranscribeService.handle(req, resp, MAX_AUDIO_BASE64_LENGTH, "/transcribe-x");
                return;
            default:
                resp.setContentType("application/json");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Unknown action: " + action.replace("\"", "\\\"") + "\"}");
        }
    }

    // ── helpers ──────────────────────────────────────────────────────────

    private Bucket resolveBucket(String ip) {
        if (buckets.size() > MAX_BUCKETS) buckets.clear();
        return buckets.computeIfAbsent(ip, k -> Bucket.builder()
                .addLimit(Bandwidth.classic(REQUESTS_PER_MINUTE,
                        Refill.intervally(REQUESTS_PER_MINUTE, Duration.ofMinutes(1))))
                .addLimit(Bandwidth.classic(BURST_CAPACITY,
                        Refill.intervally(BURST_CAPACITY, Duration.ofSeconds(30))))
                .build());
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
}
