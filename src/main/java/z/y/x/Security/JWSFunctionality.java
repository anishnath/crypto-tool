package z.y.x.Security;

import com.google.gson.Gson;
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
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by aninath on 24/01/20.
 */
public class JWSFunctionality extends HttpServlet {

    private static final String METHOD_GENERATE_JSONKEY = "GENERATE_JSONKEY";

    private static final String METHOD_SIGN_JSON = "SIGN_JSON";
    private static final String METHOD_PARSE_JWS = "PARSE_JWS";
    private static final String METHOD_VERIFY_JWS = "VERIFY_JWS";

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        //out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

        String nextJSP = "/jwsgen.jsp";
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
        dispatcher.forward(request, response);

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        final String methodName = request.getParameter("methodName");

        // Set JSON response for GENERATE_JSONKEY, VERIFY_JWS, SIGN_JSON, and PARSE_JWS methods
        if (METHOD_GENERATE_JSONKEY.equalsIgnoreCase(methodName) || METHOD_VERIFY_JWS.equalsIgnoreCase(methodName) || METHOD_SIGN_JSON.equalsIgnoreCase(methodName) || METHOD_PARSE_JWS.equalsIgnoreCase(methodName)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        }

        PrintWriter out = response.getWriter();

        if (METHOD_VERIFY_JWS.equalsIgnoreCase(methodName)) {

            String serialized = request.getParameter("serialized");
            String publickey = request.getParameter("publickey");
            String sharedsecret = request.getParameter("sharedsecret");
            Gson gson = new Gson();

            if (serialized == null || serialized.length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("verify_jws");
                errorResponse.setErrorMessage("JWS serialized object is null or empty. Please provide a valid JWS token.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            final String t = serialized.trim();

            final int dot1 = t.indexOf(".");
            if (dot1 == -1) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("verify_jws");
                errorResponse.setErrorMessage("Invalid JWS format. JWS must contain three parts separated by dots (header.payload.signature).");
                out.println(gson.toJson(errorResponse));
                return;
            }

            final int dot2 = t.indexOf(".", dot1 + 1);
            if (dot2 == -1) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("verify_jws");
                errorResponse.setErrorMessage("Invalid JWS format. JWS must contain three parts separated by dots (header.payload.signature).");
                out.println(gson.toJson(errorResponse));
                return;
            }

            try {

                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/verify";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_sharedsecret", sharedsecret));
                urlParameters.add(new BasicNameValuePair("p_serialized", serialized));
                urlParameters.add(new BasicNameValuePair("p_publickey", publickey));

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("verify_jws");

