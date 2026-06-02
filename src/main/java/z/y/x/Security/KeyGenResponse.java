package z.y.x.Security;

/**
 * JSON response for asymmetric key generation (DSA, ElGamal, etc.).
 */
public class KeyGenResponse {

    private boolean success;
    private String operation;
    private String keySize;
    private String publicKey;
    private String privateKey;
    private String errorMessage;

    public static KeyGenResponse success(String keySize, String publicKey, String privateKey) {
        KeyGenResponse r = new KeyGenResponse();
        r.success = true;
        r.operation = "generate_keys";
        r.keySize = keySize;
        r.publicKey = publicKey;
        r.privateKey = privateKey;
        return r;
    }

    public static KeyGenResponse error(String keySize, String message) {
        KeyGenResponse r = new KeyGenResponse();
        r.success = false;
        r.operation = "generate_keys";
        r.keySize = keySize;
        r.errorMessage = message;
        return r;
    }

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

    public String getKeySize() {
        return keySize;
    }

    public void setKeySize(String keySize) {
        this.keySize = keySize;
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

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
