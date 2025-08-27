package z.y.x.Network;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * MTR (My TraceRoute) Servlet for network path analysis
 * Proxies requests to backend MTR API: {api}/mtr/{target}
 * 
 * @author anishnath
 */
public class MTRFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    // Validation patterns
    private static final Pattern IP_PATTERN = Pattern.compile(
        "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    );
    private static final Pattern DOMAIN_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*$"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Extract target from path parameter
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Target parameter is required\"}");
                return;
            }
            
            String target = pathInfo.substring(1); // Remove leading slash
            
            // Validate target
            if (!isValidTarget(target)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid target. Must be a valid domain or public IP address\"}");
                return;
            }
            
            // Build the backend API URL
            String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
            if (apiBase == null || apiBase.trim().isEmpty()) {
                apiBase = "http://localhost:8080/";
            }
            
            if (!apiBase.endsWith("/")) {
                apiBase = apiBase + "/";
            }
            
            // Build URL with query parameters
            StringBuilder urlBuilder = new StringBuilder(apiBase + "mtr/" + target);
            String mode = request.getParameter("mode");
            String packets = request.getParameter("packets");
            String interval = request.getParameter("interval");
            String timeout = request.getParameter("timeout");
            String maxHops = request.getParameter("maxHops");
            
            boolean hasParams = false;
            if (mode != null && !mode.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("mode=").append(mode);
                hasParams = true;
            }
            if (packets != null && !packets.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("packets=").append(packets);
                hasParams = true;
            }
            if (interval != null && !interval.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("interval=").append(interval);
                hasParams = true;
            }
            if (timeout != null && !timeout.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("timeout=").append(timeout);
                hasParams = true;
            }
            if (maxHops != null && !maxHops.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("max_hops=").append(maxHops);
                hasParams = true;
            }
            
            String url = urlBuilder.toString();
            
            // Make HTTP request to backend API
            DefaultHttpClient httpClient = new DefaultHttpClient();
            HttpGet getRequest = new HttpGet(url);
            getRequest.addHeader("accept", "application/json");
            
            try {
                HttpResponse apiResponse = httpClient.execute(getRequest);
                int status = apiResponse.getStatusLine().getStatusCode();
                response.setStatus(status);
                
                // Stream the response from backend API
                BufferedReader br = new BufferedReader(new InputStreamReader(apiResponse.getEntity().getContent()));
                StringBuilder content = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    content.append(line);
                }
                response.getWriter().write(content.toString());
                
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Backend MTR API request failed: " + e.getMessage() + "\"}");
            } finally {
                httpClient.getConnectionManager().shutdown();
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Internal server error: " + e.getMessage() + "\"}");
        }
    }
    
    private boolean isValidTarget(String target) {
        if (target == null || target.trim().isEmpty()) {
            return false;
        }
        
        // Check if it's a valid IP address
        if (IP_PATTERN.matcher(target).matches()) {
            try {
                InetAddress addr = InetAddress.getByName(target);
                return !addr.isLoopbackAddress() && 
                       !addr.isLinkLocalAddress() && 
                       !addr.isSiteLocalAddress() &&
                       !addr.isMulticastAddress();
            } catch (UnknownHostException e) {
                return false;
            }
        }
        
        // Check if it's a valid domain
        if (DOMAIN_PATTERN.matcher(target).matches()) {
            return true;
        }
        
        return false;
    }
}
