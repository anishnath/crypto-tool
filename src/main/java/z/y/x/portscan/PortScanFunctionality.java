package z.y.x.portscan;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.regex.Pattern;

/**
 * Servlet to proxy port scanning API.
 * Accepts query parameters: target, scan_type, ports
 * Calls property API: {api}/portscan/<target>?scan_type=<type>&ports=<ports>
 * Returns the JSON from the upstream API.
 */
public class PortScanFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Private network patterns
    private static final Pattern PRIVATE_NETWORKS = Pattern.compile(
        "^(10\\.|172\\.(1[6-9]|2[0-9]|3[01])\\.|192\\.168\\.|127\\.|169\\.254\\.|224\\.|240\\.|0\\.|255\\.255\\.255\\.255$)"
    );
    
    // Localhost patterns
    private static final Pattern LOCALHOST_PATTERNS = Pattern.compile(
        "^(localhost|127\\.0\\.0\\.1|::1|0\\.0\\.0\\.0|0\\.0\\.0\\.0:.*)$"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String target = req.getParameter("target");
        if (target == null || target.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: target\"}");
            return;
        }

        target = target.trim();
        
        // Validate target for security
        if (!isValidTarget(target)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"error\":\"Scanning of private networks, localhost, or reserved IP addresses is not allowed for security reasons. Please use public IP addresses or domain names only.\"}");
            return;
        }

        String scanType = req.getParameter("scan_type");
        if (scanType == null || scanType.trim().isEmpty()) {
            scanType = "quick"; // default scan type
        }

        String ports = req.getParameter("ports");
        
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }

        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }

        // Build the URL with parameters
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(apiBase).append("portscan/").append(target);
        
        if (scanType != null && !scanType.trim().isEmpty()) {
            urlBuilder.append("?scan_type=").append(scanType.trim());
            
            if (ports != null && !ports.trim().isEmpty() && "custom".equals(scanType)) {
                urlBuilder.append("&ports=").append(ports.trim());
            }
        }

        String url = urlBuilder.toString();

        DefaultHttpClient httpClient = new DefaultHttpClient();
        HttpGet getRequest = new HttpGet(url);
        getRequest.addHeader("accept", "application/json");

        try {
            HttpResponse response = httpClient.execute(getRequest);
            int status = response.getStatusLine().getStatusCode();
            resp.setStatus(status);

            BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
            resp.getWriter().write(content.toString());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Upstream request failed\"}");
        }
    }

    /**
     * Validates if the target is safe to scan
     * @param target The target to validate
     * @return true if target is safe, false otherwise
     */
    private boolean isValidTarget(String target) {
        // Check for localhost patterns
        if (LOCALHOST_PATTERNS.matcher(target.toLowerCase()).matches()) {
            return false;
        }

        // Check for private network patterns
        if (PRIVATE_NETWORKS.matcher(target).matches()) {
            return false;
        }

        // Try to resolve the target to check if it's a private IP
        try {
            InetAddress addr = InetAddress.getByName(target);
            if (addr.isLoopbackAddress() || addr.isLinkLocalAddress() || 
                addr.isSiteLocalAddress() || addr.isAnyLocalAddress()) {
                return false;
            }
            
            // Check if it's a private IP address
            String hostAddress = addr.getHostAddress();
            if (PRIVATE_NETWORKS.matcher(hostAddress).matches()) {
                return false;
            }
            
        } catch (UnknownHostException e) {
            // If we can't resolve it, it might be a domain name - allow it
            // as it will be resolved by the upstream API
            return true;
        }

        return true;
    }
}
