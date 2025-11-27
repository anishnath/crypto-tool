package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for CSR signing
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class SignCSRResponse {

    private boolean success;
    private String operation;
    private String errorMessage;

    // Certificate data
    private String certificatePem;

    // CSR metadata
    private boolean usedProvidedKey;
    private String crlDistributionPoint;
    private String ocspUrl;

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

    public String getCertificatePem() {
        return certificatePem;
    }

    public void setCertificatePem(String certificatePem) {
        this.certificatePem = certificatePem;
    }

    public boolean isUsedProvidedKey() {
        return usedProvidedKey;
    }

    public void setUsedProvidedKey(boolean usedProvidedKey) {
        this.usedProvidedKey = usedProvidedKey;
    }

    public String getCrlDistributionPoint() {
        return crlDistributionPoint;
    }

    public void setCrlDistributionPoint(String crlDistributionPoint) {
        this.crlDistributionPoint = crlDistributionPoint;
    }

    public String getOcspUrl() {
        return ocspUrl;
    }

    public void setOcspUrl(String ocspUrl) {
        this.ocspUrl = ocspUrl;
    }

    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this, SignCSRResponse.class);
    }
}
