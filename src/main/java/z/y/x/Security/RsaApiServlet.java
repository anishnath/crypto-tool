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
 * JSON API for RSA operations used by the chat-native AI assistant.
 */
public class RsaApiServlet extends HttpServlet {
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
            case "/api/rsa/generate-keys":
                handleGenerateKeys(body, resp);
                break;
            case "/api/rsa/encrypt":
                handleEncrypt(body, resp);
                break;
            case "/api/rsa/decrypt":
                handleDecrypt(body, resp);
                break;
            case "/api/rsa/sign":
                handleSign(body, resp);
                break;
            case "/api/rsa/verify":
                handleVerify(body, resp);
                break;
            default:
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"ok\":false,\"error\":\"not found\"}");
        }
    }

    private void handleGenerateKeys(JsonObject body, HttpServletResponse resp) throws IOException {
        String keysize = jsonString(body, "keysize");
        RsaBackendClient.KeyGenResult result = RsaBackendClient.generateKeys(keysize);
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("publicKey", result.publicKey);
        out.addProperty("privateKey", result.privateKey);
        out.addProperty("keySize", result.keySize);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleEncrypt(JsonObject body, HttpServletResponse resp) throws IOException {
        RsaBackendClient.TextResult result = RsaBackendClient.encrypt(
                jsonString(body, "message"),
                jsonString(body, "publicKey"),
                jsonString(body, "algorithm"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("ciphertext", result.text);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleDecrypt(JsonObject body, HttpServletResponse resp) throws IOException {
        RsaBackendClient.TextResult result = RsaBackendClient.decrypt(
                jsonString(body, "ciphertext"),
                jsonString(body, "privateKey"),
                jsonString(body, "algorithm"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("plaintext", result.text);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleSign(JsonObject body, HttpServletResponse resp) throws IOException {
        RsaBackendClient.TextResult result = RsaBackendClient.sign(
                jsonString(body, "message"),
                jsonString(body, "privateKey"),
                jsonString(body, "algorithm"));
        if (!result.ok) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, error(result.error));
            return;
        }
        JsonObject out = new JsonObject();
        out.addProperty("ok", true);
        out.addProperty("signature", result.text);
        writeJson(resp, HttpServletResponse.SC_OK, out);
    }

    private void handleVerify(JsonObject body, HttpServletResponse resp) throws IOException {
        RsaBackendClient.VerifyResult result = RsaBackendClient.verify(
                jsonString(body, "message"),
                jsonString(body, "publicKey"),
                jsonString(body, "signature"),
                jsonString(body, "algorithm"));
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
