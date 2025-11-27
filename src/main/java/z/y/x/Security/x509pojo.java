package z.y.x.Security;

import java.util.List;

import com.google.gson.Gson;

public class x509pojo {

    private String type;
    private String version;
    private String SerialNumber;
    private String SigAlgName;
    private String NotBefore;
    private String NotAfter;
    private String SubjectDN;
    private String IssuerDN;

    private String SigAlgOID;

    private String SubjectAlternativeNames;


    private String encoded;



    private String isSelfSigned;

    private String signature;
    private String md5;
    private String sha256;
    private String sha1;

    private String crticalExtensions;
    private String noncrticalExtensions;

    // Subject Public Key Info
    private String publicKeyAlgorithm;
    private String publicKeySize;
    private String publicKey;









    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((IssuerDN == null) ? 0 : IssuerDN.hashCode());
        result = prime * result + ((NotAfter == null) ? 0 : NotAfter.hashCode());
        result = prime * result + ((NotBefore == null) ? 0 : NotBefore.hashCode());
        result = prime * result + ((SerialNumber == null) ? 0 : SerialNumber.hashCode());
        result = prime * result + ((SigAlgName == null) ? 0 : SigAlgName.hashCode());
        result = prime * result + ((SigAlgOID == null) ? 0 : SigAlgOID.hashCode());
        result = prime * result + ((SubjectAlternativeNames == null) ? 0 : SubjectAlternativeNames.hashCode());
        result = prime * result + ((SubjectDN == null) ? 0 : SubjectDN.hashCode());
        result = prime * result + ((crticalExtensions == null) ? 0 : crticalExtensions.hashCode());
        result = prime * result + ((encoded == null) ? 0 : encoded.hashCode());
        result = prime * result + ((isSelfSigned == null) ? 0 : isSelfSigned.hashCode());
        result = prime * result + ((md5 == null) ? 0 : md5.hashCode());
        result = prime * result + ((noncrticalExtensions == null) ? 0 : noncrticalExtensions.hashCode());
        result = prime * result + ((sha1 == null) ? 0 : sha1.hashCode());
        result = prime * result + ((sha256 == null) ? 0 : sha256.hashCode());
        result = prime * result + ((signature == null) ? 0 : signature.hashCode());
        result = prime * result + ((type == null) ? 0 : type.hashCode());
        result = prime * result + ((version == null) ? 0 : version.hashCode());
        return result;
    }









    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        x509pojo other = (x509pojo) obj;
        if (IssuerDN == null) {
            if (other.IssuerDN != null)
                return false;
        } else if (!IssuerDN.equals(other.IssuerDN))
            return false;
        if (NotAfter == null) {
            if (other.NotAfter != null)
                return false;
        } else if (!NotAfter.equals(other.NotAfter))
            return false;
        if (NotBefore == null) {
            if (other.NotBefore != null)
                return false;
        } else if (!NotBefore.equals(other.NotBefore))
            return false;
        if (SerialNumber == null) {
            if (other.SerialNumber != null)
                return false;
        } else if (!SerialNumber.equals(other.SerialNumber))
            return false;
        if (SigAlgName == null) {
            if (other.SigAlgName != null)
                return false;
        } else if (!SigAlgName.equals(other.SigAlgName))
            return false;
        if (SigAlgOID == null) {
            if (other.SigAlgOID != null)
                return false;
        } else if (!SigAlgOID.equals(other.SigAlgOID))
            return false;
        if (SubjectAlternativeNames == null) {
            if (other.SubjectAlternativeNames != null)
                return false;
        } else if (!SubjectAlternativeNames.equals(other.SubjectAlternativeNames))
            return false;
        if (SubjectDN == null) {
            if (other.SubjectDN != null)
                return false;
        } else if (!SubjectDN.equals(other.SubjectDN))
            return false;
        if (crticalExtensions == null) {
            if (other.crticalExtensions != null)
                return false;
        } else if (!crticalExtensions.equals(other.crticalExtensions))
            return false;
        if (encoded == null) {
            if (other.encoded != null)
                return false;
        } else if (!encoded.equals(other.encoded))
            return false;
        if (isSelfSigned == null) {
            if (other.isSelfSigned != null)
                return false;
        } else if (!isSelfSigned.equals(other.isSelfSigned))
            return false;
        if (md5 == null) {
            if (other.md5 != null)
                return false;
        } else if (!md5.equals(other.md5))
            return false;
        if (noncrticalExtensions == null) {
            if (other.noncrticalExtensions != null)
                return false;
        } else if (!noncrticalExtensions.equals(other.noncrticalExtensions))
            return false;
        if (sha1 == null) {
            if (other.sha1 != null)
                return false;
        } else if (!sha1.equals(other.sha1))
            return false;
        if (sha256 == null) {
            if (other.sha256 != null)
                return false;
        } else if (!sha256.equals(other.sha256))
            return false;
        if (signature == null) {
            if (other.signature != null)
                return false;
        } else if (!signature.equals(other.signature))
            return false;
        if (type == null) {
            if (other.type != null)
                return false;
        } else if (!type.equals(other.type))
            return false;
        if (version == null) {
            if (other.version != null)
                return false;
        } else if (!version.equals(other.version))
            return false;
        return true;
    }









    public String getType() {
        return type;
    }









    public void setType(String type) {
        this.type = type;
    }









    public String getVersion() {
        return version;
    }









    public void setVersion(String version) {
        this.version = version;
    }









    public String getSerialNumber() {
        return SerialNumber;
    }









    public void setSerialNumber(String serialNumber) {
        SerialNumber = serialNumber;
    }









    public String getSigAlgName() {
        return SigAlgName;
    }









    public void setSigAlgName(String sigAlgName) {
        SigAlgName = sigAlgName;
    }









    public String getNotBefore() {
        return NotBefore;
    }









    public void setNotBefore(String notBefore) {
        NotBefore = notBefore;
    }









    public String getNotAfter() {
        return NotAfter;
    }









    public void setNotAfter(String notAfter) {
        NotAfter = notAfter;
    }









    public String getSubjectDN() {
        return SubjectDN;
    }









    public void setSubjectDN(String subjectDN) {
        SubjectDN = subjectDN;
    }









    public String getIssuerDN() {
        return IssuerDN;
    }









    public void setIssuerDN(String issuerDN) {
        IssuerDN = issuerDN;
    }









    public String getSigAlgOID() {
        return SigAlgOID;
    }









    public void setSigAlgOID(String sigAlgOID) {
        SigAlgOID = sigAlgOID;
    }









    public String getSubjectAlternativeNames() {
        return SubjectAlternativeNames;
    }









    public void setSubjectAlternativeNames(String subjectAlternativeNames) {
        SubjectAlternativeNames = subjectAlternativeNames;
    }









    public String getEncoded() {
        return encoded;
    }









    public void setEncoded(String encoded) {
        this.encoded = encoded;
    }









    public String getIsSelfSigned() {
        return isSelfSigned;
    }









    public void setIsSelfSigned(String isSelfSigned) {
        this.isSelfSigned = isSelfSigned;
    }









    public String getSignature() {
        return signature;
    }









    public void setSignature(String signature) {
        this.signature = signature;
    }









    public String getMd5() {
        return md5;
    }









    public void setMd5(String md5) {
        this.md5 = md5;
    }









    public String getSha256() {
        return sha256;
    }









    public void setSha256(String sha256) {
        this.sha256 = sha256;
    }









    public String getSha1() {
        return sha1;
    }









    public void setSha1(String sha1) {
        this.sha1 = sha1;
    }









    public String getCrticalExtensions() {
        return crticalExtensions;
    }









    public void setCrticalExtensions(String crticalExtensions) {
        this.crticalExtensions = crticalExtensions;
    }









    public String getNoncrticalExtensions() {
        return noncrticalExtensions;
    }









    public void setNoncrticalExtensions(String noncrticalExtensions) {
        this.noncrticalExtensions = noncrticalExtensions;
    }

    public String getPublicKeyAlgorithm() {
        return publicKeyAlgorithm;
    }

    public void setPublicKeyAlgorithm(String publicKeyAlgorithm) {
        this.publicKeyAlgorithm = publicKeyAlgorithm;
    }

    public String getPublicKeySize() {
        return publicKeySize;
    }

    public void setPublicKeySize(String publicKeySize) {
        this.publicKeySize = publicKeySize;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }









    @Override
    public String toString() {
        Gson gson = new Gson();
        String json = gson.toJson(this, x509pojo.class);
        return json;
    }
}