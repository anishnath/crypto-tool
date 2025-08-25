package z.y.x.subdomain;

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
 * Servlet to proxy subdomain enumeration API.
 * Accepts query parameter "domain" and calls property API: {api}/subdomains/<domain>
 * Returns the JSON from the upstream API.
 */
public class SubdomainFunctionality extends HttpServlet {

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

        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = "http://localhost:8080/";
        }

        if (!apiBase.endsWith("/")) {
            apiBase = apiBase + "/";
        }

        String url = apiBase + "subdomains/" + domain.trim();

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
}


