
package z.y.x.Network;

import z.y.x.r.LoadPropertyFileFunctionality;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * HTTP Status Analysis servlet.
 * Proxies requests to the backend API {api}/httpstat
 * Adds test location to the backend response
 * Test location is fixed to "United States, Virginia"
 */
public class HTTPStatFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson gson = new Gson();
    private static final String TEST_LOCATION = "United States, Virginia";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read the JSON request body
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            String jsonRequest = jsonBuilder.toString();

            // Validate JSON
            if (jsonRequest.trim().isEmpty()) {
                sendErrorResponse(response, "No JSON data provided", 400);
                return;
            }

            // Parse and validate the request
            JsonObject requestJson = new JsonParser().parse(jsonRequest).getAsJsonObject();
            if (!requestJson.has("url")) {
                sendErrorResponse(response, "URL is required", 400);
                return;
            }

            // Get API base URL from properties
            String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
            if (apiBase == null || apiBase.trim().isEmpty()) {
                apiBase = "http://localhost:7080/";
            }
            if (!apiBase.endsWith("/")) {
                apiBase = apiBase + "/";
            }

            // Forward request to backend API
            String backendResponse = forwardToBackend(jsonRequest, apiBase + "httpstat");

            // Add test location to backend response
            String enhancedResponse = addTestLocation(backendResponse);

            // Send response back to client
            response.getWriter().write(enhancedResponse);

        } catch (Exception e) {
            sendErrorResponse(response, "Error processing request: " + e.getMessage(), 500);
        }
    }

    private String forwardToBackend(String jsonRequest, String backendUrl) throws IOException {
        URL url = new URL(backendUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);
            connection.setConnectTimeout(30000);
            connection.setReadTimeout(60000);

            // Send the JSON request
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonRequest.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Read the response
            int responseCode = connection.getResponseCode();
            if (responseCode >= 200 && responseCode < 300) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    return response.toString();
                }
            } else {
                // Handle error response
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    return response.toString();
                }
            }

        } finally {
            connection.disconnect();
        }
    }

    private String addTestLocation(String backendResponse) {
        try {
            // Parse the backend response
            JsonObject responseJson = new JsonParser().parse(backendResponse).getAsJsonObject();

            // Add test location
            responseJson.addProperty("test_location", TEST_LOCATION);

            return gson.toJson(responseJson);

        } catch (Exception e) {
            // If parsing fails, return original response with test location wrapper
            JsonObject wrapper = new JsonObject();
            wrapper.addProperty("original_response", backendResponse);
            wrapper.addProperty("test_location", TEST_LOCATION);
            wrapper.addProperty("error", "Failed to parse backend response: " + e.getMessage());

            return gson.toJson(wrapper);
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int status)
            throws IOException {
        response.setStatus(status);
        JsonObject errorJson = new JsonObject();
        errorJson.addProperty("error", message);
        errorJson.addProperty("status", "error");
        errorJson.addProperty("test_location", TEST_LOCATION);
        response.getWriter().write(gson.toJson(errorJson));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("HTTP Status Tool - Use POST method with JSON data<br>Test Location: " + TEST_LOCATION);
    }
}
