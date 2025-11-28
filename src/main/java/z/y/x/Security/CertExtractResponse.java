package z.y.x.Security;

import com.google.gson.Gson;
import java.util.List;
import java.util.ArrayList;

/**
 * JSON response wrapper for SSL certificate extraction
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class CertExtractResponse {

    private boolean success;
    private String operation;
    private String errorMessage;
    private String hostname;
    private int port;
    private int certificateCount;
    private List<CertificateInfo> certificates;
    private String fullChainPem;

    public CertExtractResponse() {
        this.certificates = new ArrayList<>();
    }

    // Nested class for individual certificate info
    public static class CertificateInfo {
        private int index;
        private String type; // "server", "intermediate", "root"
        private String pem;

        public CertificateInfo() {}

        public CertificateInfo(int index, String type, String pem) {
            this.index = index;
            this.type = type;
            this.pem = pem;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getPem() {
            return pem;
        }

        public void setPem(String pem) {
            this.pem = pem;
        }
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

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }

    public int getCertificateCount() {
        return certificateCount;
    }

    public void setCertificateCount(int certificateCount) {
        this.certificateCount = certificateCount;
    }

    public List<CertificateInfo> getCertificates() {
        return certificates;
    }

    public void setCertificates(List<CertificateInfo> certificates) {
        this.certificates = certificates;
    }

    public void addCertificate(CertificateInfo cert) {
        this.certificates.add(cert);
    }

    public String getFullChainPem() {
        return fullChainPem;
    }

    public void setFullChainPem(String fullChainPem) {
        this.fullChainPem = fullChainPem;
    }

    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this, CertExtractResponse.class);
    }
}
