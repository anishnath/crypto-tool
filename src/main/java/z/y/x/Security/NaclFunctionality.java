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
import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * NaCl (libsodium) Encryption/Decryption Servlet
 * Supports: XSalsa20, AEAD, Box, SealedBox
 * Returns structured JSON responses
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class NaclFunctionality extends HttpServlet {

    private static final String METHOD_XSALSA20 = "NACL_crypto_stream_xsalsa20_xor";
    private static final String METHOD_AEAD = "AEAD_MESSAGE";
    private static final String METHOD_BOX = "NACL_BOX_ENCRYPT";
    private static final String METHOD_SEALBOX = "NACL_SEALBOX_ENCRYPT";

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/naclencdec.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        final String methodName = request.getParameter("methodName");

        if (METHOD_XSALSA20.equalsIgnoreCase(methodName)) {
            handleXSalsa20(request, out);
        } else if (METHOD_AEAD.equalsIgnoreCase(methodName)) {
            handleAEAD(request, out);
        } else if (METHOD_BOX.equalsIgnoreCase(methodName)) {
            handleBox(request, out);
        } else if (METHOD_SEALBOX.equalsIgnoreCase(methodName)) {
            handleSealBox(request, out);
        } else {
            out.println(gson.toJson(NaclResponse.error("Invalid method name")));
        }
    }

    /**
     * Handle XSalsa20 stream cipher encryption/decryption
     */
    private void handleXSalsa20(HttpServletRequest request, PrintWriter out) {
        String secretkey = request.getParameter("secretkey");
        String encryptorDecrypt = request.getParameter("encryptorDecrypt");
        String plaintext = request.getParameter("plaintext");
        String nonce = request.getParameter("nonce");

        // Validation
        if (secretkey == null || secretkey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", "Secret Key is null or empty")));
            return;
        }
        if (secretkey.length() != 32) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", "Secret Key must be 32 characters")));
            return;
        }
        if (plaintext == null || plaintext.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", "Text is null or empty")));
            return;
        }
        if (nonce == null || nonce.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", "Nonce is empty or null")));
            return;
        }
        if (nonce.trim().length() < 48) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", "Nonce must be 24 bytes in Hex (48 characters)")));
            return;
        }

        try {
            String url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +
                ("decrypt".equalsIgnoreCase(encryptorDecrypt) ? "nacl/decrypt" : "nacl/encrypt");

            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", plaintext));
            params.add(new BasicNameValuePair("p_nonce", nonce));
            params.add(new BasicNameValuePair("p_key", secretkey));

            String result = executePost(url, params, out, encryptorDecrypt, "xsalsa20");
            if (result != null) {
                if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                    NaclResponse resp = NaclResponse.decryptSuccess(result, "XSalsa20");
                    resp.setNonce(nonce);
                    out.println(gson.toJson(resp));
                } else {
                    NaclResponse resp = NaclResponse.encryptSuccess(result, "XSalsa20", nonce);
                    out.println(gson.toJson(resp));
                }
            }
        } catch (Exception e) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "xsalsa20", e.getMessage())));
        }
    }

    /**
     * Handle AEAD (xsalsa20poly1305) encryption/decryption
     */
    private void handleAEAD(HttpServletRequest request, PrintWriter out) {
        String secretkey = request.getParameter("secretkey");
        String encryptorDecrypt = request.getParameter("encryptorDecrypt");
        String plaintext = request.getParameter("plaintext");
        String aead = request.getParameter("aead");
        String nonce = request.getParameter("nonce");

        // Validation
        if (secretkey == null || secretkey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "Secret Key is null or empty")));
            return;
        }
        if (secretkey.length() != 32) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "Secret Key must be 32 characters")));
            return;
        }
        if (aead == null || aead.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "AEAD (additional data) is empty")));
            return;
        }
        if (plaintext == null || plaintext.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "Text is null or empty")));
            return;
        }
        if (nonce == null || nonce.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "Nonce is empty or null")));
            return;
        }
        if (nonce.trim().length() < 8) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", "Nonce is invalid")));
            return;
        }

        try {
            String url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +
                ("decrypt".equalsIgnoreCase(encryptorDecrypt) ? "nacl/decrypt/aead" : "nacl/encrypt/aead");

            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", plaintext));
            params.add(new BasicNameValuePair("p_nonce", nonce));
            params.add(new BasicNameValuePair("p_key", secretkey));
            params.add(new BasicNameValuePair("p_aead", aead));

            String result = executePost(url, params, out, encryptorDecrypt, "aead");
            if (result != null) {
                NaclResponse resp;
                if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                    resp = NaclResponse.decryptSuccess(result, "XSalsa20-Poly1305 (AEAD)");
                } else {
                    resp = NaclResponse.encryptSuccess(result, "XSalsa20-Poly1305 (AEAD)");
                }
                resp.setNonce(nonce);
                resp.setAead(aead);
                out.println(gson.toJson(resp));
            }
        } catch (Exception e) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "aead", e.getMessage())));
        }
    }

    /**
     * Handle Box (curve25519xsalsa20poly1305) encryption/decryption
     */
    private void handleBox(HttpServletRequest request, PrintWriter out) {
        String encryptorDecrypt = request.getParameter("encryptdecryptparameter");
        String plaintext = request.getParameter("message");
        String publicKey = request.getParameter("publickeyparam");
        String privateKey = request.getParameter("privatekeyparam");
        String nonce = request.getParameter("nonce");

        // Validation
        if (publicKey == null || publicKey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Public Key is empty")));
            return;
        }
        if (publicKey.length() != 64) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Public Key must be 32 bytes in Hex (64 characters)")));
            return;
        }
        if (privateKey == null || privateKey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Private Key is empty")));
            return;
        }
        if (privateKey.length() != 64) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Private Key must be 32 bytes in Hex (64 characters)")));
            return;
        }
        if (plaintext == null || plaintext.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Message is null or empty")));
            return;
        }
        if (nonce == null || nonce.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Nonce is empty or null")));
            return;
        }
        if (nonce.trim().length() < 8) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", "Nonce is invalid")));
            return;
        }

        try {
            String url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +
                ("decrypt".equalsIgnoreCase(encryptorDecrypt) ? "nacl/box/decrypt" : "nacl/box/encrypt");

            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", plaintext));
            params.add(new BasicNameValuePair("p_nonce", nonce));
            params.add(new BasicNameValuePair("p_key", privateKey));
            params.add(new BasicNameValuePair("p_pubkey", publicKey));

            String result = executePost(url, params, out, encryptorDecrypt, "box");
            if (result != null) {
                NaclResponse resp;
                if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                    resp = NaclResponse.decryptSuccess(result, "Curve25519-XSalsa20-Poly1305 (Box)");
                } else {
                    resp = NaclResponse.encryptSuccess(result, "Curve25519-XSalsa20-Poly1305 (Box)");
                }
                resp.setNonce(nonce);
                out.println(gson.toJson(resp));
            }
        } catch (Exception e) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "box", e.getMessage())));
        }
    }

    /**
     * Handle SealedBox encryption/decryption
     */
    private void handleSealBox(HttpServletRequest request, PrintWriter out) {
        String encryptorDecrypt = request.getParameter("encryptdecryptparameter");
        String plaintext = request.getParameter("message");
        String publicKey = request.getParameter("publickeyparam");
        String privateKey = request.getParameter("privatekeyparam");

        // Validation
        if (publicKey == null || publicKey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", "Public Key is empty")));
            return;
        }
        if (publicKey.length() != 64) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", "Public Key must be 32 bytes in Hex (64 characters)")));
            return;
        }
        if (privateKey == null || privateKey.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", "Private Key is empty")));
            return;
        }
        if (privateKey.length() != 64) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", "Private Key must be 32 bytes in Hex (64 characters)")));
            return;
        }
        if (plaintext == null || plaintext.trim().isEmpty()) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", "Message is null or empty")));
            return;
        }

        try {
            String url;
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", plaintext));

            if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "nacl/box/seal/decrypt";
                params.add(new BasicNameValuePair("p_key", privateKey));
                params.add(new BasicNameValuePair("p_pubkey", publicKey));
            } else {
                url = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "nacl/box/seal/encrypt";
                params.add(new BasicNameValuePair("p_pubkey", publicKey));
            }

            String result = executePost(url, params, out, encryptorDecrypt, "sealedbox");
            if (result != null) {
                NaclResponse resp;
                if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                    resp = NaclResponse.decryptSuccess(result, "X25519-XSalsa20-Poly1305 (SealedBox)");
                } else {
                    resp = NaclResponse.encryptSuccess(result, "X25519-XSalsa20-Poly1305 (SealedBox)");
                }
                out.println(gson.toJson(resp));
            }
        } catch (Exception e) {
            out.println(gson.toJson(NaclResponse.error(encryptorDecrypt, "sealedbox", e.getMessage())));
        }
    }

    /**
     * Execute HTTP POST and return result, or write error response
     */
    private String executePost(String url, List<NameValuePair> params, PrintWriter out,
                               String operation, String algorithm) throws IOException {
        HttpClient client = HttpClientBuilder.create().build();
        HttpPost post = new HttpPost(url);
        post.setEntity(new UrlEncodedFormEntity(params));

        HttpResponse response = client.execute(post);
        int statusCode = response.getStatusLine().getStatusCode();

        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        StringBuilder content = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            content.append(line);
        }

        if (statusCode != 200) {
            String errorMsg = statusCode == 404 ?
                "System Error: " + content.toString() :
                "System Error. Please try later. If problem persists, raise a feature request.";
            out.println(gson.toJson(NaclResponse.error(operation, algorithm, errorMsg)));
            return null;
        }

        return content.toString();
    }
}
