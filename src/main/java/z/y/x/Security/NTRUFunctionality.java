package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import z.y.x.r.LoadPropertyFileFunctionality;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * NTRU Lattice-based Post-Quantum Cryptography Servlet
 * Supports key generation, encryption, and decryption
 * Returns JSON responses for AJAX operations
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class NTRUFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson gson = new Gson();

    private static final String METHOD_CALCULATERSA = "CALCULATE_NTRU";
    private static final String METHOD_GENERATE_KEYS = "GENERATE_KEYS";

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String nextJSP = "/ntrufunctions.jsp";
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
        dispatcher.forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        String publiKeyParam = request.getParameter("publickeyparam");
        String privateKeParam = request.getParameter("privatekeyparam");
        final String message = request.getParameter("message");
        final String methodName = request.getParameter("methodName");
        String keysize = request.getParameter("keysize");
        String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");

        if (METHOD_GENERATE_KEYS.equalsIgnoreCase(methodName)) {
            handleKeyGeneration(request, response, keysize);
            return;
        }

        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {
            String p_ntru = request.getParameter("p_ntru");

            if ("encrypt".equals(encryptdecryptparameter)) {
                handleEncryption(request, response, message, publiKeyParam, p_ntru);
            } else {
                handleDecryption(request, response, message, publiKeyParam, privateKeParam, p_ntru);
            }
        }
    }

    /**
     * Handle NTRU key pair generation
     */
    private void handleKeyGeneration(HttpServletRequest request, HttpServletResponse response, String keysize)
            throws ServletException, IOException {

        String password = request.getParameter("password");
        String salt = request.getParameter("salt");
        String ntruparam = request.getParameter("ntruparam");

        request.getSession().setAttribute("errorMsg", "");

        try {
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("epn") + "ntru/generatekeypair";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_password", password));
            urlParameters.add(new BasicNameValuePair("p_ntru", ntruparam));
            urlParameters.add(new BasicNameValuePair("p_salt", salt));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponseContent(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    request.getSession().setAttribute("errorMsg", errorContent);
                } else {
                    request.getSession().setAttribute("errorMsg", "SYSTEM Error Please Try Later If Problem Persist raise the feature request");
                }
                request.getSession().setAttribute("pubkey", "");
                request.getSession().setAttribute("privKey", "");
                request.getSession().setAttribute("ntru", ntruparam);
                forwardToJsp(request, response);
                return;
            }

            String content = readResponseContent(response1);
            ntrupojo encodedMessage = gson.fromJson(content, ntrupojo.class);

            request.getSession().setAttribute("pubkey", encodedMessage.getPublickey());
            request.getSession().setAttribute("privKey", encodedMessage.getPrivatekey());
            request.getSession().setAttribute("ntru", ntruparam);
            forwardToJsp(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("pubkey", null);
            request.getSession().setAttribute("privKey", null);
            request.getSession().setAttribute("keysize", keysize);
            forwardToJsp(request, response);
        }
    }

    /**
     * Handle NTRU encryption - returns JSON response
     */
    private void handleEncryption(HttpServletRequest request, HttpServletResponse response,
                                   String message, String publicKey, String parameterSet) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (message == null || message.trim().isEmpty()) {
            out.print(gson.toJson(NTRUResponse.error("encrypt", parameterSet, "Message is null or empty")));
            return;
        }

        if (publicKey == null || publicKey.trim().isEmpty()) {
            out.print(gson.toJson(NTRUResponse.error("encrypt", parameterSet, "NTRU Public Key cannot be empty for encryption")));
            return;
        }

        try {
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("epn") + "ntru/encrypt";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_key", publicKey));
            urlParameters.add(new BasicNameValuePair("p_ntru", parameterSet));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponseContent(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.print(gson.toJson(NTRUResponse.error("encrypt", parameterSet, "SYSTEM Error: " + errorContent)));
                } else {
                    out.print(gson.toJson(NTRUResponse.error("encrypt", parameterSet, "SYSTEM Error Please Try Later")));
                }
                return;
            }

            String content = readResponseContent(response1);
            ntrupojo encodedMessage = gson.fromJson(content, ntrupojo.class);
            out.print(gson.toJson(NTRUResponse.encryptSuccess(encodedMessage.getMessage(), parameterSet)));

        } catch (Exception e) {
            out.print(gson.toJson(NTRUResponse.error("encrypt", parameterSet, "Error: " + e.getMessage())));
        }
    }

    /**
     * Handle NTRU decryption - returns JSON response
     */
    private void handleDecryption(HttpServletRequest request, HttpServletResponse response,
                                   String message, String publicKey, String privateKey, String parameterSet) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (privateKey == null || privateKey.trim().isEmpty()) {
            out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "NTRU Private Key cannot be empty")));
            return;
        }

        if (publicKey == null || publicKey.trim().isEmpty()) {
            out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "NTRU Public Key cannot be empty")));
            return;
        }

        if (message == null || message.trim().isEmpty()) {
            out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "Encrypted message is null or empty")));
            return;
        }

        boolean isBase64 = Base64.isArrayByteBase64(message.getBytes());
        if (!isBase64) {
            out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "Please provide Base64 encoded value for decryption")));
            return;
        }

        try {
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("epn") + "ntru/decrypt";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_key", publicKey));
            urlParameters.add(new BasicNameValuePair("p_privkey", privateKey));
            urlParameters.add(new BasicNameValuePair("p_ntru", parameterSet));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponseContent(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "SYSTEM Error: " + errorContent)));
                } else {
                    out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "SYSTEM Error Please Try Later")));
                }
                return;
            }

            String content = readResponseContent(response1);
            ntrupojo encodedMessage = gson.fromJson(content, ntrupojo.class);
            out.print(gson.toJson(NTRUResponse.decryptSuccess(encodedMessage.getMessage(), parameterSet)));

        } catch (Exception e) {
            out.print(gson.toJson(NTRUResponse.error("decrypt", parameterSet, "Error: " + e.getMessage())));
        }
    }

    /**
     * Read content from HTTP response
     */
    private String readResponseContent(HttpResponse response) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            content.append(line);
        }
        return content.toString();
    }

    /**
     * Forward to JSP page
     */
    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nextJSP = "/ntrufunctions.jsp";
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
        dispatcher.forward(request, response);
    }
}
