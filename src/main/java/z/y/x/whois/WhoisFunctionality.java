package z.y.x.whois;

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

/**
 * Servlet to proxy WHOIS lookup API.
 * Accepts query parameter: domain
 * Calls property API: {api}/whois/<domain>
 * Returns the JSON from the upstream API.
 */
public class WhoisFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String domain = req.getParameter("domain");
        if (domain == null || domain.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing required parameter: domain\"}");
            return;
        }

        domain = domain.trim();
        
        // Basic domain format validation
        if (!isValidDomain(domain)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid domain format. Please enter a valid domain name.\"}");
            return;
        }

        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }

        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }

        String url = apiBase + "whois/" + domain;

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
     * Validates if the domain format is valid
     * @param domain The domain to validate
     * @return true if domain format is valid, false otherwise
     */
    private boolean isValidDomain(String domain) {
        // Basic domain validation regex
        String domainRegex = "^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*$";
        return domain.matches(domainRegex) && domain.length() > 0 && domain.length() <= 253;
    }
}







