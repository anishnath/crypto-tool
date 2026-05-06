package z.y.x.cube.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import z.y.x.cube.cube444.Cube444;
import z.y.x.cube.cube444.Cube444Moves;
import z.y.x.cube.cube444.Cube444Solver;
import z.y.x.cube.cube555.Cube555;
import z.y.x.cube.cube555.Cube555Moves;
import z.y.x.cube.cube555.Cube555Solver;

/**
 * HTTP entry point for the cube-solver service.
 *
 * Endpoints:
 *
 *   GET  ?action=solved&size=4   → SOLVED state (96-char string for size=4)
 *   GET  ?action=apply&size=4&state=…&moves=…
 *                                → applies the move sequence, returns new state
 *   POST ?action=solve&size=4    → body: {"state": "…"}
 *                                → solves, returns JSON {moves, finalState, …}
 *
 * Currently only size=4 is supported.  Sizes 2, 3, 5, 6, 7 will be
 * added by adding cube222/, cube333/, cube555/, etc. packages and
 * dispatching here.
 *
 * Registered in web.xml at url-pattern {@code /CubeSolverFunctionality}.
 */
public class CubeSolverServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        // Build the centres pruning tables off the request path.  Done in a
        // background thread so servlet startup isn't blocked — the first
        // solve request will block briefly if init isn't done yet.
        new Thread(new Runnable() {
            @Override public void run() {
                try { Cube444Solver.warmUp(); }
                catch (Throwable t) { t.printStackTrace(); }
            }
        }, "Cube444-warmup").start();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String size = req.getParameter("size");

        if (size == null) size = "4";
        if (!"4".equals(size) && !"5".equals(size)) {
            sendError(resp, 400, "size " + size + " not yet supported (4 or 5)");
            return;
        }

        if ("solved".equals(action)) {
            String solved = "5".equals(size) ? Cube555.SOLVED : Cube444.SOLVED;
            sendJson(resp, "{\"state\":\"" + solved + "\"}");
            return;
        }
        if ("apply".equals(action)) {
            String state = req.getParameter("state");
            String moves = req.getParameter("moves");
            if (state == null) { sendError(resp, 400, "missing state"); return; }
            try {
                String result;
                if ("5".equals(size)) {
                    Cube555.Validation v = Cube555.validate(state);
                    if (!v.ok) { sendError(resp, 400, v.reason); return; }
                    result = Cube555Moves.applyMoves(state, moves);
                } else {
                    Cube444.Validation v = Cube444.validate(state);
                    if (!v.ok) { sendError(resp, 400, v.reason); return; }
                    result = Cube444Moves.applyMoves(state, moves);
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
        String size = req.getParameter("size");
        if (size == null) size = "4";
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

        if ("5".equals(size)) {
            handleSolve555(state, resp);
            return;
        }

        Cube444.Validation v = Cube444.validate(state);
        if (!v.ok) { sendError(resp, 400, v.reason); return; }

        Cube444Solver.Result r;
        try {
            r = Cube444Solver.solve(state);
        } catch (Exception ex) {
            sendError(resp, 500, "solver error: " + ex.getMessage());
            return;
        }

        StringBuilder sb = new StringBuilder(256);
        sb.append("{");
        sb.append("\"solved\":").append(r.solved).append(",");
        sb.append("\"elapsedMs\":").append(r.elapsedMs).append(",");
        sb.append("\"moveCount\":").append(r.moves.size()).append(",");
        sb.append("\"moves\":");        appendStringList(sb, r.moves);        sb.append(",");
        sb.append("\"centresMoves\":"); appendStringList(sb, r.centresMoves); sb.append(",");
        sb.append("\"orientMoves\":");  appendStringList(sb, r.orientMoves);  sb.append(",");
        sb.append("\"phase3Moves\":");  appendStringList(sb, r.phase3Moves);  sb.append(",");
        sb.append("\"phase4Moves\":");  appendStringList(sb, r.phase4Moves);  sb.append(",");
        sb.append("\"reduceMoves\":");  appendStringList(sb, r.reduceMoves);  sb.append(",");
        sb.append("\"finalState\":\"").append(r.finalState).append("\",");
        if (r.stoppedAt != null) {
            sb.append("\"stoppedAt\":\"").append(escape(r.stoppedAt)).append("\"");
        } else {
            sb.append("\"stoppedAt\":null");
        }
        sb.append("}");
        sendJson(resp, sb.toString());
    }

    /* ── 5×5 solve handler ─────────────────────────────────────── */

    private void handleSolve555(String state, HttpServletResponse resp) throws IOException {
        Cube555.Validation v = Cube555.validate(state);
        if (!v.ok) { sendError(resp, 400, v.reason); return; }

        Cube555Solver.Result r;
        try {
            r = Cube555Solver.solve(state);
        } catch (Exception ex) {
            sendError(resp, 500, "5x5 solver error: " + ex.getMessage());
            return;
        }

        StringBuilder sb = new StringBuilder(512);
        sb.append("{");
        sb.append("\"solved\":").append(r.solved).append(",");
        sb.append("\"elapsedMs\":").append(r.elapsedMs).append(",");
        sb.append("\"moveCount\":").append(r.moves.size()).append(",");
        sb.append("\"moves\":");        appendStringList(sb, r.moves);       sb.append(",");
        sb.append("\"lrMoves\":");      appendStringList(sb, r.lrMoves);     sb.append(",");
        sb.append("\"fbMoves\":");      appendStringList(sb, r.fbMoves);     sb.append(",");
        sb.append("\"eoMoves\":");      appendStringList(sb, r.eoMoves);     sb.append(",");
        sb.append("\"phase4Moves\":");  appendStringList(sb, r.p4Moves);     sb.append(",");
        sb.append("\"phase5Moves\":");  appendStringList(sb, r.p5Moves);     sb.append(",");
        sb.append("\"phase6Moves\":");  appendStringList(sb, r.p6Moves);     sb.append(",");
        sb.append("\"reduceMoves\":");  appendStringList(sb, r.reduceMoves); sb.append(",");
        sb.append("\"finalState\":\"").append(r.finalState).append("\",");
        if (r.stoppedAt != null) {
            sb.append("\"stoppedAt\":\"").append(escape(r.stoppedAt)).append("\"");
        } else {
            sb.append("\"stoppedAt\":null");
        }
        sb.append("}");
        sendJson(resp, sb.toString());
    }

    /* ── helpers ───────────────────────────────────────────────── */

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

    /** Extract a string field "name":"value" from a flat JSON body. */
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

    private static void appendStringList(StringBuilder sb, java.util.List<String> xs) {
        sb.append("[");
        for (int i = 0; i < xs.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(escape(xs.get(i))).append("\"");
        }
        sb.append("]");
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
