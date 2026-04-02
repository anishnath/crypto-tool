package com.arduino.web.servlets;

import com.latexeditor.web.client.ApiClientConfig;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

/**
 * Proxy servlet for Arduino QEMU simulation (ESP32 boards).
 *
 * Endpoints:
 *   POST /api/arduino/simulate/start  → proxies to Go API POST /api/arduino-simulate/start
 *   POST /api/arduino/simulate/stop   → proxies to Go API POST /api/arduino-simulate/stop
 *   POST /api/arduino/simulate/input  → proxies to Go API POST /api/arduino-simulate/input
 *   GET  /api/arduino/simulate/stream → SSE proxy to Go API GET /api/arduino-simulate/stream
 *
 * The stream endpoint uses async servlet (Servlet 3.0) to keep the connection open
 * and forward SSE events from the Go backend to the browser in real time.
 */
// Mapped in web.xml (async-supported=true). Do NOT add @WebServlet — causes duplicate mapping.
public class ArduinoSimulateServlet extends HttpServlet {

    private static final int POST_TIMEOUT_MS = 30_000;
    private static final int STREAM_CONNECT_TIMEOUT_MS = 5_000;
    // SSE stream: long timeout (10 minutes max)
    private static final int STREAM_READ_TIMEOUT_MS = 600_000;

    private String backendBaseUrl() {
        return ApiClientConfig.getApiBaseUrl() + "/api/arduino-simulate";
    }

    private String piBackendBaseUrl() {
        return ApiClientConfig.getApiBaseUrl() + "/api/pi-simulate";
    }

    /** Map servlet path to backend URL. Returns null if not found. */
    private String resolveBackendUrl(String pathInfo) {
        if (pathInfo == null) return null;
        // ESP32 endpoints
        switch (pathInfo) {
            case "/start":  return backendBaseUrl() + "/start";
            case "/stop":   return backendBaseUrl() + "/stop";
            case "/input":  return backendBaseUrl() + "/input";
            case "/stream": return backendBaseUrl() + "/stream";
            // Pi endpoints
            case "/pi/start":  return piBackendBaseUrl() + "/start";
            case "/pi/stop":   return piBackendBaseUrl() + "/stop";
            case "/pi/input":  return piBackendBaseUrl() + "/input";
            case "/pi/gpio":   return piBackendBaseUrl() + "/gpio";
            case "/pi/stream": return piBackendBaseUrl() + "/stream";
        }
        return null;
    }

    // ── POST handlers (ESP32 + Pi) ──

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String backendUrl = resolveBackendUrl(pathInfo);
        if (backendUrl == null || (pathInfo != null && pathInfo.equals("/stream")) || (pathInfo != null && pathInfo.equals("/pi/stream"))) {
            resp.setStatus(404);
            resp.getWriter().write("{\"error\":\"not found\"}");
            return;
        }

        // Read request body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        // Forward to Go backend
        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(backendUrl);
            post.setConfig(RequestConfig.custom()
                    .setConnectTimeout(POST_TIMEOUT_MS)
                    .setSocketTimeout(POST_TIMEOUT_MS)
                    .build());
            post.setEntity(new StringEntity(sb.toString(), ContentType.APPLICATION_JSON));

            HttpResponse backendResp = client.execute(post);
            int status = backendResp.getStatusLine().getStatusCode();
            resp.setStatus(status);
            resp.setContentType("application/json");

            HttpEntity entity = backendResp.getEntity();
            if (entity != null) {
                entity.writeTo(resp.getOutputStream());
            }
        } catch (HttpHostConnectException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"success\":false,\"error\":\"Simulation service unavailable\"}");
        } finally {
            client.close();
        }
    }

    // ── GET /stream — SSE proxy (async servlet) ──

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (!"/stream".equals(pathInfo) && !"/pi/stream".equals(pathInfo)) {
            resp.setStatus(404);
            resp.getWriter().write("{\"error\":\"not found\"}");
            return;
        }

        String id = req.getParameter("id");
        if (id == null || id.isEmpty()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"id query param required\"}");
            return;
        }

        // Resolve backend stream URL (ESP32 or Pi)
        final String streamBackendUrl = "/pi/stream".equals(pathInfo)
            ? piBackendBaseUrl() + "/stream"
            : backendBaseUrl() + "/stream";

        // Set SSE headers
        resp.setContentType("text/event-stream");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Connection", "keep-alive");
        resp.setHeader("X-Accel-Buffering", "no");
        resp.flushBuffer();

        // Start async context for long-lived SSE connection
        final AsyncContext async = req.startAsync();
        async.setTimeout(STREAM_READ_TIMEOUT_MS);

        // Proxy SSE from Go backend in a background thread
        Thread streamThread = new Thread(() -> {
            CloseableHttpClient client = HttpClients.createDefault();
            try {
                String url = streamBackendUrl + "?id=" + java.net.URLEncoder.encode(id, "UTF-8");
                HttpGet get = new HttpGet(url);
                get.setConfig(RequestConfig.custom()
                        .setConnectTimeout(STREAM_CONNECT_TIMEOUT_MS)
                        .setSocketTimeout(STREAM_READ_TIMEOUT_MS)
                        .build());

                CloseableHttpResponse backendResp = client.execute(get);
                HttpEntity entity = backendResp.getEntity();
                if (entity == null) {
                    async.complete();
                    return;
                }

                InputStream in = entity.getContent();
                OutputStream out = async.getResponse().getOutputStream();
                // Send an SSE comment immediately to keep the connection alive
                // (prevents EventSource timeout during QEMU boot)
                out.write(": connected\n\n".getBytes());
                out.flush();

                byte[] buf = new byte[1024];
                int n;
                while ((n = in.read(buf)) != -1) {
                    out.write(buf, 0, n);
                    out.flush();
                }
            } catch (Exception e) {
                // Log the actual error — helps debug SSE proxy issues
                System.err.println("[SSE Proxy] Stream error for " + id + ": " + e.getClass().getSimpleName() + ": " + e.getMessage());
            } finally {
                try { client.close(); } catch (Exception ignored) {}
                try { async.complete(); } catch (Exception ignored) {}
            }
        }, "sse-proxy-" + id);
        streamThread.setDaemon(true);

        async.addListener(new AsyncListener() {
            @Override public void onComplete(AsyncEvent event) { streamThread.interrupt(); }
            @Override public void onTimeout(AsyncEvent event) { streamThread.interrupt(); try { async.complete(); } catch (Exception ignored) {} }
            @Override public void onError(AsyncEvent event) { streamThread.interrupt(); try { async.complete(); } catch (Exception ignored) {} }
            @Override public void onStartAsync(AsyncEvent event) {}
        });

        streamThread.start();
    }
}
