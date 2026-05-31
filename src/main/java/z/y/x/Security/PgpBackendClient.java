package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import z.y.x.r.LoadPropertyFileFunctionality;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Shared HTTP client for internal PGP crypto endpoints ({@code ep}/pgp/*).
 * Used by {@link PGPFunctionality} (HTML) and {@link PgpApiServlet} (JSON).
 */
public final class PgpBackendClient {

    private static final Gson GSON = new Gson();
    private static final Pattern IDENTITY_PATTERN = Pattern.compile("[^a-z0-9@. ]", Pattern.CASE_INSENSITIVE);

    private PgpBackendClient() {
    }

    public static class KeyGenRequest {
        public String identity;
        public String passphrase;
        public String keysize;
        public String cipher;
    }

    public static class KeyGenResult {
        public final boolean ok;
        public final String publicKey;
        public final String privateKey;
        public final String error;

        KeyGenResult(boolean ok, String publicKey, String privateKey, String error) {
            this.ok = ok;
            this.publicKey = publicKey;
            this.privateKey = privateKey;
            this.error = error;
        }

        static KeyGenResult success(String publicKey, String privateKey) {
            return new KeyGenResult(true, publicKey, privateKey, null);
        }

        static KeyGenResult failure(String error) {
            return new KeyGenResult(false, null, null, error);
        }
    }

    public static class EncryptResult {
        public final boolean ok;
        public final String encrypted;
        public final String error;

        EncryptResult(boolean ok, String encrypted, String error) {
            this.ok = ok;
            this.encrypted = encrypted;
            this.error = error;
        }

        static EncryptResult success(String encrypted) {
            return new EncryptResult(true, encrypted, null);
        }

        static EncryptResult failure(String error) {
            return new EncryptResult(false, null, error);
        }
    }

    public static class DecryptResult {
        public final boolean ok;
        public final String plaintext;
        public final String error;

        DecryptResult(boolean ok, String plaintext, String error) {
            this.ok = ok;
            this.plaintext = plaintext;
            this.error = error;
        }

        static DecryptResult success(String plaintext) {
            return new DecryptResult(true, plaintext, null);
        }

        static DecryptResult failure(String error) {
            return new DecryptResult(false, null, error);
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

    public static KeyGenResult generateKeys(KeyGenRequest req) {
        if (req == null) {
            return KeyGenResult.failure("Missing request body");
        }
        String identity = trim(req.identity);
        String passphrase = trim(req.passphrase);
        String keysize = defaultIfEmpty(trim(req.keysize), "2048");
        String cipher = defaultIfEmpty(trim(req.cipher), "AES_256");

        if (identity.isEmpty()) {
            return KeyGenResult.failure("Identity is required (name or email)");
        }
        if (IDENTITY_PATTERN.matcher(identity).find()) {
            return KeyGenResult.failure("Invalid identity — use letters, numbers, spaces, @ and . only");
        }
        if (passphrase.isEmpty()) {
            return KeyGenResult.failure("Passphrase is required");
        }

        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_keysize", keysize));
            params.add(new BasicNameValuePair("p_identity", identity));
            params.add(new BasicNameValuePair("p_passpharse", passphrase));
            params.add(new BasicNameValuePair("p_algo", cipher));

            String body = postForm("pgp/pgpkeygen", params);
            pgppojo pgp = GSON.fromJson(body, pgppojo.class);
            if (pgp == null || isEmpty(pgp.getPubliceKey()) || isEmpty(pgp.getPrivateKey())) {
                String err = pgp != null ? trim(pgp.getErrorMessage()) : "";
                return KeyGenResult.failure(err.isEmpty() ? "Key generation failed" : err);
            }
            return KeyGenResult.success(pgp.getPubliceKey(), pgp.getPrivateKey());
        } catch (Exception e) {
            return KeyGenResult.failure("Key generation failed: " + e.getMessage());
        }
    }

    public static EncryptResult encrypt(String message, String publicKey) {
        message = trim(message);
        publicKey = trim(publicKey);
        if (message.isEmpty()) {
            return EncryptResult.failure("Message is required");
        }
        if (publicKey.isEmpty()) {
            return EncryptResult.failure("PGP public key is required");
        }
        if (!publicKey.contains("BEGIN PGP PUBLIC KEY BLOCK") || !publicKey.contains("END PGP PUBLIC KEY BLOCK")) {
            return EncryptResult.failure("Invalid PGP public key format");
        }

        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_publicKey", publicKey));

            String raw = postForm("pgp/pgpencrypt", params);
            String encrypted = unwrapQuotedJsonString(raw);
            if (encrypted.isEmpty()) {
                return EncryptResult.failure("Encryption returned empty result");
            }
            return EncryptResult.success(encrypted);
        } catch (Exception e) {
            return EncryptResult.failure("Encryption failed: " + e.getMessage());
        }
    }

    public static DecryptResult decrypt(String message, String privateKey, String passphrase) {
        message = trim(message);
        privateKey = trim(privateKey);
        passphrase = trim(passphrase);

        if (message.isEmpty()) {
            return DecryptResult.failure("PGP encrypted message is required");
        }
        if (!message.contains("BEGIN PGP MESSAGE") || !message.contains("END PGP MESSAGE")) {
            return DecryptResult.failure("Invalid PGP message format");
        }
        if (passphrase.isEmpty()) {
            return DecryptResult.failure("Passphrase is required");
        }
        if (privateKey.isEmpty()) {
            return DecryptResult.failure("PGP private key is required");
        }
        if (!privateKey.contains("BEGIN PGP PRIVATE KEY BLOCK") || !privateKey.contains("END PGP PRIVATE KEY BLOCK")) {
            return DecryptResult.failure("Invalid PGP private key format");
        }

        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_privateKey", privateKey));
            params.add(new BasicNameValuePair("p_passpharse", passphrase));

            String raw = postForm("pgp/pgpdecrypt", params);
            String plaintext = unwrapQuotedJsonString(raw);
            if (looksLikeDecryptError(plaintext)) {
                return DecryptResult.failure(plaintext);
            }
            return DecryptResult.success(plaintext);
        } catch (Exception e) {
            return DecryptResult.failure("Decryption failed: " + e.getMessage());
        }
    }

    /** Cleartext/detached sign via backend ({@code pgp/pgpsign}) when available. */
    public static TextResult sign(String message, String privateKey, String passphrase) {
        message = trim(message);
        privateKey = trim(privateKey);
        passphrase = trim(passphrase);
        if (message.isEmpty()) {
            return TextResult.failure("Message to sign is required");
        }
        if (passphrase.isEmpty()) {
            return TextResult.failure("Passphrase is required");
        }
        if (privateKey.isEmpty() || !isPrivateKey(privateKey)) {
            return TextResult.failure("Valid PGP private key is required");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", message));
            params.add(new BasicNameValuePair("p_privateKey", privateKey));
            params.add(new BasicNameValuePair("p_passpharse", passphrase));
            String raw = postForm("pgp/pgpsign", params);
            String signed = unwrapQuotedJsonString(raw);
            if (signed.isEmpty()) {
                return TextResult.failure("Signing returned empty result");
            }
            return TextResult.success(signed);
        } catch (Exception e) {
            return TextResult.failure("Signing failed: " + e.getMessage());
        }
    }

    /** Verify signed message or signature block via backend ({@code pgp/pgpverify}). */
    public static VerifyResult verify(String signedMaterial, String publicKey) {
        signedMaterial = trim(signedMaterial);
        publicKey = trim(publicKey);
        if (signedMaterial.isEmpty()) {
            return VerifyResult.failure("Signed message or signature block is required");
        }
        if (publicKey.isEmpty() || !isPublicKey(publicKey)) {
            return VerifyResult.failure("Valid PGP public key is required");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", signedMaterial));
            params.add(new BasicNameValuePair("p_publicKey", publicKey));
            String raw = postForm("pgp/pgpverify", params);
            String result = unwrapQuotedJsonString(raw);
            if (result.isEmpty()) {
                result = trim(raw);
            }
            boolean valid = looksLikeVerifySuccess(result);
            boolean invalid = looksLikeVerifyFailure(result);
            if (invalid) {
                return VerifyResult.success(false, result);
            }
            return VerifyResult.success(valid || !result.isEmpty(), result);
        } catch (Exception e) {
            return VerifyResult.failure("Verification failed: " + e.getMessage());
        }
    }

    /** Analyze key/message/signature packets ({@code pgp/pgpdump}) — same as PGP_DUMP. */
    public static TextResult dump(String armoredInput) {
        armoredInput = trim(armoredInput);
        if (armoredInput.isEmpty()) {
            return TextResult.failure("PGP key, message, or signature block is required");
        }
        if (!isDumpable(armoredInput)) {
            return TextResult.failure("Invalid PGP format — need PUBLIC KEY, PRIVATE KEY, MESSAGE, or SIGNATURE block");
        }
        try {
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("p_msg", armoredInput));
            String raw = postForm("pgp/pgpdump", params);
            String dump = formatDumpResponse(raw);
            if (dump.isEmpty()) {
                return TextResult.failure("Dump returned empty result");
            }
            return TextResult.success(dump);
        } catch (Exception e) {
            return TextResult.failure("PGP dump failed: " + e.getMessage());
        }
    }

    /** Verify detached/file signature ({@code pgp/pgpverifyfile}) — same as VERIFY_PGP_FILE. */
    public static VerifyResult verifyFile(byte[] fileBytes, String fileName, String publicKey) {
        publicKey = trim(publicKey);
        if (fileBytes == null || fileBytes.length == 0) {
            return VerifyResult.failure("Signed file content is required");
        }
        if (publicKey.isEmpty() || !isPublicKey(publicKey)) {
            return VerifyResult.failure("Valid PGP public key is required for verification");
        }
        try {
            String base = LoadPropertyFileFunctionality.getConfigProperty().get("ep");
            if (base == null || base.trim().isEmpty()) {
                throw new IllegalStateException("PGP backend endpoint not configured");
            }
            HttpPost post = new HttpPost(base + "pgp/pgpverifyfile");
            String safeName = fileName == null || fileName.trim().isEmpty() ? "signed-file.bin" : fileName.trim();
            MultipartEntity entity = new MultipartEntity();
            entity.addPart("file", new ByteArrayBody(fileBytes, safeName));
            entity.addPart("pKey", new StringBody(publicKey, "text/plain", StandardCharsets.UTF_8));
            post.setEntity(entity);

            HttpResponse response = HttpClientBuilder.create().build().execute(post);
            String result = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
            if (response.getStatusLine().getStatusCode() != 200) {
                return VerifyResult.failure("Verify backend returned HTTP " + response.getStatusLine().getStatusCode());
            }
            boolean valid = looksLikeVerifySuccess(result) && !looksLikeVerifyFailure(result);
            return VerifyResult.success(valid, trim(result));
        } catch (Exception e) {
            return VerifyResult.failure("File verification failed: " + e.getMessage());
        }
    }

    public static byte[] decodeBase64(String b64) {
        if (b64 == null || b64.trim().isEmpty()) {
            return new byte[0];
        }
        return Base64.getDecoder().decode(b64.replaceAll("\\s+", ""));
    }

    static String formatDumpResponse(String raw) {
        if (raw == null) {
            return "";
        }
        String s = raw.trim();
        if (s.length() >= 2 && s.startsWith("\"") && s.endsWith("\"")) {
            s = s.substring(1, s.length() - 1);
        }
        return s.replace("\\n", "\n").replace("\\r", "\r").replace("\\t", "\t").replace("\"", "");
    }

    static boolean isPublicKey(String key) {
        return key.contains("BEGIN PGP PUBLIC KEY BLOCK") && key.contains("END PGP PUBLIC KEY BLOCK");
    }

    static boolean isPrivateKey(String key) {
        return key.contains("BEGIN PGP PRIVATE KEY BLOCK") && key.contains("END PGP PRIVATE KEY BLOCK");
    }

    static boolean isDumpable(String msg) {
        return (msg.contains("BEGIN PGP MESSAGE") && msg.contains("END PGP MESSAGE"))
                || isPrivateKey(msg)
                || isPublicKey(msg)
                || (msg.contains("BEGIN PGP SIGNATURE") && msg.contains("END PGP SIGNATURE"));
    }

    static boolean looksLikeVerifySuccess(String result) {
        String lower = trim(result).toLowerCase();
        return lower.contains("verified")
                || lower.contains("good signature")
                || lower.contains("valid");
    }

    static boolean looksLikeVerifyFailure(String result) {
        String lower = trim(result).toLowerCase();
        return lower.contains("bad signature")
                || lower.contains("invalid")
                || lower.contains("failed");
    }

    private static String postForm(String path, List<NameValuePair> params) throws Exception {
        String base = LoadPropertyFileFunctionality.getConfigProperty().get("ep");
        if (base == null || base.trim().isEmpty()) {
            throw new IllegalStateException("PGP backend endpoint not configured");
        }
        HttpPost post = new HttpPost(base + path);
        post.setEntity(new UrlEncodedFormEntity(params, StandardCharsets.UTF_8));
        post.addHeader("accept", "application/json");

        HttpResponse response = HttpClientBuilder.create().build().execute(post);
        if (response.getStatusLine().getStatusCode() != 200) {
            throw new IllegalStateException("PGP backend returned HTTP " + response.getStatusLine().getStatusCode());
        }

        StringBuilder content = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line);
            }
        }
        return content.toString();
    }

    /** Backend often returns a JSON-quoted string with literal {@code \\n}. */
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

    static boolean looksLikeDecryptError(String plaintext) {
        if (plaintext == null || plaintext.isEmpty()) {
            return true;
        }
        String lower = plaintext.toLowerCase();
        return (lower.contains("secret key") && lower.contains("not found"))
                || lower.contains("incorrect passphrase")
                || lower.contains("wrong passphrase")
                || lower.contains("checksum mismatch")
                || lower.contains("pgpexception")
                || lower.contains("cannot decrypt")
                || lower.contains("decryption failed")
                || lower.contains("no suitable key")
                || (plaintext.length() < 200 && (lower.contains("key") || lower.contains("passphrase")));
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
