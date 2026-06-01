package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * HTTP client for internal RSA crypto endpoints ({@code ep}/rsa/*).
 * Used by {@link RSAFunctionality} (legacy form) and {@link RsaApiServlet} (JSON).
 */
public final class RsaBackendClient {

    private static final Gson GSON = new Gson();
    private static final Set<String> VALID_KEYSIZES = new HashSet<>(
            Arrays.asList("512", "1024", "2048", "4096"));

    private RsaBackendClient() {
    }

    public static class KeyGenResult {
        public final boolean ok;
        public final String publicKey;
        public final String privateKey;
        public final String keySize;
        public final String error;

        KeyGenResult(boolean ok, String publicKey, String privateKey, String keySize, String error) {
            this.ok = ok;
            this.publicKey = publicKey;
            this.privateKey = privateKey;
            this.keySize = keySize;
            this.error = error;
        }

        static KeyGenResult success(String publicKey, String privateKey, String keySize) {
            return new KeyGenResult(true, publicKey, privateKey, keySize, null);
        }

        static KeyGenResult failure(String error) {
            return new KeyGenResult(false, null, null, null, error);
        }
    }

    public static class TextResult {
        public final boolean ok;
        public final String text;
        public final String error;

        TextResult(boolean ok, String text, String error) {
            this.ok = ok;
            this.text = text;
            this.error = error;
        }

        static TextResult success(String text) {
            return new TextResult(true, text, null);
        }

        static TextResult failure(String error) {
            return new TextResult(false, null, error);
        }
    }

    public static class VerifyResult {
        public final boolean ok;
        public final boolean valid;
        public final String message;
        public final String error;

        VerifyResult(boolean ok, boolean valid, String message, String error) {
            this.ok = ok;
            this.valid = valid;
            this.message = message;
            this.error = error;
        }

        static VerifyResult success(boolean valid, String message) {
            return new VerifyResult(true, valid, message, null);
        }

        static VerifyResult failure(String error) {
            return new VerifyResult(false, false, null, error);
        }
    }

    public static KeyGenResult generateKeys(String keysize) {
        keysize = defaultIfEmpty(trim(keysize), "2048");
        if (!VALID_KEYSIZES.contains(keysize)) {
            return KeyGenResult.failure("Invalid key size — use 512, 1024, 2048, or 4096");
        }
        try {
            String body = getJson("rsa/" + keysize);
            pgppojo keys = GSON.fromJson(body, pgppojo.class);
            if (keys == null || isEmpty(keys.getPubliceKey()) || isEmpty(keys.getPrivateKey())) {
                String err = keys != null ? trim(keys.getErrorMessage()) : "";
                return KeyGenResult.failure(err.isEmpty() ? "Key generation failed" : err);
            }
            return KeyGenResult.success(keys.getPubliceKey(), keys.getPrivateKey(), keysize);
        } catch (Exception e) {
            return KeyGenResult.failure("Key generation failed: " + e.getMessage());
        }
    }

    public static TextResult encrypt(String message, String publicKey, String algorithm) {
        message = trim(message);
        publicKey = trim(publicKey);
        algorithm = defaultEncryptAlgo(algorithm);
        if (message.isEmpty()) {
            return TextResult.failure("Message is required");
        }
        if (!isPublicKey(publicKey)) {
            return TextResult.failure("Invalid RSA public key format");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_key", publicKey));
            params.add(new BasicNameValuePair("p_algo", algorithm));

            String raw = postForm("rsa/encrypt", params);
            EncodedMessage em = GSON.fromJson(raw, EncodedMessage.class);
            if (em == null || isEmpty(em.getBase64Encoded())) {
                String err = em != null ? trim(em.getErrorMessage()) : "";
                return TextResult.failure(err.isEmpty() ? "Encryption returned empty result" : err);
            }
            return TextResult.success(em.getBase64Encoded());
        } catch (Exception e) {
            return TextResult.failure("Encryption failed: " + e.getMessage());
        }
    }

    public static TextResult decrypt(String ciphertext, String privateKey, String algorithm) {
        ciphertext = trim(ciphertext);
        privateKey = trim(privateKey);
        algorithm = defaultEncryptAlgo(algorithm);
        if (ciphertext.isEmpty()) {
            return TextResult.failure("Ciphertext is required");
        }
        if (!Base64.isArrayByteBase64(ciphertext.getBytes(StandardCharsets.UTF_8))) {
            return TextResult.failure("Ciphertext must be Base64-encoded");
        }
        if (!isPrivateKey(privateKey)) {
            return TextResult.failure("Invalid RSA private key format");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", ciphertext));
            params.add(new BasicNameValuePair("p_key", privateKey));
            params.add(new BasicNameValuePair("p_algo", algorithm));

            String raw = postForm("rsa/rsadecrypt", params);
            EncodedMessage em = GSON.fromJson(raw, EncodedMessage.class);
            if (em == null || isEmpty(em.getMessage())) {
                String err = em != null ? trim(em.getErrorMessage()) : "";
                return TextResult.failure(err.isEmpty() ? "Decryption returned empty result" : err);
            }
            return TextResult.success(em.getMessage());
        } catch (Exception e) {
            return TextResult.failure("Decryption failed: " + e.getMessage());
        }
    }

    public static TextResult sign(String message, String privateKey, String algorithm) {
        message = trim(message);
        privateKey = trim(privateKey);
        algorithm = defaultSignAlgo(algorithm);
        if (message.isEmpty()) {
            return TextResult.failure("Message is required");
        }
        if (!isPrivateKey(privateKey)) {
            return TextResult.failure("Invalid RSA private key format");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_key", privateKey));
            params.add(new BasicNameValuePair("p_algo", algorithm));

            String raw = postForm("rsa/sign", params);
            String sig = unwrapQuotedJsonString(raw);
            if (sig.isEmpty()) {
                return TextResult.failure("Signing returned empty result");
            }
            return TextResult.success(sig);
        } catch (Exception e) {
            return TextResult.failure("Signing failed: " + e.getMessage());
        }
    }

    public static VerifyResult verify(String message, String publicKey, String signature, String algorithm) {
        message = trim(message);
        publicKey = trim(publicKey);
        signature = trim(signature);
        algorithm = defaultSignAlgo(algorithm);
        if (message.isEmpty()) {
            return VerifyResult.failure("Message is required");
        }
        if (signature.isEmpty()) {
            return VerifyResult.failure("Signature is required (Base64)");
        }
        if (!isPublicKey(publicKey)) {
            return VerifyResult.failure("Invalid RSA public key format");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_key", publicKey));
            params.add(new BasicNameValuePair("p_algo", algorithm));
            params.add(new BasicNameValuePair("p_sig", signature));

            String raw = postForm("rsa/verify", params);
            boolean valid = raw.contains("Passed") || raw.toLowerCase().contains("valid");
            String label = valid ? "VALID" : "INVALID";
            return VerifyResult.success(valid, label + " — " + raw.trim());
        } catch (Exception e) {
            return VerifyResult.failure("Verification failed: " + e.getMessage());
        }
    }

    static boolean isPublicKey(String key) {
        String k = trim(key);
        return k.contains("BEGIN PUBLIC KEY") || k.contains("BEGIN RSA PUBLIC KEY");
    }

    static boolean isPrivateKey(String key) {
        String k = trim(key);
        return k.contains("BEGIN PRIVATE KEY") || k.contains("BEGIN RSA PRIVATE KEY");
    }

    private static String defaultEncryptAlgo(String algo) {
        String a = trim(algo);
        return a.isEmpty() ? "RSA/ECB/OAEPWithSHA-256AndMGF1Padding" : a;
    }

    private static String defaultSignAlgo(String algo) {
        String a = trim(algo);
        return a.isEmpty() ? "SHA256withRSA" : a;
    }

    private static String getJson(String path) throws Exception {
        String base = epBase();
        HttpGet get = new HttpGet(base + path);
        get.addHeader("accept", "application/json");
        HttpResponse response = HttpClientBuilder.create().build().execute(get);
        if (response.getStatusLine().getStatusCode() != 200) {
            throw new IllegalStateException("RSA backend returned HTTP " + response.getStatusLine().getStatusCode());
        }
        return EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
    }

    private static String postForm(String path, List<NameValuePair> params) throws Exception {
        String base = epBase();
        HttpPost post = new HttpPost(base + path);
        post.setEntity(new UrlEncodedFormEntity(params, StandardCharsets.UTF_8));
        post.addHeader("accept", "application/json");
        HttpResponse response = HttpClientBuilder.create().build().execute(post);
        if (response.getStatusLine().getStatusCode() != 200) {
            String errBody = "";
            if (response.getEntity() != null) {
                errBody = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
            }
            throw new IllegalStateException("RSA backend HTTP " + response.getStatusLine().getStatusCode()
                    + (errBody.isEmpty() ? "" : ": " + errBody));
        }
        StringBuilder content = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(response.getEntity().getContent(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
        }
        return content.toString();
    }

    private static String epBase() {
        String base = z.y.x.r.LoadPropertyFileFunctionality.getConfigProperty().get("ep");
        if (base == null || base.trim().isEmpty()) {
            throw new IllegalStateException("RSA backend endpoint not configured");
        }
        return base;
    }

    static String unwrapQuotedJsonString(String raw) {
        if (raw == null) {
            return "";
        }
        String s = raw.trim();
        if (s.length() >= 2 && s.startsWith("\"") && s.endsWith("\"")) {
            s = s.substring(1, s.length() - 1);
        }
        return s.replace("\\n", "\n").replace("\\r", "\r").replace("\\t", "\t");
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String defaultIfEmpty(String value, String fallback) {
        return value == null || value.isEmpty() ? fallback : value;
    }
}
