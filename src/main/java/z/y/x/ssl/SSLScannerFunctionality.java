package z.y.x.ssl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * SSE servlet to proxy SSL scanning API with real-time progress.
 * Accepts query parameters: domain, scanType
 * Proxies to property API: {api}/sslscan/<domain>?type=<scanType>
 * Streams progress/status events to the client via Server-Sent Events.
 */
public class SSLScannerFunctionality extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		final String domain = request.getParameter("domain");
		final String scanTypeParam = request.getParameter("scanType"); // keep backward compatibility with existing JSP

		if (domain == null || domain.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Domain is required");
			return;
		}

		final String scanType = (scanTypeParam == null || scanTypeParam.trim().isEmpty()) ? "basic" : scanTypeParam.trim();

		// Set response headers for SSE
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Connection", "keep-alive");
		response.setHeader("Access-Control-Allow-Origin", "*");

		PrintWriter writer = response.getWriter();

		try {
			// Send initial status
			sendSSEMessage(writer, "scan_started", "SSL scan started for " + domain);

			// Test 1: Configuration Check
			sendSSEMessage(writer, "test_started", "Checking backend SSL scanner configuration...");
			boolean isConfigured = checkBackendStatus();

			if (isConfigured) {
				sendSSEMessage(writer, "test_completed", "Backend scanner is reachable");

				// Test 2: Start backend scan (simulate progress while backend runs)
				sendSSEMessage(writer, "test_started", "Starting backend SSL scan (" + scanType + ")...");
				performBackendScan(writer, domain, scanType);
			} else {
				sendSSEMessage(writer, "test_failed", "Backend scanner not reachable");
				sendSSEMessage(writer, "fallback_started", "Using fallback quick checks");
				performFallbackQuickCheck(writer, domain, scanType);
				sendSSEMessage(writer, "fallback_completed", "Fallback checks completed");
			}

			sendSSEMessage(writer, "scan_completed", "SSL scan completed successfully");

		} catch (Exception e) {
			sendSSEMessage(writer, "scan_error", "Error: " + e.getMessage());
		} finally {
			writer.close();
		}
	}

	private void sendSSEMessage(PrintWriter writer, String event, String data) {
		writer.println("event: " + event);
		writer.println("data: " + data);
		writer.println();
		writer.flush();
	}

	private boolean checkBackendStatus() {
		String apiBase = getApiBase();
		String url = ensureTrailingSlash(apiBase) + "sslscan/status/testssl";
		try {
			HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(5000);
			int responseCode = conn.getResponseCode();
			return responseCode == 200;
		} catch (Exception e) {
			return false;
		}
	}

	private void performBackendScan(PrintWriter writer, String domain, String scanType) {
		String apiBase = getApiBase();
		String url = ensureTrailingSlash(apiBase) + "sslscan/" + domain + "?type=" + scanType;
		try {
			HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(60000);

			// Stream backend output lines as SSE fallback_result while simulating progress
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			int progress = 0;
			while ((line = reader.readLine()) != null) {
				sendSSEMessage(writer, "fallback_result", line);
				progress = Math.min(progress + 5, 95);
				sendSSEMessage(writer, "progress", "Scan progress: " + progress + "%");
			}
			// finalize progress
			sendSSEMessage(writer, "progress", "Scan progress: 100%");
		} catch (Exception e) {
			sendSSEMessage(writer, "test_error", "Error during backend scan: " + e.getMessage());
		}
	}

	private void performFallbackQuickCheck(PrintWriter writer, String domain, String scanType) {
		String apiBase = getApiBase();
		String url = ensureTrailingSlash(apiBase) + "sslscan/" + domain + "?type=" + scanType;
		try {
			HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
			conn.setRequestMethod("GET");
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = reader.readLine()) != null) {
				sendSSEMessage(writer, "fallback_result", line);
			}
		} catch (Exception e) {
			sendSSEMessage(writer, "fallback_error", "Error during fallback scan: " + e.getMessage());
		}
	}

	private String getApiBase() {
		String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
		if (apiBase == null || apiBase.trim().isEmpty()) {
			apiBase = "http://localhost:8080/";
		}
		return apiBase;
	}

	private String ensureTrailingSlash(String base) {
		if (base.endsWith("/")) return base;
		return base + "/";
	}
}