package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for self-signed certificate generation
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class SelfSignedCertResponse {

    private boolean success;
    private String operation;
    private String hostname;
    private String errorMessage;

    // Certificate data
    private String certificatePem;
    private String certificateDecoded;
    private String privateKey;

    // Certificate metadata
    private boolean usedProvidedKey;
    private String version;
    private String expiry;
    private String altNames;

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

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getCertificatePem() {
        return certificatePem;
    }

    public void setCertificatePem(String certificatePem) {
        this.certificatePem = certificatePem;
    }

    public String getCertificateDecoded() {
        return certificateDecoded;
    }

    public void setCertificateDecoded(String certificateDecoded) {
        this.certificateDecoded = certificateDecoded;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public boolean isUsedProvidedKey() {
        return usedProvidedKey;
    }

    public void setUsedProvidedKey(boolean usedProvidedKey) {
        this.usedProvidedKey = usedProvidedKey;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getExpiry() {
        return expiry;
    }

    public void setExpiry(String expiry) {
        this.expiry = expiry;
    }

    public String getAltNames() {
        return altNames;
    }

    public void setAltNames(String altNames) {
        this.altNames = altNames;
    }

    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this, SelfSignedCertResponse.class);
    }
}