                    if (response1.getStatusLine().getStatusCode() == 404) {
                        BufferedReader br1 = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );
                        StringBuilder content1 = new StringBuilder();
                        String line;
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }
                        errorResponse.setErrorMessage("System Error: " + content1.toString());
                    } else {
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    }
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                BufferedReader br1 = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );
                StringBuilder content1 = new StringBuilder();
                String line;
                while (null != (line = br1.readLine())) {
                    content1.append(line);
                }

                String message = content1.toString();
                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("verify_jws");
                successResponse.setJwsSerialize(serialized);

                if ("VALID".equalsIgnoreCase(message)) {
                    successResponse.setMessage("VALID");
                    successResponse.setJwsState("Signature verification successful");
                } else {
                    successResponse.setMessage("INVALID");
                    successResponse.setJwsState("Signature verification failed");
                }

                out.println(gson.toJson(successResponse));
                return;

            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("verify_jws");
                errorResponse.setErrorMessage("Error verifying JWS: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            }

        }

        if (METHOD_PARSE_JWS.equalsIgnoreCase(methodName)) {

            String serialized = request.getParameter("serialized");
            Gson gson = new Gson();

            if (serialized == null || serialized.length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("parse_jws");
                errorResponse.setErrorMessage("JWS serialized object is null or empty. Please provide a valid JWS token.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            final String t = serialized.trim();

            final int dot1 = t.indexOf(".");
            if (dot1 == -1) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("parse_jws");
                errorResponse.setErrorMessage("Invalid JWS format. JWS must contain at least two dots separating header, payload, and signature.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            final int dot2 = t.indexOf(".", dot1 + 1);
            if (dot2 == -1) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("parse_jws");
                errorResponse.setErrorMessage("Invalid JWS format. JWS must have the format: header.payload.signature");
                out.println(gson.toJson(errorResponse));
                return;
            }

            try {

                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/parse";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_serialzed", serialized));


                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("parse_jws");

                    if (response1.getStatusLine().getStatusCode() == 404) {
                        BufferedReader br1 = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );
                        StringBuilder content1 = new StringBuilder();
                        String line;
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }
                        errorResponse.setErrorMessage("System Error: " + content1.toString());
                    } else {
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    }
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                BufferedReader br = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                jwspojo jwsResult = gson.fromJson(content.toString(), jwspojo.class);

                // Build structured JSON response
                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("{");
                jsonBuilder.append("\"success\":true,");
                jsonBuilder.append("\"operation\":\"parse_jws\",");

                // Header
                if (jwsResult.getHeader() != null) {
                    jsonBuilder.append("\"jwsHeader\":").append(gson.toJson(jwsResult.getHeader())).append(",");
                }

                // Payload
                if (jwsResult.getPayload() != null) {
                    jsonBuilder.append("\"jwsPayload\":").append(gson.toJson(jwsResult.getPayload())).append(",");
                }

                // Signature
                if (jwsResult.getSignature() != null) {
                    jsonBuilder.append("\"jwsSignature\":").append(gson.toJson(jwsResult.getSignature())).append(",");
                }

                // State
                if (jwsResult.getState() != null) {
                    jsonBuilder.append("\"jwsState\":").append(gson.toJson(jwsResult.getState())).append(",");
                }

                // JWT ID
                if (jwsResult.getJwtid() != null) {
                    jsonBuilder.append("\"jwtId\":").append(gson.toJson(jwsResult.getJwtid())).append(",");
                }

                // Issuer
                if (jwsResult.getIssuer() != null) {
                    jsonBuilder.append("\"issuer\":").append(gson.toJson(jwsResult.getIssuer())).append(",");
                }

                // Subject
                if (jwsResult.getSubject() != null) {
                    jsonBuilder.append("\"subject\":").append(gson.toJson(jwsResult.getSubject())).append(",");
                }

                // Audience Size
                if (jwsResult.getAudienceSize() != null) {
                    jsonBuilder.append("\"audienceSize\":").append(gson.toJson(jwsResult.getAudienceSize())).append(",");
                }

                // Expiration Time
                if (jwsResult.getExpirationTime() != null) {
                    jsonBuilder.append("\"expirationTime\":").append(gson.toJson(jwsResult.getExpirationTime())).append(",");
                }

                // Not Before Time
                if (jwsResult.getNotBeforeTime() != null) {
                    jsonBuilder.append("\"notBeforeTime\":").append(gson.toJson(jwsResult.getNotBeforeTime())).append(",");
                }

                // Issue Time
                if (jwsResult.getIssueTime() != null) {
                    jsonBuilder.append("\"issueTime\":").append(gson.toJson(jwsResult.getIssueTime())).append(",");
                }

                // Encrypted Key (for JWE)
                if (jwsResult.getEncryptedKey() != null) {
                    jsonBuilder.append("\"encryptedKey\":").append(gson.toJson(jwsResult.getEncryptedKey())).append(",");
                }

                // IV (for JWE)
                if (jwsResult.getIv() != null) {
                    jsonBuilder.append("\"iv\":").append(gson.toJson(jwsResult.getIv())).append(",");
                }

                // Cipher Text (for JWE)
                if (jwsResult.getCipherText() != null) {
                    jsonBuilder.append("\"cipherText\":").append(gson.toJson(jwsResult.getCipherText())).append(",");
                }

                // Auth Tag (for JWE)
                if (jwsResult.getAuthTag() != null) {
                    jsonBuilder.append("\"authTag\":").append(gson.toJson(jwsResult.getAuthTag())).append(",");
                }

                // Original serialized input
                jsonBuilder.append("\"originalInput\":").append(gson.toJson(serialized));

                jsonBuilder.append("}");

                out.println(jsonBuilder.toString());
                return;

            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("parse_jws");
                errorResponse.setErrorMessage("Error parsing JWS: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            }

        }

        if (METHOD_GENERATE_JSONKEY.equalsIgnoreCase(methodName)) {
            String algo = request.getParameter("algo");
            String payload = request.getParameter("payload");
            Gson gson = new Gson();

            if (algo == null || algo.length() == 0) {
                algo = "HS256";
            }

            if (payload == null || payload.length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate_jws");
                errorResponse.setErrorMessage("Payload is null or empty. Please provide a JSON payload to sign.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            try {

                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/generatekey";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_payload", payload));

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("generate_jws");
                    errorResponse.setAlgorithm(algo);

                    if (response1.getStatusLine().getStatusCode() == 404) {
                        BufferedReader br1 = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );
                        StringBuilder content1 = new StringBuilder();
                        String line;
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }
                        errorResponse.setErrorMessage("System Error: " + content1.toString());
                    } else {
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    }
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                BufferedReader br = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                jwspojo jwsResult = gson.fromJson(content.toString(), jwspojo.class);

                // Build structured JSON response
                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("generate_jws");
                successResponse.setAlgorithm(algo);
                successResponse.setOriginalMessage(payload);

                if (jwsResult.getHeader() != null) {
                    successResponse.setJwsHeader(jwsResult.getHeader());
                }

                if (jwsResult.getState() != null) {
                    successResponse.setJwsState(jwsResult.getState());
                }

                if (jwsResult.getSerialize() != null) {
                    successResponse.setJwsSerialize(jwsResult.getSerialize());
                }

                if (jwsResult.getSignature() != null) {
                    successResponse.setJwsSignature(jwsResult.getSignature());
                }

                if (jwsResult.getSharedSecret() != null) {
                    successResponse.setSharedSecret(jwsResult.getSharedSecret());
                }

                if (jwsResult.getPrivateKey() != null) {
                    successResponse.setPrivateKey(jwsResult.getPrivateKey());
                }

                if (jwsResult.getPublicKey() != null) {
                    successResponse.setPublicKey(jwsResult.getPublicKey());
                }

                out.println(gson.toJson(successResponse));
                return;

            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate_jws");
                errorResponse.setAlgorithm(algo);
                errorResponse.setErrorMessage("Error generating JWS: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            }

        }

        if (METHOD_SIGN_JSON.equalsIgnoreCase(methodName)) {

            String algo = request.getParameter("algo");
            String payload = request.getParameter("payload");
            String sharedsecret = request.getParameter("sharedsecret");
            String key = request.getParameter("key");
            Gson gson = new Gson();

            if (algo == null || algo.length() == 0) {
                algo = "HS256";
            }

            if (payload == null || payload.length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_jws");
                errorResponse.setAlgorithm(algo);
                errorResponse.setErrorMessage("Payload is null or empty. Please provide a JSON payload to sign.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            // Validation for HMAC algorithms
            if (algo.equalsIgnoreCase("HS256") || algo.equalsIgnoreCase("HS384") || algo.equalsIgnoreCase("HS512")) {
                if (sharedsecret == null || sharedsecret.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("Shared secret is null or empty. Please provide a secret key for HMAC signing.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (sharedsecret.length() < 48 && algo.equalsIgnoreCase("HS384")) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("Shared secret length is too small for HS384. Minimum 48 bytes required.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (sharedsecret.length() < 64 && algo.equalsIgnoreCase("HS512")) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("Shared secret length is too small for HS512. Minimum 64 bytes required.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
            }

            // Validation for RSA algorithms
            if (algo.equalsIgnoreCase("RS256") || algo.equalsIgnoreCase("RS384") || algo.equalsIgnoreCase("RS512") ||
                algo.equalsIgnoreCase("PS256") || algo.equalsIgnoreCase("PS384") || algo.equalsIgnoreCase("PS512")) {
                if (key == null || key.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("PEM key is null or empty. Please provide an RSA private key for signing.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (!((key.contains("BEGIN PRIVATE KEY") && key.contains("END PRIVATE KEY")) ||
                      (key.contains("BEGIN RSA PRIVATE KEY") && key.contains("END RSA PRIVATE KEY")))) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("Invalid RSA private key format. Key must be in PEM format with proper BEGIN/END markers.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
            }

            // Validation for EC algorithms
            if (algo.equalsIgnoreCase("ES256") || algo.equalsIgnoreCase("ES384") || algo.equalsIgnoreCase("ES512")) {
                if (key == null || key.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("PEM key is null or empty. Please provide an EC private key for signing.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (!(key.contains("BEGIN EC PRIVATE KEY") && key.contains("END EC PRIVATE KEY"))) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("Invalid EC private key format. Key must be in PEM format with BEGIN EC PRIVATE KEY/END EC PRIVATE KEY markers.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
            }

            try {

                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/sign";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_payload", payload));
                urlParameters.add(new BasicNameValuePair("p_sharedsecret", sharedsecret));
                urlParameters.add(new BasicNameValuePair("p_key", key));

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_jws");
                    errorResponse.setAlgorithm(algo);

                    if (response1.getStatusLine().getStatusCode() == 404) {
                        BufferedReader br1 = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );
                        StringBuilder content1 = new StringBuilder();
                        String line;
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }
                        errorResponse.setErrorMessage("System Error: " + content1.toString());
                    } else {
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    }
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                BufferedReader br = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                jwspojo jwsResult = gson.fromJson(content.toString(), jwspojo.class);

                // Build structured JSON response
                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("sign_jws");
                successResponse.setAlgorithm(algo);
                successResponse.setOriginalMessage(payload);

                if (jwsResult.getHeader() != null) {
                    successResponse.setJwsHeader(jwsResult.getHeader());
                }

                if (jwsResult.getState() != null) {
                    successResponse.setJwsState(jwsResult.getState());
                }

                if (jwsResult.getSerialize() != null) {
                    successResponse.setJwsSerialize(jwsResult.getSerialize());
                }

                if (jwsResult.getSignature() != null) {
                    successResponse.setJwsSignature(jwsResult.getSignature());
                }

                if (jwsResult.getSharedSecret() != null) {
                    successResponse.setSharedSecret(jwsResult.getSharedSecret());
                }

                if (jwsResult.getPrivateKey() != null) {
                    successResponse.setPrivateKey(jwsResult.getPrivateKey());
                }

                if (jwsResult.getPublicKey() != null) {
                    successResponse.setPublicKey(jwsResult.getPublicKey());
                }

                out.println(gson.toJson(successResponse));
                return;

            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_jws");
                errorResponse.setAlgorithm(algo);
                errorResponse.setErrorMessage("Error signing JWS: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            }

        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }
}
