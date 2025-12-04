package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
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
 * ElGamal Encryption/Decryption Servlet
 * Returns structured JSON responses
 * @author Anish Nath
 */
public class ELGAMALFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String METHOD_CALCULATERSA = "CALCULATE_ELGAMAL";
    private final Gson gson = new Gson();

    /**
     * Handle GET requests - Key generation
     */
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        String keysize = request.getParameter("keysize");

        int keys = 160;
        if (keysize != null && keysize.trim().length() > 0) {
            try {
                try {
                    keys = Integer.parseInt(keysize);
                } catch (NumberFormatException w) {
                    keys = 160;
                }

                if (keys > 512) {
                    keys = 160;
                }

                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "elgamal/" + keysize;

                HttpGet getRequest = new HttpGet(url1);
                getRequest.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(getRequest);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();
                    out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
                    return;
                }

                BufferedReader br = new BufferedReader(
                        new InputStreamReader((response1.getEntity().getContent()))
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }
                elgamlpojo elgamlpojo = gson.fromJson(content.toString(), elgamlpojo.class);

                request.getSession().setAttribute("pubkey", elgamlpojo.getPublicKey());
                request.getSession().setAttribute("privKey", elgamlpojo.getPrivateKey());
                request.getSession().setAttribute("keysize", keysize);

                String nextJSP = "/elgamalfunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);

                return;
            } catch (Exception ex) {
                // DO NOTHING
            }
        }
    }

    /**
     * Handle POST requests - Encrypt/Decrypt operations
     * Returns JSON response
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String publiKeyParam = request.getParameter("publickeyparam");
        String privateKeParam = request.getParameter("privatekeyparam");
        final String message = request.getParameter("message");
        String algo = request.getParameter("cipherparameter");
        final String methodName = request.getParameter("methodName");
        String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");

        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {

            if (algo == null || algo.length() == 0) {
                algo = "ELGAMAL";
            }

            if ("encrypt".equals(encryptdecryptparameter)) {
                handleEncrypt(out, message, publiKeyParam, algo);
            } else {
                handleDecrypt(out, message, privateKeParam, algo);
            }
        } else {
            out.println(gson.toJson(ElGamalResponse.error("Invalid method name")));
        }
    }

    /**
     * Handle encryption operation
     */
    private void handleEncrypt(PrintWriter out, String message, String publicKey, String algo) {
        // Validate message
        if (null == message || message.trim().length() == 0) {
            out.println(gson.toJson(ElGamalResponse.error("encrypt", "Message is null or empty")));
            return;
        }

        // Validate public key
        if (publicKey == null || publicKey.trim().length() == 0) {
            out.println(gson.toJson(ElGamalResponse.error("encrypt", algo + " Public Key cannot be empty")));
            return;
        }

        try {
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "elgamal/encrypt";
            HttpPost post = new HttpPost(url1);

            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_key", publicKey));
            urlParameters.add(new BasicNameValuePair("p_algo", algo));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponse(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.println(gson.toJson(ElGamalResponse.error("encrypt", "System Error: " + errorContent)));
                } else {
                    out.println(gson.toJson(ElGamalResponse.error("encrypt", "System Error. Please try later. If problem persists, raise a feature request.")));
                }
                return;
            }

            String responseContent = readResponse(response1);
            EncodedMessage encodedMessage = gson.fromJson(responseContent, EncodedMessage.class);

            ElGamalResponse resp = ElGamalResponse.encryptSuccess(encodedMessage.getBase64Encoded(), algo);
            out.println(gson.toJson(resp));

        } catch (Exception e) {
            out.println(gson.toJson(ElGamalResponse.error("encrypt", "Encryption failed: " + e.getMessage())));
        }
    }

    /**
     * Handle decryption operation
     */
    private void handleDecrypt(PrintWriter out, String message, String privateKey, String algo) {
        // Validate private key
        if (privateKey == null || privateKey.trim().length() == 0) {
            out.println(gson.toJson(ElGamalResponse.error("decrypt", algo + " Private Key cannot be empty")));
            return;
        }

        // Validate message
        if (null == message || message.trim().length() == 0) {
            out.println(gson.toJson(ElGamalResponse.error("decrypt", "Encrypted message is null or empty")));
            return;
        }

        // Validate Base64 encoding
        boolean isBase64 = Base64.isArrayByteBase64(message.getBytes());
        if (!isBase64) {
            out.println(gson.toJson(ElGamalResponse.error("decrypt", "Please provide Base64 encoded ciphertext. Failed to decrypt.")));
            return;
        }

        try {
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "elgamal/decrypt";
            HttpPost post = new HttpPost(url1);

            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_privatekey", privateKey));
            urlParameters.add(new BasicNameValuePair("p_algo", algo));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponse(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.println(gson.toJson(ElGamalResponse.error("decrypt", "System Error: " + errorContent)));
                } else {
                    out.println(gson.toJson(ElGamalResponse.error("decrypt", "System Error. Please try later. If problem persists, raise a feature request.")));
                }
                return;
            }

            String responseContent = readResponse(response1);
            EncodedMessage encodedMessage = gson.fromJson(responseContent, EncodedMessage.class);

            ElGamalResponse resp = ElGamalResponse.decryptSuccess(encodedMessage.getMessage(), algo);
            out.println(gson.toJson(resp));

        } catch (Exception e) {
            out.println(gson.toJson(ElGamalResponse.error("decrypt", "Decryption failed: " + e.getMessage())));
        }
    }

    /**
     * Helper method to read HTTP response content
     */
    private String readResponse(HttpResponse response) throws IOException {
        BufferedReader br = new BufferedReader(
                new InputStreamReader((response.getEntity().getContent()))
        );
        StringBuilder content = new StringBuilder();
        String line;
        while (null != (line = br.readLine())) {
            content.append(line);
        }
        return content.toString();
    }
}
