package z.y.x.Security;

import com.google.gson.Gson;

/**
 * JSON response wrapper for SAML operations (Sign, Verify, Decode)
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class SAMLResponse {

    private boolean success;
    private String operation;
    private String errorMessage;

    // Sign operation fields
    private String signedXml;
    private String encodedXml; // DEFLATE+Base64 encoded (for HTTP-Redirect binding / verification)
    private String signature;
    private String signatureAlgorithm;
    private String relayState;
    private String signatureCalculationLogic;
    private String messageType; // SAMLRequest or SAMLResponse

    // Verify operation fields
    private Boolean verified;
    private String verificationMessage;
    private String verifyTarget; // response or assertion

    // Decode operation fields
    private String decodedXml;
    private String decodeMode; // base64 or deflate

    // Input echo (useful for display)
    private String inputXml;
    private String certificate;

    public SAMLResponse() {}

    // Static factory methods for common responses
    public static SAMLResponse signSuccess(String signedXml, String signature, String algorithm) {
        SAMLResponse resp = new SAMLResponse();
        resp.setSuccess(true);
        resp.setOperation("sign");
        resp.setSignedXml(signedXml);
        resp.setSignature(signature);
        resp.setSignatureAlgorithm(algorithm);
        return resp;
    }

    public static SAMLResponse verifySuccess(String message) {
        SAMLResponse resp = new SAMLResponse();
        resp.setSuccess(true);
        resp.setOperation("verify");
        resp.setVerified(true);
        resp.setVerificationMessage(message);
        return resp;
    }

    public static SAMLResponse verifyFailed(String message) {
        SAMLResponse resp = new SAMLResponse();
        resp.setSuccess(true); // Request succeeded, but verification failed
        resp.setOperation("verify");
        resp.setVerified(false);
        resp.setVerificationMessage(message);
        return resp;
    }

    public static SAMLResponse decodeSuccess(String decodedXml, String mode) {
        SAMLResponse resp = new SAMLResponse();
        resp.setSuccess(true);
        resp.setOperation("decode");
        resp.setDecodedXml(decodedXml);
        resp.setDecodeMode(mode);
        return resp;
    }

    public static SAMLResponse error(String operation, String errorMessage) {
        SAMLResponse resp = new SAMLResponse();
        resp.setSuccess(false);
        resp.setOperation(operation);
        resp.setErrorMessage(errorMessage);
        return resp;
    }

    // Getters and Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getOperation() { return operation; }
    public void setOperation(String operation) { this.operation = operation; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public String getSignedXml() { return signedXml; }
    public void setSignedXml(String signedXml) { this.signedXml = signedXml; }

    public String getEncodedXml() { return encodedXml; }
    public void setEncodedXml(String encodedXml) { this.encodedXml = encodedXml; }

    public String getSignature() { return signature; }
    public void setSignature(String signature) { this.signature = signature; }

    public String getSignatureAlgorithm() { return signatureAlgorithm; }
    public void setSignatureAlgorithm(String signatureAlgorithm) { this.signatureAlgorithm = signatureAlgorithm; }

    public String getRelayState() { return relayState; }
    public void setRelayState(String relayState) { this.relayState = relayState; }

    public String getSignatureCalculationLogic() { return signatureCalculationLogic; }
    public void setSignatureCalculationLogic(String signatureCalculationLogic) { this.signatureCalculationLogic = signatureCalculationLogic; }

    public String getMessageType() { return messageType; }
    public void setMessageType(String messageType) { this.messageType = messageType; }

    public Boolean getVerified() { return verified; }
    public void setVerified(Boolean verified) { this.verified = verified; }

    public String getVerificationMessage() { return verificationMessage; }
    public void setVerificationMessage(String verificationMessage) { this.verificationMessage = verificationMessage; }

    public String getVerifyTarget() { return verifyTarget; }
    public void setVerifyTarget(String verifyTarget) { this.verifyTarget = verifyTarget; }

    public String getDecodedXml() { return decodedXml; }
    public void setDecodedXml(String decodedXml) { this.decodedXml = decodedXml; }

    public String getDecodeMode() { return decodeMode; }
    public void setDecodeMode(String decodeMode) { this.decodeMode = decodeMode; }

    public String getInputXml() { return inputXml; }
    public void setInputXml(String inputXml) { this.inputXml = inputXml; }

    public String getCertificate() { return certificate; }
    public void setCertificate(String certificate) { this.certificate = certificate; }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
