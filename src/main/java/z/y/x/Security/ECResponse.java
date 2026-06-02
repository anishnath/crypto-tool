package z.y.x.Security;

/**
 * JSON wrapper for EC key generation via the unified crypto API.
 */
public class ECResponse {

    private boolean success;
    private String operation;
    private String curve;
    private String errorMessage;

    private String publicKeyAlice;
    private String privateKeyAlice;
    private String publicKeyBob;
    private String privateKeyBob;

    /** ECDSA: PEM private key (maps to JSP field publickeyparam). */
    private String privateKey;
    /** ECDSA: PEM public key (maps to JSP field privatekeyparam). */
    private String publicKey;

    public static ECResponse keyGenEcdhSuccess(ecpojo pojo, String curve) {
        ECResponse r = new ECResponse();
        r.success = true;
        r.operation = "generate_keys";
        r.curve = curve;
        if (pojo != null) {
            r.publicKeyAlice = pojo.getEcpubliceKeyA();
            r.privateKeyAlice = pojo.getEcprivateKeyA();
            r.publicKeyBob = pojo.getEcpubliceKeyB();
            r.privateKeyBob = pojo.getEcprivateKeyB();
        }
        return r;
    }

    public static ECResponse keyGenEcdsaSuccess(ecpojo pojo, String curve) {
        ECResponse r = new ECResponse();
        r.success = true;
        r.operation = "generate_keys";
        r.curve = curve;
        if (pojo != null) {
            r.privateKey = pojo.getEcprivateKeyA();
            r.publicKey = pojo.getEcpubliceKeyA();
        }
        return r;
    }

    public static ECResponse error(String curve, String message) {
        ECResponse r = new ECResponse();
        r.success = false;
        r.operation = "generate_keys";
        r.curve = curve;
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

    public String getCurve() {
        return curve;
    }

    public void setCurve(String curve) {
        this.curve = curve;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getPublicKeyAlice() {
        return publicKeyAlice;
    }

    public void setPublicKeyAlice(String publicKeyAlice) {
        this.publicKeyAlice = publicKeyAlice;
    }

    public String getPrivateKeyAlice() {
        return privateKeyAlice;
    }

    public void setPrivateKeyAlice(String privateKeyAlice) {
        this.privateKeyAlice = privateKeyAlice;
    }

    public String getPublicKeyBob() {
        return publicKeyBob;
    }

    public void setPublicKeyBob(String publicKeyBob) {
        this.publicKeyBob = publicKeyBob;
    }

    public String getPrivateKeyBob() {
        return privateKeyBob;
    }

    public void setPrivateKeyBob(String privateKeyBob) {
        this.privateKeyBob = privateKeyBob;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }
}
