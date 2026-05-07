package z.y.x.cube.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube555.Cube555;
import z.y.x.cube.cube555.Cube555Moves;

/**
 * HTTP entry point for the cube-solver service.
 *
 * <p><b>As of the current revision, this servlet no longer downloads any
 * lookup tables nor runs the pure-Java IDA* pipeline.</b>  Solving is
 * delegated to the external RubikCube HTTP service via {@code AI_ENDPOINT}
 * (per the {@code CUBE.MD} API contract — see {@code /cubic/solve}).
 *
 * <p>The pure-Java solver code (Cube444Solver, Cube555Solver, all stages
 * and lookup-table machinery) is intact and still valid — it's just not
 * the production solve path right now.  A future revision can flip a
 * config switch to use either the local pipeline or the remote API.
 *
 * <p>What this servlet still does locally:
 * <ul>
 *   <li>State validation (length + per-face counts) — fast, no downloads.</li>
 *   <li>Move application via {@code Cube*Moves.applyMoves} for the
 *       {@code apply} action.</li>
 *   <li>Returns the canonical SOLVED state for the {@code solved} action.</li>
 * </ul>
 *
 * <p>Endpoints:
 * <pre>
 *   GET  ?action=solved&size=3..7   → SOLVED state for the requested size
 *   GET  ?action=apply&size=4|5&state=…&moves=…
 *                                   → applies the move sequence locally, returns
 *                                     new state.  Sizes 3, 6, 7 must apply
 *                                     moves client-side (we don't ship Java
 *                                     move tables for those sizes).
 *   POST ?action=solve&size=3..7    → body: {"state": "…"}
 *                                   → forwards to AI_ENDPOINT/cubic/solve, returns
 *                                     {"solved":true,"moves":[…],"moveCount":N,…}
 * </pre>
 *
 * <p>Configuration (via environment variables):
 * <pre>
 *   AI_ENDPOINT   base URL of the cube proxy (default http://localhost:8081)
 *   AI_API_KEY    forwarded as X-API-Key header
 * </pre>
 *
 * <p>Registered in web.xml at {@code /CubeSolverFunctionality}.
 */
