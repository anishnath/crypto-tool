package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for NTRU (lattice-based) encryption/decryption operations
 * Post-quantum cryptography with APR2011/EES parameter sets
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class NTRUResponse {

    private boolean success;
    private String operation;      // "keygen", "encrypt", "decrypt"
    private String parameterSet;   // APR2011_743_FAST, EES1087EP2, etc.
    private String errorMessage;

    // Key generation results
    private String publicKey;
    private String privateKey;

    // Encryption/Decryption results
    private String ciphertext;     // Base64 encoded ciphertext
    private String plaintext;      // Decrypted plaintext

    public NTRUResponse() {
    }

    // Static factory methods for key generation
    public static NTRUResponse keyGenSuccess(String publicKey, String privateKey, String parameterSet) {
        NTRUResponse resp = new NTRUResponse();
        resp.setSuccess(true);
        resp.setOperation("keygen");
        resp.setPublicKey(publicKey);
        resp.setPrivateKey(privateKey);
        resp.setParameterSet(parameterSet);
        return resp;
    }

    // Static factory methods for encryption
    public static NTRUResponse encryptSuccess(String ciphertext, String parameterSet) {
        NTRUResponse resp = new NTRUResponse();
        resp.setSuccess(true);
        resp.setOperation("encrypt");
        resp.setCiphertext(ciphertext);
        resp.setParameterSet(parameterSet);
        return resp;
    }

    // Static factory methods for decryption
    public static NTRUResponse decryptSuccess(String plaintext, String parameterSet) {
        NTRUResponse resp = new NTRUResponse();
        resp.setSuccess(true);
        resp.setOperation("decrypt");
        resp.setPlaintext(plaintext);
        resp.setParameterSet(parameterSet);
        return resp;
    }

    // Static factory method for errors
    public static NTRUResponse error(String errorMessage) {
        NTRUResponse resp = new NTRUResponse();
        resp.setSuccess(false);
        resp.setErrorMessage(errorMessage);
        return resp;
    }

    public static NTRUResponse error(String operation, String parameterSet, String errorMessage) {
        NTRUResponse resp = new NTRUResponse();
        resp.setSuccess(false);
        resp.setOperation(operation);
        resp.setParameterSet(parameterSet);
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

    public String getParameterSet() {
        return parameterSet;
    }

    public void setParameterSet(String parameterSet) {
        this.parameterSet = parameterSet;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
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

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
