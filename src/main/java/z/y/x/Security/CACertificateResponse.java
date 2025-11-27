package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for CA certificate generation
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class CACertificateResponse {

    private boolean success;
    private String operation;
    private String hostname;
    private String errorMessage;

    // Server certificate info
    private String serverPrivateKey;
    private String serverPublicKey;
    private String serverCertificate;

    // Intermediate CA info
    private String intermediatePrivateKey;
    private String intermediatePublicKey;
    private String intermediateCertificate;

    // Root CA info
    private String rootPrivateKey;
    private String rootPublicKey;
    private String rootCertificate;

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

    public String getServerPrivateKey() {
        return serverPrivateKey;
    }

    public void setServerPrivateKey(String serverPrivateKey) {
        this.serverPrivateKey = serverPrivateKey;
    }

    public String getServerPublicKey() {
        return serverPublicKey;
    }

    public void setServerPublicKey(String serverPublicKey) {
        this.serverPublicKey = serverPublicKey;
    }

    public String getServerCertificate() {
        return serverCertificate;
    }

    public void setServerCertificate(String serverCertificate) {
        this.serverCertificate = serverCertificate;
    }

    public String getIntermediatePrivateKey() {
        return intermediatePrivateKey;
    }

    public void setIntermediatePrivateKey(String intermediatePrivateKey) {
        this.intermediatePrivateKey = intermediatePrivateKey;
    }

    public String getIntermediatePublicKey() {
        return intermediatePublicKey;
    }

    public void setIntermediatePublicKey(String intermediatePublicKey) {
        this.intermediatePublicKey = intermediatePublicKey;
    }

    public String getIntermediateCertificate() {
        return intermediateCertificate;
    }

    public void setIntermediateCertificate(String intermediateCertificate) {
        this.intermediateCertificate = intermediateCertificate;
    }

    public String getRootPrivateKey() {
        return rootPrivateKey;
    }

    public void setRootPrivateKey(String rootPrivateKey) {
        this.rootPrivateKey = rootPrivateKey;
    }

    public String getRootPublicKey() {
        return rootPublicKey;
    }

    public void setRootPublicKey(String rootPublicKey) {
        this.rootPublicKey = rootPublicKey;
    }

    public String getRootCertificate() {
        return rootCertificate;
    }

    public void setRootCertificate(String rootCertificate) {
        this.rootCertificate = rootCertificate;
    }

    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this, CACertificateResponse.class);
    }
}
