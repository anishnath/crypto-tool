package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for ElGamal encryption/decryption operations
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class ElGamalResponse {

    private boolean success;
    private String operation;  // "encrypt" or "decrypt"
    private String errorMessage;

    // Input info
    private String algorithm;  // ELGAMAL, ELGAMAL/ECB/PKCS1PADDING, etc.
    private Integer keySize;

    // Encryption result
    private String ciphertext;      // Base64 encoded ciphertext
    private String ciphertextHex;   // Hex encoded ciphertext (optional)

    // Decryption result
    private String plaintext;       // Decrypted message

    // Key info (for display purposes)
    private String publicKeyFingerprint;
    private String privateKeyFingerprint;

    public ElGamalResponse() {
    }

    // Static factory methods for common responses
    public static ElGamalResponse encryptSuccess(String ciphertext, String algorithm) {
        ElGamalResponse resp = new ElGamalResponse();
        resp.setSuccess(true);
        resp.setOperation("encrypt");
        resp.setCiphertext(ciphertext);
        resp.setAlgorithm(algorithm);
        return resp;
    }

    public static ElGamalResponse decryptSuccess(String plaintext, String algorithm) {
        ElGamalResponse resp = new ElGamalResponse();
        resp.setSuccess(true);
        resp.setOperation("decrypt");
        resp.setPlaintext(plaintext);
        resp.setAlgorithm(algorithm);
        return resp;
    }

    public static ElGamalResponse error(String errorMessage) {
        ElGamalResponse resp = new ElGamalResponse();
        resp.setSuccess(false);
        resp.setErrorMessage(errorMessage);
        return resp;
    }

    public static ElGamalResponse error(String operation, String errorMessage) {
        ElGamalResponse resp = new ElGamalResponse();
        resp.setSuccess(false);
        resp.setOperation(operation);
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

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getAlgorithm() {
        return algorithm;
    }

    public void setAlgorithm(String algorithm) {
        this.algorithm = algorithm;
    }

    public Integer getKeySize() {
        return keySize;
    }

    public void setKeySize(Integer keySize) {
        this.keySize = keySize;
    }

    public String getCiphertext() {
        return ciphertext;
    }

    public void setCiphertext(String ciphertext) {
        this.ciphertext = ciphertext;
    }

    public String getCiphertextHex() {
        return ciphertextHex;
    }

    public void setCiphertextHex(String ciphertextHex) {
        this.ciphertextHex = ciphertextHex;
    }

    public String getPlaintext() {
        return plaintext;
    }

    public void setPlaintext(String plaintext) {
        this.plaintext = plaintext;
    }

    public String getPublicKeyFingerprint() {
        return publicKeyFingerprint;
    }

    public void setPublicKeyFingerprint(String publicKeyFingerprint) {
        this.publicKeyFingerprint = publicKeyFingerprint;
    }

    public String getPrivateKeyFingerprint() {
        return privateKeyFingerprint;
    }

    public void setPrivateKeyFingerprint(String privateKeyFingerprint) {
        this.privateKeyFingerprint = privateKeyFingerprint;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
