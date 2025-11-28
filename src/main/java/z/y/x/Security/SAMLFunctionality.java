package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import org.xml.sax.helpers.DefaultHandler;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.XMLConstants;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

/**
 * SAML Functionality Servlet - Sign and Verify SAML messages
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class SAMLFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_SIGN_XML = "SIGN_XML";
    private static final String METHOD_VERIFY_SIGNATURE_OR_DECODE = "VERIFY_SIGNATURE_OR_DECODE";

    private final Gson gson = new Gson();

    public SAMLFunctionality() {
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println(gson.toJson(SAMLResponse.error("unknown", "GET method not supported. Use POST.")));
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        final String methodName = request.getParameter("methodName");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (METHOD_SIGN_XML.equals(methodName)) {
            handleSignXml(request, out);
        } else if (METHOD_VERIFY_SIGNATURE_OR_DECODE.equals(methodName)) {
            handleVerifyOrDecode(request, out);
        } else {
            out.println(gson.toJson(SAMLResponse.error("unknown", "Unknown method: " + methodName)));
        }
    }

    private void handleSignXml(HttpServletRequest request, PrintWriter out) {
        String p_relaystate = request.getParameter("p_relaystate");
        String p_xml = request.getParameter("p_xml");
        String p_privkey = request.getParameter("p_privkey");
        String p_key = request.getParameter("p_key");
        String passphrase = request.getParameter("passphrase");
        String xmlsignaturealgo = request.getParameter("xmlsignaturealgo");

        // Validation
        if (p_xml == null || p_xml.trim().isEmpty()) {
            out.println(gson.toJson(SAMLResponse.error("sign", "XML is empty or null")));
            return;
        }

        if (p_privkey == null || p_privkey.trim().isEmpty()) {
            out.println(gson.toJson(SAMLResponse.error("sign", "Private Key is required for generating XML Signature")));
            return;
        }

        if (p_key == null || p_key.trim().isEmpty()) {
            out.println(gson.toJson(SAMLResponse.error("sign", "X.509 Certificate is empty or null")));
            return;
        }

        if (passphrase != null && passphrase.trim().length() > 20) {
            out.println(gson.toJson(SAMLResponse.error("sign", "Password length should be less than 20 characters")));
            return;
        }

        // Validate XML
        try {
            SAXParserFactory spf = SAXParserFactory.newInstance();
            spf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
            SAXParser saxParser = spf.newSAXParser();
            InputStream stream = new ByteArrayInputStream(p_xml.getBytes("UTF-8"));
            saxParser.parse(stream, new DefaultHandler());
        } catch (Exception e) {
            out.println(gson.toJson(SAMLResponse.error("sign", "Invalid XML: " + e.getMessage())));
            return;
        }

        try {
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/sign";

            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            post.addHeader("accept", "application/json");

            urlParameters.add(new BasicNameValuePair("p_xml", p_xml));
            urlParameters.add(new BasicNameValuePair("p_key", p_key));
            urlParameters.add(new BasicNameValuePair("p_privkey", p_privkey));
            urlParameters.add(new BasicNameValuePair("p_relaystate", p_relaystate));
            urlParameters.add(new BasicNameValuePair("p_algo", xmlsignaturealgo));
            urlParameters.add(new BasicNameValuePair("p_passphrase", passphrase));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));

            HttpResponse response1 = httpClient.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponseContent(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.println(gson.toJson(SAMLResponse.error("sign", errorContent)));
                } else {
                    out.println(gson.toJson(SAMLResponse.error("sign", "System error. Please try later.")));
                }
                return;
            }

            String content = readResponseContent(response1);
            samlpojo sshpojo = gson.fromJson(content, samlpojo.class);

            if (sshpojo != null) {
                SAMLResponse resp = new SAMLResponse();
                resp.setSuccess(true);
                resp.setOperation("sign");
                resp.setSignedXml(sshpojo.getNode());
                resp.setSignature(sshpojo.getSignature());
                resp.setSignatureAlgorithm(xmlsignaturealgo);

                // Determine message type
                String messageType = "SAMLRequest";
                if (p_xml.contains("samlp:Response")) {
                    messageType = "SAMLResponse";
                }
                resp.setMessageType(messageType);

                // Calculate signature logic for relay state
                if (p_relaystate != null && !p_relaystate.trim().isEmpty() && sshpojo.getSignature() != null) {
                    resp.setRelayState(p_relaystate);
                    String signatureLogic = messageType + "=URLEncode(XMLMessage)&RelayState=URLEncode(" + p_relaystate + ")&SigAlg=URLEncode(" + xmlsignaturealgo + ")";
                    String calculationLogic = "Base64Encode{sign[" + signatureLogic + "]}";
                    resp.setSignatureCalculationLogic(calculationLogic);
                }

                // Get deflated Base64 version for HTTP-Redirect binding / verification
                String deflatedBase64 = getDeflatedBase64(sshpojo.getNode());
                if (deflatedBase64 != null) {
                    resp.setEncodedXml(deflatedBase64);
                }

                out.println(gson.toJson(resp));
            } else {
                out.println(gson.toJson(SAMLResponse.error("sign", "Failed to parse signing response")));
            }

        } catch (Exception ex) {
            out.println(gson.toJson(SAMLResponse.error("sign", "System error: " + ex.getMessage())));
        }
    }

    private void handleVerifyOrDecode(HttpServletRequest request, PrintWriter out) {
        String verifysignatureparameter = request.getParameter("verifysignatureparameter");
        String samlmessage = request.getParameter("samlmessage");
        String x509 = request.getParameter("x509");
        String cipherparameter = request.getParameter("cipherparameter");

        // Validation based on operation type
        if ("verifysignature".equals(verifysignatureparameter)) {
            if (samlmessage == null || samlmessage.trim().isEmpty()) {
                out.println(gson.toJson(SAMLResponse.error("verify", "Please input a SAML Message for verification")));
                return;
            }
            if (x509 == null || x509.trim().isEmpty()) {
                out.println(gson.toJson(SAMLResponse.error("verify", "X.509 certificate is required for SAML signature verification")));
                return;
            }
        } else if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter) ||
                   "samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter)) {
            if (samlmessage == null || samlmessage.trim().isEmpty()) {
                out.println(gson.toJson(SAMLResponse.error("decode", "Please input a SAML Message to decode")));
                return;
            }
        } else {
            out.println(gson.toJson(SAMLResponse.error("unknown", "Invalid operation. Use verifysignature, samlmessagedecoder, or samlmessagedeflate")));
            return;
        }

        try {
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1;

            if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter)) {
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/encode";
            } else if ("samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter)) {
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/base64decodedInflated";
            } else {
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/validatesign";
            }

            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            post.addHeader("accept", "application/json");

            if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter) ||
                "samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter)) {
                urlParameters.add(new BasicNameValuePair("p_xml", samlmessage));
            } else {
                urlParameters.add(new BasicNameValuePair("p_xml", samlmessage));
                urlParameters.add(new BasicNameValuePair("p_key", x509));
                urlParameters.add(new BasicNameValuePair("p_xpath", cipherparameter));
            }

            post.setEntity(new UrlEncodedFormEntity(urlParameters));

            HttpResponse response1 = httpClient.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                String errorContent = readResponseContent(response1);
                if (response1.getStatusLine().getStatusCode() == 404) {
                    out.println(gson.toJson(SAMLResponse.error("verify", errorContent)));
                } else {
                    out.println(gson.toJson(SAMLResponse.error("verify", "System error. Please try later.")));
                }
                return;
            }

            String content = readResponseContent(response1);

            if ("verifysignature".equals(verifysignatureparameter)) {
                SAMLResponse resp = new SAMLResponse();
                resp.setOperation("verify");
                resp.setVerifyTarget(cipherparameter);

                if (content != null && content.contains("Failed")) {
                    resp.setSuccess(true);
                    resp.setVerified(false);
                    resp.setVerificationMessage(content);
                } else {
                    resp.setSuccess(true);
                    resp.setVerified(true);
                    resp.setVerificationMessage(content != null ? content : "Signature verified successfully");
                }
                out.println(gson.toJson(resp));
            } else {
                // Decode operations
                String decodeMode = "samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter) ? "base64" : "deflate";
                out.println(gson.toJson(SAMLResponse.decodeSuccess(content, decodeMode)));
            }

        } catch (Exception ex) {
            out.println(gson.toJson(SAMLResponse.error("verify", "System error: " + ex.getMessage())));
        }
    }

    private String readResponseContent(HttpResponse response) throws IOException {
        BufferedReader br = new BufferedReader(
                new InputStreamReader(response.getEntity().getContent())
        );
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            content.append(line);
        }
        return content.toString();
    }

    /**
     * Calls the deflateEncode endpoint to get DEFLATE+Base64 encoded version of XML
     * This format is used for HTTP-Redirect binding and can be used for verification
     */
    private String getDeflatedBase64(String rawXml) {
        if (rawXml == null || rawXml.trim().isEmpty()) {
            return null;
        }

        try {
            // First Base64 encode the raw XML
            String base64Xml = Base64.getEncoder().encodeToString(rawXml.getBytes(StandardCharsets.UTF_8));

            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/deflateEncode";

            HttpPost post = new HttpPost(url);
            List<NameValuePair> urlParameters = new ArrayList<>();
            post.addHeader("accept", "application/json");

            urlParameters.add(new BasicNameValuePair("p_b64xml", base64Xml));
            post.setEntity(new UrlEncodedFormEntity(urlParameters));

            HttpResponse response = httpClient.execute(post);

            if (response.getStatusLine().getStatusCode() == 200) {
                String content = readResponseContent(response);
                // Response is a JSON string, remove quotes if present
                if (content != null && content.startsWith("\"") && content.endsWith("\"")) {
                    content = content.substring(1, content.length() - 1);
                }
                // Unescape any escaped characters (like \u003d for =)
                if (content != null) {
                    content = content.replace("\\u003d", "=");
                }
                return content;
            }
        } catch (Exception e) {
            // Log error but don't fail the sign operation
            System.err.println("Failed to get deflated Base64: " + e.getMessage());
        }
        return null;
    }
}
