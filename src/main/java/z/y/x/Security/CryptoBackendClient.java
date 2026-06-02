package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Dispatches unified crypto AI operations to existing legacy servlets (form POST).
 */
public final class CryptoBackendClient {

    private static final Gson GSON = new Gson();

    private CryptoBackendClient() {
    }

    public static JsonObject execute(String appBaseUrl, JsonObject body) {
        String tool = jsonString(body, "tool").trim().toLowerCase();
        String operation = jsonString(body, "operation").trim().toLowerCase();
        JsonObject params = body != null && body.has("params") && body.get("params").isJsonObject()
                ? body.getAsJsonObject("params")
                : new JsonObject();

        if (tool.isEmpty()) {
            return err("tool is required");
        }
        if (operation.isEmpty()) {
            return err("operation is required");
        }

        try {
            switch (tool) {
                case "message-digest":
                    return execMessageDigest(appBaseUrl, operation, params);
                case "hmac":
                    return execHmac(appBaseUrl, operation, params);
                case "cipher":
                    return execCipher(appBaseUrl, operation, params);
                case "pbe":
                    return execPbe(appBaseUrl, operation, params);
                case "pbkdf":
                    return execPbkdf(appBaseUrl, operation, params);
                case "bcrypt":
                    return execBcrypt(appBaseUrl, operation, params);
                case "scrypt":
                    return execScrypt(appBaseUrl, operation, params);
                case "htpasswd":
                    return execHtpasswd(appBaseUrl, operation, params);
                case "argon2":
                    return err("argon2 hash/verify runs in the browser — use the page AI assistant");
                case "ec":
                    return execEc(appBaseUrl, operation, params);
                case "ec-sign-verify":
                    return execEcSignVerify(appBaseUrl, operation, params);
                case "elgamal":
                    return execElgamal(appBaseUrl, operation, params);
                case "dsa":
                    return execDsa(appBaseUrl, operation, params);
                case "ntru":
                    return execNtru(appBaseUrl, operation, params);
                case "jws-gen":
                case "jws-sign":
                case "jws-parse":
                case "jws-verify":
                    return execJws(appBaseUrl, operation, params);
                case "jwk":
                    return execJwk(appBaseUrl, operation, params);
                case "jwk-convert":
                    return execJwkConvert(appBaseUrl, operation, params);
                default:
                    return err("Unknown tool: " + tool);
            }
        } catch (Exception e) {
            return err(e.getMessage() == null ? "Operation failed" : e.getMessage());
        }
    }

    // ─── Hash / HMAC ───────────────────────────────────────────────────────────

