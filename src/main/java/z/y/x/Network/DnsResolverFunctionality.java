package z.y.x.Network;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import z.y.x.r.LoadPropertyFileFunctionality;


public class DnsResolverFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String resolvers = request.getParameter("resolvers");
            
            if (name == null || name.trim().isEmpty()) {
                sendErrorResponse(out, "Missing required parameter: name");
                return;
            }
            
            // Validate domain name format
            if (!isValidDomain(name)) {
                sendErrorResponse(out, "Invalid domain name format");
                return;
            }
            
            // Build the API URL
            String apiBase = getApiBase();
            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.append(ensureTrailingSlash(apiBase)).append("dnsprop/").append(name);
            
            // Add query parameters
            boolean hasParams = false;
            if (type != null && !type.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("type=").append(type);
                hasParams = true;
            }
            if (resolvers != null && !resolvers.trim().isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("resolvers=").append(resolvers);
            }
            
            String url = urlBuilder.toString();
            
            // Make the HTTP request
            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpGet httpGet = new HttpGet(url);
                
                try (CloseableHttpResponse httpResponse = httpClient.execute(httpGet)) {
                    int statusCode = httpResponse.getStatusLine().getStatusCode();
                    
                    if (statusCode == 200) {
                        HttpEntity entity = httpResponse.getEntity();
                        String responseBody = EntityUtils.toString(entity);
                        out.print(responseBody);
                    } else {
                        sendErrorResponse(out, "Backend API returned status: " + statusCode);
                    }
                }
            }
            
        } catch (Exception e) {
            sendErrorResponse(out, "Error processing request: " + e.getMessage());
        }
    }
    
    private String getApiBase() {
        Map<String, String> config = LoadPropertyFileFunctionality.getConfigProperty();
        return config.getOrDefault("api", "http://localhost:8080/");
    }
    
    private String ensureTrailingSlash(String url) {
        return url.endsWith("/") ? url : url + "/";
    }
    
    private boolean isValidDomain(String domain) {
        if (domain == null || domain.trim().isEmpty()) {
            return false;
        }
        
        String domainRegex = "^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*$";
        return domain.matches(domainRegex) && domain.length() > 0 && domain.length() <= 253;
    }
    
    private void sendErrorResponse(PrintWriter out, String message) {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", message);
        errorResponse.addProperty("status", "error");
        out.print(new Gson().toJson(errorResponse));
    }
}