public class CubeSolverServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final java.util.logging.Logger log =
        java.util.logging.Logger.getLogger(CubeSolverServlet.class.getName());

    /** Sane upper bound for a single solve.  4×4 typical 5–40 s; 5×5 can
     *  push longer.  120 s is conservative; the upstream proxy is the
     *  authoritative timeout. */
    private static final int SOLVE_SOCKET_TIMEOUT_MS = 120_000;
    private static final int CONNECT_TIMEOUT_MS = 5_000;

    private static String getAiEndpoint() {
        String base = System.getenv("AI_ENDPOINT");
        if (base == null || base.isEmpty()) base = "http://localhost:8081";
        if (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base + "/cubic/solve";
    }

    private static String getApiKey() {
        String key = System.getenv("AI_API_KEY");
        return key != null ? key : "";
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        // No warmup — solving is delegated to AI_ENDPOINT.  The Java
        // pipelines are deliberately NOT preloaded here.
        log.info("CubeSolverServlet ready — solve delegated to "
            + getAiEndpoint()
            + (getApiKey().isEmpty() ? " (no API key set)" : " (API key configured)"));
    }

    /** Cube sizes the upstream solver supports.  Stickers per face = N².
     *  8×8 is forwarded but not all upstream builds handle it — if not,
     *  the upstream returns an error and the client surfaces it. */
    private static final int MIN_SIZE = 3;
    private static final int MAX_SIZE = 8;

    private static int parseSize(String raw) {
        if (raw == null) return 4;
        try {
            int n = Integer.parseInt(raw);
            return (n >= MIN_SIZE && n <= MAX_SIZE) ? n : -1;
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        int n = parseSize(req.getParameter("size"));
        if (n < 0) {
            sendError(resp, 400, "size must be in [" + MIN_SIZE + ".." + MAX_SIZE + "]");
            return;
        }

        if ("solved".equals(action)) {
            sendJson(resp, "{\"state\":\"" + solvedFor(n) + "\"}");
            return;
        }
        if ("apply".equals(action)) {
            String state = req.getParameter("state");
            String moves = req.getParameter("moves");
            if (state == null) { sendError(resp, 400, "missing state"); return; }
            try {
                String result;
                if (n == 5) {
                    Cube555.Validation v = Cube555.validate(state);
                    if (!v.ok) { sendError(resp, 400, v.reason); return; }
                    result = Cube555Moves.applyMoves(state, moves);
                } else if (n == 4) {
                    Cube444.Validation v = Cube444.validate(state);
                    if (!v.ok) { sendError(resp, 400, v.reason); return; }
                    result = Cube444Moves.applyMoves(state, moves);
                } else {
                    // Sizes 3, 6, 7, 8 — no Java move tables shipped.  Clients
                    // apply moves locally (rubiks{N}/moves.js or cubejs for 3×3).
                    sendError(resp, 400,
                        "size=" + n + " apply not supported server-side; apply moves client-side");
                    return;
                }
                sendJson(resp, "{\"state\":\"" + result + "\"}");
            } catch (IllegalArgumentException ex) {
                sendError(resp, 400, ex.getMessage());
            }
            return;
        }

        sendError(resp, 400, "unknown action '" + action + "'");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        int n = parseSize(req.getParameter("size"));
        if (n < 0) {
            sendError(resp, 400, "size must be in [" + MIN_SIZE + ".." + MAX_SIZE + "]");
            return;
        }
        if (!"solve".equals(action)) {
            sendError(resp, 400, "POST only supports action=solve");
            return;
        }

        String body = readBody(req);
        String state = extractStringField(body, "state");
        if (state == null) {
            sendError(resp, 400, "missing 'state' field in request body");
            return;
        }

        // Local validation — fast, prevents bad requests from hitting the
        // upstream solver.  For sizes with Java validators (4, 5) we run
        // full per-face count + sticker-alphabet checks; for the rest we
        // length-check only (the upstream solver does the rest).
        if (n == 4) {
            Cube444.Validation v = Cube444.validate(state);
            if (!v.ok) { sendError(resp, 400, v.reason); return; }
        } else if (n == 5) {
            Cube555.Validation v = Cube555.validate(state);
            if (!v.ok) { sendError(resp, 400, v.reason); return; }
        } else {
            int expected = 6 * n * n;
            if (state.length() != expected) {
                sendError(resp, 400,
                    "size=" + n + " expects " + expected + " stickers, got " + state.length());
                return;
            }
        }

        forwardSolveToApi(state, resp);
    }

    /* ── Forward to AI_ENDPOINT/cubic/solve ────────────────────────── */

    private void forwardSolveToApi(String state, HttpServletResponse resp) throws IOException {
        String url = getAiEndpoint();
        String apiKey = getApiKey();

        // Build the JSON payload — minimal {"state": "..."} per CUBE.MD.
        // The server infers cube size from state length and applies its
        // own defaults for `order` (URFDLB).
        String payload = "{\"state\":\"" + escape(state) + "\"}";

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT_MS)
                .setSocketTimeout(SOLVE_SOCKET_TIMEOUT_MS)
                .build();

        long t0 = System.currentTimeMillis();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(url);
            post.setConfig(config);
            post.setHeader("Content-Type", "application/json");
            if (!apiKey.isEmpty()) post.setHeader("X-API-Key", apiKey);
            post.setEntity(new StringEntity(payload, ContentType.APPLICATION_JSON));

            HttpResponse upstream = client.execute(post);
            int status = upstream.getStatusLine().getStatusCode();
            String respBody = upstream.getEntity() == null
                ? ""
                : EntityUtils.toString(upstream.getEntity(), java.nio.charset.StandardCharsets.UTF_8);
            long dt = System.currentTimeMillis() - t0;

            if (status >= 400) {
                // Surface upstream error verbatim so the client can show
                // useful diagnostics (e.g. parity-error detail strings).
                resp.setStatus(status >= 500 ? 502 : status);
                resp.setContentType("application/json; charset=utf-8");
                try (PrintWriter pw = resp.getWriter()) {
                    pw.print(respBody.isEmpty()
                        ? "{\"solved\":false,\"error\":\"upstream returned status " + status + "\"}"
                        : respBody);
                }
                return;
            }

            // Translate upstream response shape to our existing client
            // response shape so the JS doesn't need updating:
            //   upstream:  {"size":N,"solution":[…],"move_count":N,"solved":true}
            //   client:    {"solved":true,"elapsedMs":N,"moveCount":N,"moves":[…]}
            String solution = extractArrayField(respBody, "solution");   // may be null
            int moveCount = extractIntField(respBody, "move_count", -1);
            boolean solved = extractBoolField(respBody, "solved", false);
            int respSize = extractIntField(respBody, "size", -1);

            StringBuilder sb = new StringBuilder(256);
            sb.append("{");
            sb.append("\"solved\":").append(solved).append(",");
            sb.append("\"elapsedMs\":").append(dt).append(",");
            sb.append("\"moveCount\":").append(moveCount >= 0 ? moveCount : 0).append(",");
            sb.append("\"size\":").append(respSize >= 0 ? respSize : -1).append(",");
            sb.append("\"moves\":").append(solution == null ? "[]" : solution).append(",");
            sb.append("\"backend\":\"api\"");
            sb.append("}");
            sendJson(resp, sb.toString());

        } catch (HttpHostConnectException ex) {
            sendError(resp, 503, "cube solver service unavailable at " + url);
        } catch (ConnectTimeoutException | java.net.SocketTimeoutException ex) {
            sendError(resp, 504, "cube solver request timed out after "
                + SOLVE_SOCKET_TIMEOUT_MS + " ms");
        } catch (IOException ex) {
            sendError(resp, 502, "cube solver upstream error: " + ex.getMessage());
        }
    }

    /* ── helpers ───────────────────────────────────────────────── */

    /** Build the canonical SOLVED state for a cube of size N: each face's
     *  N² stickers are its own letter, in URFDLB order. */
    private static String solvedFor(int n) {
        if (n == 5) return Cube555.SOLVED;
        if (n == 4) return Cube444.SOLVED;
        int perFace = n * n;
        StringBuilder sb = new StringBuilder(6 * perFace);
        for (char f : new char[] {'U','R','F','D','L','B'}) {
            for (int i = 0; i < perFace; i++) sb.append(f);
        }
        return sb.toString();
    }

    private static void sendJson(HttpServletResponse resp, String body) throws IOException {
        resp.setContentType("application/json; charset=utf-8");
        resp.setStatus(200);
        try (PrintWriter pw = resp.getWriter()) { pw.print(body); }
    }

    private static void sendError(HttpServletResponse resp, int status, String msg)
            throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=utf-8");
        try (PrintWriter pw = resp.getWriter()) {
            pw.print("{\"error\":\"" + escape(msg) + "\"}");
        }
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    /** Extract `"name":"value"` from a flat JSON body. */
    private static String extractStringField(String body, String name) {
        if (body == null) return null;
        String key = "\"" + name + "\"";
        int k = body.indexOf(key);
        if (k < 0) return null;
        int colon = body.indexOf(':', k);
        if (colon < 0) return null;
        int q1 = body.indexOf('"', colon);
        if (q1 < 0) return null;
        int q2 = body.indexOf('"', q1 + 1);
        if (q2 < 0) return null;
        return body.substring(q1 + 1, q2);
    }

    /** Extract a JSON array `"name":[…]` and return the literal `[…]`
     *  including brackets, or null if not present. */
    private static String extractArrayField(String body, String name) {
        if (body == null) return null;
        String key = "\"" + name + "\"";
        int k = body.indexOf(key);
        if (k < 0) return null;
        int colon = body.indexOf(':', k);
        if (colon < 0) return null;
        int open = body.indexOf('[', colon);
        if (open < 0) return null;
        int depth = 1, i = open + 1;
        while (i < body.length() && depth > 0) {
            char c = body.charAt(i);
            if (c == '[') depth++;
            else if (c == ']') depth--;
            i++;
        }
        return depth == 0 ? body.substring(open, i) : null;
    }

    private static int extractIntField(String body, String name, int dflt) {
        if (body == null) return dflt;
        String key = "\"" + name + "\"";
        int k = body.indexOf(key);
        if (k < 0) return dflt;
        int colon = body.indexOf(':', k);
        if (colon < 0) return dflt;
        int i = colon + 1;
        while (i < body.length() && Character.isWhitespace(body.charAt(i))) i++;
        int start = i;
        while (i < body.length()
               && (Character.isDigit(body.charAt(i)) || body.charAt(i) == '-')) i++;
        if (i == start) return dflt;
        try { return Integer.parseInt(body.substring(start, i)); }
        catch (NumberFormatException ex) { return dflt; }
    }

    private static boolean extractBoolField(String body, String name, boolean dflt) {
        if (body == null) return dflt;
        String key = "\"" + name + "\"";
        int k = body.indexOf(key);
        if (k < 0) return dflt;
        int colon = body.indexOf(':', k);
        if (colon < 0) return dflt;
        int i = colon + 1;
        while (i < body.length() && Character.isWhitespace(body.charAt(i))) i++;
        if (body.startsWith("true",  i)) return true;
        if (body.startsWith("false", i)) return false;
        return dflt;
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