    private static JsonObject execMessageDigest(String base, String op, JsonObject p) throws Exception {
        if (!"hash".equals(op)) {
            return err("message-digest supports operation: hash");
        }
        String text = jsonString(p, "text");
        if (text.isEmpty()) {
            text = jsonString(p, "message");
        }
        if (text.isEmpty()) {
            return err("text is required");
        }
        List<String> algos = jsonStringList(p, "algorithms");
        if (algos.isEmpty()) {
            algos = jsonStringList(p, "algorithm");
        }
        if (algos.isEmpty()) {
            return err("algorithms[] is required");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "CALCULATE_MD"));
        form.add(new BasicNameValuePair("text", text));
        for (String a : algos) {
            form.add(new BasicNameValuePair("cipherparameternew", a));
        }
        return wrapLegacy(forwardLegacy(base, "/MDFunctionality", form));
    }

    private static JsonObject execHmac(String base, String op, JsonObject p) throws Exception {
        if (!"hmac".equals(op)) {
            return err("hmac supports operation: hmac");
        }
        String text = jsonString(p, "text");
        if (text.isEmpty()) {
            text = jsonString(p, "message");
        }
        String key = jsonString(p, "key");
        if (key.isEmpty()) {
            key = jsonString(p, "passphrase");
        }
        if (text.isEmpty()) {
            return err("text is required");
        }
        if (key.isEmpty()) {
            return err("key is required");
        }
        List<String> algos = jsonStringList(p, "algorithms");
        if (algos.isEmpty()) {
            algos = jsonStringList(p, "algorithm");
        }
        if (algos.isEmpty()) {
            return err("algorithms[] is required");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "GENERATE_HMAC"));
        form.add(new BasicNameValuePair("text", text));
        form.add(new BasicNameValuePair("passphrase", key));
        for (String a : algos) {
            String mac = normalizeHmacAlgorithm(a);
            if (!mac.isEmpty()) {
                // MDFunctionality GENERATE_HMAC: each selected algo is its own param (name=value=HmacSHA256)
                form.add(new BasicNameValuePair(mac, mac));
            }
        }
        if (form.size() <= 3) {
            return err("No valid HMAC algorithm (use HmacSHA256, HmacSHA512, etc.)");
        }
        return wrapLegacy(forwardLegacy(base, "/MDFunctionality", form));
    }

    /** hmacgen.jsp checkbox values (MDFunctionality macchoices). */
    private static final Set<String> HMAC_CANONICAL = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList(
            "HmacSHA256", "HmacSHA512", "HmacSHA224", "HmacSHA384",
            "HmacSHA1", "HMACTIGER", "HMACRIPEMD128", "HMACRIPEMD160",
            "RC2MAC", "RC5MAC", "IDEAMAC", "DES", "DESEDEMAC",
            "HMACMD5", "HMACMD4", "HMACMD2")));

    private static final Map<String, String> HMAC_ALGO_ALIASES = buildHmacAliasMap();

    private static Map<String, String> buildHmacAliasMap() {
        Map<String, String> m = new HashMap<String, String>();
        for (String id : HMAC_CANONICAL) {
            m.put(hmacAliasKey(id), id);
        }
        alias(m, "HMAC-SHA-256", "HmacSHA256");
        alias(m, "HMAC-SHA-512", "HmacSHA512");
        alias(m, "HMAC-SHA-224", "HmacSHA224");
        alias(m, "HMAC-SHA-384", "HmacSHA384");
        alias(m, "HMAC-SHA-1", "HmacSHA1");
        alias(m, "HMAC-TIGER", "HMACTIGER");
        alias(m, "HMAC-RIPEMD-128", "HMACRIPEMD128");
        alias(m, "HMAC-RIPEMD-160", "HMACRIPEMD160");
        alias(m, "RC2-MAC", "RC2MAC");
        alias(m, "RC5-MAC", "RC5MAC");
        alias(m, "IDEA-MAC", "IDEAMAC");
        alias(m, "DES-MAC", "DES");
        alias(m, "3DES-MAC", "DESEDEMAC");
        alias(m, "HMAC-MD5", "HMACMD5");
        alias(m, "HMAC-MD4", "HMACMD4");
        alias(m, "HMAC-MD2", "HMACMD2");
        alias(m, "SHA-256", "HmacSHA256");
        alias(m, "SHA256", "HmacSHA256");
        alias(m, "SHA-512", "HmacSHA512");
        alias(m, "SHA-384", "HmacSHA384");
        alias(m, "SHA-224", "HmacSHA224");
        alias(m, "SHA-1", "HmacSHA1");
        alias(m, "HS256", "HmacSHA256");
        alias(m, "HS384", "HmacSHA384");
        alias(m, "HS512", "HmacSHA512");
        alias(m, "MD5", "HMACMD5");
        alias(m, "MD4", "HMACMD4");
        alias(m, "MD2", "HMACMD2");
        alias(m, "TIGER", "HMACTIGER");
        alias(m, "RIPEMD128", "HMACRIPEMD128");
        alias(m, "RIPEMD160", "HMACRIPEMD160");
        alias(m, "3DES", "DESEDEMAC");
        return m;
    }

    private static void alias(Map<String, String> m, String label, String id) {
        m.put(hmacAliasKey(label), id);
    }

    private static String hmacAliasKey(String label) {
        return label.trim().replaceAll("[\\s_-]", "").toUpperCase();
    }

    /** Map UI / LLM labels to macchoices enum names (hmacgen.jsp). */
    private static String normalizeHmacAlgorithm(String raw) {
        if (raw == null || raw.trim().isEmpty()) {
            return "";
        }
        String key = hmacAliasKey(raw);
        String mapped = HMAC_ALGO_ALIASES.get(key);
        if (mapped != null) {
            return mapped;
        }
        for (String id : HMAC_CANONICAL) {
            if (id.equalsIgnoreCase(raw.trim())) {
                return id;
            }
        }
        return "";
    }

    /** Map common LLM cipher strings to CipherFunctions.jsp dropdown values. */
    private static String normalizeCipherAlgorithm(String... candidates) {
        for (String raw : candidates) {
            if (raw == null || raw.trim().isEmpty()) {
                continue;
            }
            String t = raw.trim().toUpperCase().replace(" ", "").replace("-", "_");
            if (t.contains("GCM")) {
                if (t.contains("256") || t.equals("AES/GCM/NOPADDING") || t.equals("AESGCM/NOPADDING")) {
                    return "AES_256/GCM/NOPADDING";
                }
                if (t.contains("192")) {
                    return "AES_192/GCM/NOPADDING";
                }
                if (t.contains("128")) {
                    return "AES_128/GCM/NOPADDING";
                }
                return "AES_256/GCM/NOPADDING";
            }
            if (t.contains("CBC") && t.contains("PKCS5")) {
                return "AES/CBC/PKCS5PADDING";
            }
            if ("CHACHA".equals(t) || t.contains("CHACHA20")) {
                return "CHACHA";
            }
            if (raw.contains("/") || raw.contains("_")) {
                return raw.trim();
            }
        }
        return candidates.length > 0 && candidates[0] != null ? candidates[0].trim() : "";
    }

    // ─── Symmetric cipher / PBE ───────────────────────────────────────────────

    private static JsonObject execCipher(String base, String op, JsonObject p) throws Exception {
        if (!"encrypt".equals(op) && !"decrypt".equals(op)) {
            return err("cipher supports: encrypt, decrypt");
        }
        String algo = normalizeCipherAlgorithm(
                firstNonEmpty(jsonString(p, "algorithm"), jsonString(p, "cipher"), jsonString(p, "algo")));
        if (algo.isEmpty()) {
            return err("algorithm is required");
        }
        String plaintext = jsonString(p, "plaintext");
        if (plaintext.isEmpty()) {
            plaintext = jsonString(p, "message");
        }
        if (plaintext.isEmpty()) {
            plaintext = jsonString(p, "text");
        }
        String secretkey = jsonString(p, "secretKey");
        if (secretkey.isEmpty()) {
            secretkey = jsonString(p, "secretkey");
        }
        if (secretkey.isEmpty()) {
            secretkey = jsonString(p, "key");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "CIPHERBLOCK_NEW"));
        form.add(new BasicNameValuePair("encryptorDecrypt", "encrypt".equals(op) ? "encrypt" : "decrypt"));
        form.add(new BasicNameValuePair("plaintext", plaintext));
        form.add(new BasicNameValuePair("secretkey", secretkey));
        form.add(new BasicNameValuePair("cipherparameternew", algo));
        return wrapLegacy(forwardLegacy(base, "/CipherFunctionality", form));
    }

    private static JsonObject execPbe(String base, String op, JsonObject p) throws Exception {
        if (!"encrypt".equals(op) && !"decrypt".equals(op)) {
            return err("pbe supports: encrypt, decrypt");
        }
        String algo = firstNonEmpty(jsonString(p, "algorithm"), jsonString(p, "cipher"));
        if (algo.isEmpty()) {
            return err("algorithm is required");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "PBEMESSAGE"));
        // Legacy servlet checks typo "decryprt" for decrypt (not "decrypt")
        String mode = "encrypt".equals(op) ? "encrypt" : "decryprt";
        form.add(new BasicNameValuePair("encryptdecryptparameter", mode));
        form.add(new BasicNameValuePair("message", jsonString(p, "message")));
        form.add(new BasicNameValuePair("password", jsonString(p, "password")));
        form.add(new BasicNameValuePair("rounds", jsonString(p, "rounds")));
        for (String a : jsonStringList(p, "algorithms")) {
            form.add(new BasicNameValuePair("cipherparameternew", a));
        }
        if (jsonStringList(p, "algorithms").isEmpty() && !algo.isEmpty()) {
            form.add(new BasicNameValuePair("cipherparameternew", algo));
        }
        return wrapLegacy(forwardLegacy(base, "/PBEFunctionality", form));
    }

    private static JsonObject execPbkdf(String base, String op, JsonObject p) throws Exception {
        if (!"derive".equals(op)) {
            return err("pbkdf supports operation: derive");
        }
        List<String> algos = jsonStringList(p, "algorithms");
        if (algos.isEmpty()) {
            algos = jsonStringList(p, "algorithm");
        }
        if (algos.isEmpty()) {
            return err("algorithms[] is required");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "PBKDFDERIVEKEY"));
        form.add(new BasicNameValuePair("password", jsonString(p, "password")));
        form.add(new BasicNameValuePair("salt", jsonString(p, "salt")));
        form.add(new BasicNameValuePair("rounds", jsonString(p, "rounds")));
        form.add(new BasicNameValuePair("keylength", jsonString(p, "keyLength")));
        if (form.get(form.size() - 1).getValue().isEmpty()) {
            form.set(form.size() - 1, new BasicNameValuePair("keylength", jsonString(p, "keylength")));
        }
        form.add(new BasicNameValuePair("ssid", jsonString(p, "ssid")));
        for (String a : algos) {
            form.add(new BasicNameValuePair("cipherparameternew", a));
        }
        return wrapLegacy(forwardLegacy(base, "/PBEFunctionality", form));
    }

    // ─── KDF (bcrypt / scrypt / htpasswd) ─────────────────────────────────────

    private static JsonObject execBcrypt(String base, String op, JsonObject p) throws Exception {
        List<NameValuePair> form = new ArrayList<>();
        if ("hash".equals(op)) {
            form.add(new BasicNameValuePair("methodName", "CALCULATE_BCCRYPT"));
            form.add(new BasicNameValuePair("password", jsonString(p, "password")));
            form.add(new BasicNameValuePair("workload", jsonString(p, "cost")));
            if (form.get(2).getValue().isEmpty()) {
                form.set(2, new BasicNameValuePair("workload", jsonString(p, "workload")));
            }
        } else if ("verify".equals(op)) {
            form.add(new BasicNameValuePair("methodName", "CALCULATE_BCCRYPT"));
            form.add(new BasicNameValuePair("password", jsonString(p, "password")));
            form.add(new BasicNameValuePair("hash", jsonString(p, "hash")));
            form.add(new BasicNameValuePair("workload", firstNonEmpty(jsonString(p, "cost"), jsonString(p, "workload"), "10")));
        } else {
            return err("bcrypt supports: hash, verify");
        }
        return wrapLegacy(forwardLegacy(base, "/BCCryptFunctionality", form));
    }

    private static JsonObject execScrypt(String base, String op, JsonObject p) throws Exception {
        List<NameValuePair> form = new ArrayList<>();
        if ("hash".equals(op)) {
            form.add(new BasicNameValuePair("methodName", "CALCULATE_SCRYPT"));
            form.add(new BasicNameValuePair("password", jsonString(p, "password")));
            form.add(new BasicNameValuePair("salt", jsonString(p, "salt")));
            form.add(new BasicNameValuePair("workparam",
                    firstNonEmpty(jsonString(p, "n"), jsonString(p, "workparam"), "2048")));
            form.add(new BasicNameValuePair("memoryparam",
                    firstNonEmpty(jsonString(p, "r"), jsonString(p, "memoryparam"), "8")));
            form.add(new BasicNameValuePair("parallelizationparam",
                    firstNonEmpty(jsonString(p, "p"), jsonString(p, "parallelizationparam"), "1")));
            form.add(new BasicNameValuePair("length", firstNonEmpty(jsonString(p, "length"), "32")));
        } else if ("verify".equals(op)) {
            form.add(new BasicNameValuePair("methodName", "CALCULATE_SCRYPT"));
            form.add(new BasicNameValuePair("password", jsonString(p, "password")));
            form.add(new BasicNameValuePair("hash", jsonString(p, "hash")));
            form.add(new BasicNameValuePair("salt", jsonString(p, "salt")));
            form.add(new BasicNameValuePair("workparam", firstNonEmpty(jsonString(p, "n"), jsonString(p, "workparam"), "16384")));
            form.add(new BasicNameValuePair("memoryparam", firstNonEmpty(jsonString(p, "r"), jsonString(p, "memoryparam"), "8")));
            form.add(new BasicNameValuePair("parallelizationparam", firstNonEmpty(jsonString(p, "p"), jsonString(p, "parallelizationparam"), "1")));
            form.add(new BasicNameValuePair("length", firstNonEmpty(jsonString(p, "length"), "32")));
        } else {
            return err("scrypt supports: hash, verify");
        }
        return wrapLegacy(forwardLegacy(base, "/BCCryptFunctionality", form));
    }

    private static JsonObject execHtpasswd(String base, String op, JsonObject p) throws Exception {
        if (!"generate".equals(op) && !"verify".equals(op)) {
            return err("htpasswd supports: generate, verify");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "HTPASSWORD_GENERATE"));
        form.add(new BasicNameValuePair("username", jsonString(p, "username")));
        form.add(new BasicNameValuePair("password", jsonString(p, "password")));
        form.add(new BasicNameValuePair("workload", jsonString(p, "algorithm")));
        if ("verify".equals(op)) {
            form.add(new BasicNameValuePair("hash", jsonString(p, "hash")));
        }
        return wrapLegacy(forwardLegacy(base, "/BCCryptFunctionality", form));
    }

    // ─── EC / ElGamal / DSA / NTRU ────────────────────────────────────────────

    private static JsonObject execEc(String base, String op, JsonObject p) throws Exception {
        if ("generate_keys".equals(op)) {
            String curve = normalizeEcCurveParam(jsonString(p, "curve"));
            if (curve.isEmpty()) {
                return err("curve is required (e.g. P-256, secp256k1)");
            }
            List<NameValuePair> form = new ArrayList<>();
            form.add(new BasicNameValuePair("methodName", "EC_GENERATE_KEYPAIR"));
            form.add(new BasicNameValuePair("ecparam", curve));
            return wrapLegacy(forwardLegacy(base, "/ECFunctionality", form));
        }
        if ("encrypt".equals(op) || "decrypt".equals(op)) {
            List<NameValuePair> form = ecOpForm(op, p);
            form.add(0, new BasicNameValuePair("methodName", "EC_FUNCTION"));
            return wrapLegacy(forwardLegacy(base, "/ECFunctionality", form));
        }
        return err("ec supports: generate_keys, encrypt, decrypt");
    }

    private static JsonObject execEcSignVerify(String base, String op, JsonObject p) throws Exception {
        if ("generate_keys".equals(op)) {
            String curve = normalizeEcCurveParam(jsonString(p, "curve"));
            if (curve.isEmpty()) {
                return err("curve is required (e.g. P-256, secp256k1)");
            }
            List<NameValuePair> form = new ArrayList<>();
            form.add(new BasicNameValuePair("methodName", "EC_GENERATE_KEYPAIR_ECDSA"));
            form.add(new BasicNameValuePair("ecparam", curve));
            return wrapLegacy(forwardLegacy(base, "/ECFunctionality", form));
        }
        if ("sign".equals(op) || "verify".equals(op)) {
            List<NameValuePair> form = ecSignForm(op, p);
            form.add(0, new BasicNameValuePair("methodName", "EC_SIGN_VERIFY_MESSAGEE"));
            return wrapLegacy(forwardLegacy(base, "/ECFunctionality", form));
        }
        return err("ec-sign-verify supports: generate_keys, sign, verify");
    }

    private static JsonObject execElgamal(String base, String op, JsonObject p) throws Exception {
        if ("generate_keys".equals(op)) {
            String keySize = firstNonEmpty(jsonString(p, "keySize"), jsonString(p, "keysize"), "160");
            return wrapLegacy(forwardLegacyGet(base, "/ELGAMALFunctionality", "keysize", keySize));
        }
        if ("encrypt".equals(op) || "decrypt".equals(op)) {
            List<NameValuePair> form = elgamalOpForm(op, p);
            form.add(0, new BasicNameValuePair("methodName", "CALCULATE_ELGAMAL"));
            return wrapLegacy(forwardLegacy(base, "/ELGAMALFunctionality", form));
        }
        return err("elgamal supports: generate_keys, encrypt, decrypt");
    }

    private static JsonObject execDsa(String base, String op, JsonObject p) throws Exception {
        if ("generate_keys".equals(op)) {
            String keySize = firstNonEmpty(jsonString(p, "keySize"), jsonString(p, "keysize"), "1024");
            return wrapLegacy(forwardLegacyGet(base, "/DSAFunctionality", "keysize", keySize));
        }
        if ("sign".equals(op) || "verify".equals(op)) {
            return err("dsa sign/verify requires file upload on the page (multipart) — not available via AI yet");
        }
        return err("dsa supports: generate_keys, explain");
    }

    private static JsonObject execNtru(String base, String op, JsonObject p) throws Exception {
        if ("generate_keys".equals(op)) {
            List<NameValuePair> form = new ArrayList<>();
            form.add(new BasicNameValuePair("methodName", "GENERATE_KEYS"));
            form.add(new BasicNameValuePair("ntruparam", jsonString(p, "parameterSet")));
            form.add(new BasicNameValuePair("password", jsonString(p, "password")));
            form.add(new BasicNameValuePair("salt", jsonString(p, "salt")));
            return wrapLegacy(forwardLegacy(base, "/NTRUFunctionality", form));
        }
        if ("encrypt".equals(op) || "decrypt".equals(op)) {
            List<NameValuePair> form = asymmetricOpForm(op, p);
            form.add(0, new BasicNameValuePair("methodName", "CALCULATE_NTRU"));
            form.add(new BasicNameValuePair("p_ntru", jsonString(p, "parameterSet")));
            return wrapLegacy(forwardLegacy(base, "/NTRUFunctionality", form));
        }
        return err("ntru supports: generate_keys, encrypt, decrypt");
    }

    // ─── JWS / JWK ─────────────────────────────────────────────────────────────

    private static JsonObject execJws(String base, String op, JsonObject p) throws Exception {
        List<NameValuePair> form = new ArrayList<>();
        switch (op) {
            case "generate":
                form.add(new BasicNameValuePair("methodName", "GENERATE_JSONKEY"));
                form.add(new BasicNameValuePair("algo", firstNonEmpty(jsonString(p, "algorithm"), jsonString(p, "algo"), "HS256")));
                form.add(new BasicNameValuePair("payload", jsonString(p, "payload")));
                break;
            case "sign":
                form.add(new BasicNameValuePair("methodName", "SIGN_JSON"));
                form.add(new BasicNameValuePair("algo", firstNonEmpty(jsonString(p, "algorithm"), jsonString(p, "algo"), "HS256")));
                form.add(new BasicNameValuePair("payload", jsonString(p, "payload")));
                form.add(new BasicNameValuePair("sharedsecret", firstNonEmpty(jsonString(p, "sharedsecret"), jsonString(p, "sharedSecret"))));
                form.add(new BasicNameValuePair("key", jsonString(p, "key")));
                break;
            case "parse":
                form.add(new BasicNameValuePair("methodName", "PARSE_JWS"));
                form.add(new BasicNameValuePair("serialized", jsonString(p, "serialized")));
                break;
            case "verify":
                form.add(new BasicNameValuePair("methodName", "VERIFY_JWS"));
                form.add(new BasicNameValuePair("serialized", jsonString(p, "serialized")));
                form.add(new BasicNameValuePair("sharedsecret", firstNonEmpty(jsonString(p, "sharedsecret"), jsonString(p, "sharedSecret"))));
                form.add(new BasicNameValuePair("publickey", firstNonEmpty(jsonString(p, "publickey"), jsonString(p, "publicKey"))));
                break;
            default:
                return err("jws supports operations: generate, sign, parse, verify");
        }
        if ("generate".equals(op) || "sign".equals(op)) {
            if (jsonString(p, "payload").isEmpty()) {
                return err("payload is required");
            }
        }
        if ("parse".equals(op) || "verify".equals(op)) {
            if (jsonString(p, "serialized").isEmpty()) {
                return err("serialized JWS token is required");
            }
        }
        return wrapLegacy(forwardLegacy(base, "/JWSFunctionality", form));
    }

    private static JsonObject execJwk(String base, String op, JsonObject p) throws Exception {
        if (!"generate".equals(op)) {
            return err("jwk supports operation: generate");
        }
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "CALCULATE_JWK"));
        form.add(new BasicNameValuePair("param", firstNonEmpty(jsonString(p, "param"), "1")));
        return wrapLegacy(forwardLegacy(base, "/JWKFunctionality", form));
    }

    private static JsonObject execJwkConvert(String base, String op, JsonObject p) throws Exception {
        if (!"convert".equals(op)) {
            return err("jwk-convert supports operation: convert");
        }
        String input = jsonString(p, "input");
        if (input.isEmpty()) {
            return err("input is required");
        }
        String direction = firstNonEmpty(jsonString(p, "param"), jsonString(p, "direction"), "JWK-to-PEM");
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("methodName", "CONVERT_JWK"));
        form.add(new BasicNameValuePair("param", direction));
        form.add(new BasicNameValuePair("input", input));
        return wrapLegacy(forwardLegacy(base, "/JWKFunctionality", form));
    }

    private static List<NameValuePair> ecOpForm(String op, JsonObject p) {
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("encryptparameter", "encrypt".equals(op) ? "encrypt" : ""));
        form.add(new BasicNameValuePair("decryptparameter", "decrypt".equals(op) ? "decrypt" : ""));
        form.add(new BasicNameValuePair("message", jsonString(p, "message")));
        form.add(new BasicNameValuePair("publickeyparama", jsonString(p, "publicKeyAlice")));
        form.add(new BasicNameValuePair("privatekeyparama", jsonString(p, "privateKeyAlice")));
        form.add(new BasicNameValuePair("publickeyparamb", jsonString(p, "publicKeyBob")));
        form.add(new BasicNameValuePair("privatekeyparamb", jsonString(p, "privateKeyBob")));
        form.add(new BasicNameValuePair("ecparam", jsonString(p, "curve")));
        return form;
    }

    private static List<NameValuePair> ecSignForm(String op, JsonObject p) {
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("encryptparameter", "sign".equals(op) ? "sign" : ""));
        form.add(new BasicNameValuePair("decryptparameter", "verify".equals(op) ? "verify" : ""));
        form.add(new BasicNameValuePair("message", jsonString(p, "message")));
        // JSP field names are inverted: publickeyparam = EC private key, privatekeyparam = EC public key
        form.add(new BasicNameValuePair("publickeyparam", firstNonEmpty(jsonString(p, "privateKey"), jsonString(p, "privatekey"))));
        form.add(new BasicNameValuePair("privatekeyparam", firstNonEmpty(jsonString(p, "publicKey"), jsonString(p, "publickey"))));
        form.add(new BasicNameValuePair("signature", jsonString(p, "signature")));
        form.add(new BasicNameValuePair("ecparam", jsonString(p, "curve")));
        return form;
    }

    private static List<NameValuePair> asymmetricOpForm(String op, JsonObject p) {
        List<NameValuePair> form = new ArrayList<>();
        form.add(new BasicNameValuePair("encryptparameter", "encrypt".equals(op) ? "encrypt" : ""));
        form.add(new BasicNameValuePair("decryptparameter", "decrypt".equals(op) ? "decrypt" : ""));
        form.add(new BasicNameValuePair("message", jsonString(p, "message")));
        form.add(new BasicNameValuePair("publickeyparam", jsonString(p, "publicKey")));
        form.add(new BasicNameValuePair("privatekeyparam", jsonString(p, "privateKey")));
        return form;
    }

    private static List<NameValuePair> elgamalOpForm(String op, JsonObject p) {
        List<NameValuePair> form = new ArrayList<>();
        // JSP uses encryptdecryptparameter; decrypt value is legacy typo "decryprt"
        form.add(new BasicNameValuePair("encryptdecryptparameter",
                "encrypt".equals(op) ? "encrypt" : "decryprt"));
        form.add(new BasicNameValuePair("message", jsonString(p, "message")));
        form.add(new BasicNameValuePair("publickeyparam",
                firstNonEmpty(jsonString(p, "publicKey"), jsonString(p, "publickey"))));
        form.add(new BasicNameValuePair("privatekeyparam",
                firstNonEmpty(jsonString(p, "privateKey"), jsonString(p, "privatekey"))));
        form.add(new BasicNameValuePair("cipherparameter",
                firstNonEmpty(jsonString(p, "algorithm"), jsonString(p, "cipherparameter"), "ELGAMAL")));
        return form;
    }

    // ─── HTTP forward ─────────────────────────────────────────────────────────

    private static String forwardLegacyGet(String appBase, String servletPath, String paramName, String paramValue)
            throws Exception {
        String encoded = java.net.URLEncoder.encode(paramValue, StandardCharsets.UTF_8.name());
        String url = appBase + servletPath + "?" + paramName + "=" + encoded;
        org.apache.http.client.methods.HttpGet get = new org.apache.http.client.methods.HttpGet(url);
        get.addHeader("Accept", "application/json, text/plain, */*");
        org.apache.http.HttpResponse response = HttpClientBuilder.create().build().execute(get);
        int code = response.getStatusLine().getStatusCode();
        String body = response.getEntity() != null
                ? EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8)
                : "";
        if (code < 200 || code >= 300) {
            throw new IllegalStateException("Legacy servlet HTTP " + code + (body.isEmpty() ? "" : ": " + body));
        }
        return body;
    }

    private static String forwardLegacy(String appBase, String servletPath, List<NameValuePair> form)
            throws Exception {
        String url = appBase + servletPath;
        HttpPost post = new HttpPost(url);
        post.setEntity(new UrlEncodedFormEntity(form, StandardCharsets.UTF_8));
        post.addHeader("Accept", "application/json, text/plain, */*");
        org.apache.http.HttpResponse response = HttpClientBuilder.create().build().execute(post);
        int code = response.getStatusLine().getStatusCode();
        String body = response.getEntity() != null
                ? EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8)
                : "";
        if (code < 200 || code >= 300) {
            throw new IllegalStateException("Legacy servlet HTTP " + code + (body.isEmpty() ? "" : ": " + body));
        }
        return body;
    }

    private static JsonObject wrapLegacy(String raw) {
        String trimmed = raw == null ? "" : raw.trim();
        if (trimmed.startsWith("{")) {
            try {
                JsonObject parsed = new JsonParser().parse(trimmed).getAsJsonObject();
                if (!parsed.has("ok")) {
                    boolean success = true;
                    if (parsed.has("success") && !parsed.get("success").isJsonNull()) {
                        success = parsed.get("success").getAsBoolean();
                    }
                    if (parsed.has("errorMessage") && !parsed.get("errorMessage").getAsString().trim().isEmpty()) {
                        success = false;
                    }
                    if (parsed.has("error") && !parsed.get("error").getAsString().trim().isEmpty()) {
                        success = false;
                    }
                    parsed.addProperty("ok", success);
                }
                return parsed;
            } catch (Exception ignored) {
                // fall through
            }
        }
        if (trimmed.startsWith("<") || trimmed.regionMatches(true, 0, "<!DOCTYPE", 0, 9)) {
            JsonObject out = new JsonObject();
            out.addProperty("ok", false);
            out.addProperty("error", "Legacy servlet returned HTML instead of JSON");
            out.addProperty("errorMessage", "Legacy servlet returned HTML instead of JSON");
            return out;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("output", trimmed);
        return out;
    }

    private static String normalizeEcCurveParam(String curve) {
        String c = curve == null ? "" : curve.trim();
        if (c.isEmpty()) {
            return "";
        }
        String key = c.replaceAll("[\\s_-]+", "").toUpperCase();
        switch (key) {
            case "SECP256R1":
            case "PRIME256V1":
            case "P256":
            case "NISTP256":
                return "P-256";
            case "SECP384R1":
            case "P384":
                return "P-384";
            case "SECP521R1":
            case "P521":
                return "P-521";
            case "SECP256K1":
                return "secp256k1";
            default:
                return c;
        }
    }

    private static JsonObject err(String message) {
        JsonObject o = new JsonObject();
        o.addProperty("ok", false);
        o.addProperty("error", message);
        return o;
    }

    private static String jsonString(JsonObject o, String key) {
        if (o == null || !o.has(key) || o.get(key).isJsonNull()) {
            return "";
        }
        JsonElement el = o.get(key);
        if (el.isJsonPrimitive()) {
            return el.getAsString();
        }
        return el.toString();
    }

    private static List<String> jsonStringList(JsonObject o, String key) {
        List<String> out = new ArrayList<>();
        if (o == null || !o.has(key)) {
            return out;
        }
        JsonElement el = o.get(key);
        if (el.isJsonArray()) {
            for (JsonElement item : el.getAsJsonArray()) {
                if (item != null && !item.isJsonNull()) {
                    out.add(item.getAsString());
                }
            }
        } else if (el.isJsonPrimitive()) {
            String s = el.getAsString().trim();
            if (!s.isEmpty()) {
                out.add(s);
            }
        }
        return out;
    }

    private static String firstNonEmpty(String... values) {
        for (String v : values) {
            if (v != null && !v.trim().isEmpty()) {
                return v.trim();
            }
        }
        return "";
    }
}
