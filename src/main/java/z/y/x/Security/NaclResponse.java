package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for NaCl (libsodium) encryption/decryption operations
 * Supports: XSalsa20, AEAD, Box, and SealedBox
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class NaclResponse {

    private boolean success;
    private String operation;      // "encrypt" or "decrypt"
    private String algorithm;      // "xsalsa20", "aead", "box", "sealedbox"
    private String errorMessage;

    // Result data
    private String ciphertext;     // Hex encoded ciphertext (for encryption)
    private String plaintext;      // Decrypted plaintext (for decryption)

    // Input parameters echoed back (for display)
    private String nonce;
    private String aead;           // Additional authenticated data (for AEAD)

    public NaclResponse() {
    }

    // Static factory methods
    public static NaclResponse encryptSuccess(String ciphertext, String algorithm) {
        NaclResponse resp = new NaclResponse();
        resp.setSuccess(true);
        resp.setOperation("encrypt");
        resp.setCiphertext(ciphertext);
        resp.setAlgorithm(algorithm);
        return resp;
    }

    public static NaclResponse encryptSuccess(String ciphertext, String algorithm, String nonce) {
        NaclResponse resp = encryptSuccess(ciphertext, algorithm);
        resp.setNonce(nonce);
        return resp;
    }

    public static NaclResponse decryptSuccess(String plaintext, String algorithm) {
        NaclResponse resp = new NaclResponse();
        resp.setSuccess(true);
        resp.setOperation("decrypt");
        resp.setPlaintext(plaintext);
        resp.setAlgorithm(algorithm);
        return resp;
    }

    public static NaclResponse error(String errorMessage) {
        NaclResponse resp = new NaclResponse();
        resp.setSuccess(false);
        resp.setErrorMessage(errorMessage);
        return resp;
    }

    public static NaclResponse error(String operation, String algorithm, String errorMessage) {
        NaclResponse resp = new NaclResponse();
        resp.setSuccess(false);
        resp.setOperation(operation);
        resp.setAlgorithm(algorithm);
        resp.setErrorMessage(errorMessage);
        return resp;
    }

    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getAlgorithm() {
        return algorithm;
    }

    public void setAlgorithm(String algorithm) {
        this.algorithm = algorithm;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getCiphertext() {
        return ciphertext;
    }

    public void setCiphertext(String ciphertext) {
        this.ciphertext = ciphertext;
    }

    public String getPlaintext() {
        return plaintext;
    }

    public void setPlaintext(String plaintext) {
        this.plaintext = plaintext;
    }

    public String getNonce() {
        return nonce;
    }

    public void setNonce(String nonce) {
        this.nonce = nonce;
    }

    public String getAead() {
        return aead;
    }

    public void setAead(String aead) {
        this.aead = aead;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
