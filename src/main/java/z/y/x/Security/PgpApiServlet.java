package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/**
 * JSON API for PGP operations used by the chat-native AI assistant.
 * <ul>
 *   <li>{@code POST /api/pgp/generate-keys}</li>
 *   <li>{@code POST /api/pgp/encrypt}</li>
 *   <li>{@code POST /api/pgp/decrypt}</li>
 *   <li>{@code POST /api/pgp/sign}</li>
 *   <li>{@code POST /api/pgp/verify}</li>
 *   <li>{@code POST /api/pgp/verify-file}</li>
 *   <li>{@code POST /api/pgp/dump}</li>
 * </ul>
 */
public class PgpApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson GSON = new Gson();
    private static final int MAX_BODY = 512 * 1024;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String path = req.getServletPath();
        JsonObject body = readJsonBody(req);

        switch (path) {
            case "/api/pgp/generate-keys":
                handleGenerateKeys(body, resp);
                break;
            case "/api/pgp/encrypt":
                handleEncrypt(body, resp);
                break;
            case "/api/pgp/decrypt":
                handleDecrypt(body, resp);
                break;
            case "/api/pgp/sign":
                handleSign(body, resp);
                break;
            case "/api/pgp/verify":
                handleVerify(body, resp);
                break;
            case "/api/pgp/verify-file":
                handleVerifyFile(body, resp);
                break;
            case "/api/pgp/dump":
                handleDump(body, resp);
                break;
            default:
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"ok\":false,\"error\":\"not found\"}");
        }
    }

    private void handleGenerateKeys(JsonObject body, HttpServletResponse resp) throws IOException {
        PgpBackendClient.KeyGenRequest req = new PgpBackendClient.KeyGenRequest();
        req.identity = jsonString(body, "identity");
        req.passphrase = jsonString(body, "passphrase");
        req.keysize = jsonString(body, "keysize");
        req.cipher = jsonString(body, "cipher");

        PgpBackendClient.KeyGenResult result = PgpBackendClient.generateKeys(req);
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("identity", req.identity);
        out.addProperty("publicKey", result.publicKey);
        out.addProperty("privateKey", result.privateKey);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleEncrypt(JsonObject body, HttpServletResponse resp) throws IOException {
        String message = jsonString(body, "message");
        String publicKey = jsonString(body, "publicKey");
        PgpBackendClient.EncryptResult result = PgpBackendClient.encrypt(message, publicKey);
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("encrypted", result.encrypted);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleDecrypt(JsonObject body, HttpServletResponse resp) throws IOException {
        String message = jsonString(body, "message");
        String privateKey = jsonString(body, "privateKey");
        String passphrase = jsonString(body, "passphrase");
        PgpBackendClient.DecryptResult result = PgpBackendClient.decrypt(message, privateKey, passphrase);
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("plaintext", result.plaintext);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleSign(JsonObject body, HttpServletResponse resp) throws IOException {
        PgpBackendClient.TextResult result = PgpBackendClient.sign(
                jsonString(body, "message"),
                jsonString(body, "privateKey"),
                jsonString(body, "passphrase"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("signed", result.text);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleVerify(JsonObject body, HttpServletResponse resp) throws IOException {
        PgpBackendClient.VerifyResult result = PgpBackendClient.verify(
                jsonString(body, "signedMaterial"),
                jsonString(body, "publicKey"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("valid", result.valid);
        out.addProperty("message", result.message);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleVerifyFile(JsonObject body, HttpServletResponse resp) throws IOException {
        byte[] fileBytes = PgpBackendClient.decodeBase64(jsonString(body, "fileBase64"));
        PgpBackendClient.VerifyResult result = PgpBackendClient.verifyFile(
                fileBytes,
                jsonString(body, "fileName"),
                jsonString(body, "publicKey"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("valid", result.valid);
        out.addProperty("message", result.message);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleDump(JsonObject body, HttpServletResponse resp) throws IOException {
        PgpBackendClient.TextResult result = PgpBackendClient.dump(jsonString(body, "input"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("dump", result.text);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private static JsonObject error(String message) {
        JsonObject o = new JsonObject();
        o.addProperty("ok", false);
        o.addProperty("error", message == null ? "Unknown error" : message);
        return o;
    }

    private static String jsonString(JsonObject body, String key) {
        if (body == null || !body.has(key) || body.get(key).isJsonNull()) {
            return "";
        }
        return body.get(key).getAsString();
    }

    private static JsonObject readJsonBody(HttpServletRequest req) throws IOException {
        InputStream in = req.getInputStream();
        byte[] buf = new byte[8192];
        StringBuilder sb = new StringBuilder();
        int total = 0;
        int n;
        while ((n = in.read(buf)) >= 0) {
            total += n;
            if (total > MAX_BODY) {
                throw new IOException("Request body too large");
            }
            sb.append(new String(buf, 0, n, StandardCharsets.UTF_8));
        }
        String raw = sb.toString().trim();
        if (raw.isEmpty()) {
            return new JsonObject();
        }
        return new JsonParser().parse(raw).getAsJsonObject();
    }

    private static void writeJson(HttpServletResponse resp, int status, JsonObject body) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write(GSON.toJson(body));
    }
}
