package z.y.x.Security;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.math.BigInteger;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Signature;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.cert.CertPath;
import java.security.cert.CertPathValidator;
import java.security.cert.CertPathValidatorException;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.PKIXParameters;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPublicKey;
import java.security.interfaces.ECPublicKey;
import java.security.interfaces.DSAPublicKey;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.Enumeration;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.SSLSession;
import javax.security.auth.x500.X500Principal;

/**
 * Pure Java KeyStore Service - replaces Scala dependencies
 * Handles JKS, PKCS12, and other keystore operations
 *
 * @author Anish Nath
 */
public class JKSService {

    private KeyStore keyStore;
    private String password;
    private byte[] originalBytes;

    /**
     * Initialize JKS Service with keystore bytes
     * @param keystoreBytes the keystore file bytes
     * @param password the keystore password (can be null for viewing)
     * @throws Exception if keystore cannot be loaded
     */
    public JKSService(byte[] keystoreBytes, String password) throws Exception {
        this.originalBytes = keystoreBytes;
        this.password = password;
        this.keyStore = loadKeyStore(keystoreBytes, password);
    }

    /**
     * Load a keystore from bytes, auto-detecting the type (JKS, PKCS12, etc.)
     */
    private KeyStore loadKeyStore(byte[] bytes, String password) throws Exception {
        if (bytes == null || bytes.length == 0) {
            throw new Exception("Please provide the KeyStore");
        }

        char[] pwd = (password != null && !password.isEmpty()) ? password.toCharArray() : null;

        // Try JKS first
        try {
            KeyStore ks = KeyStore.getInstance("JKS");
            ks.load(new ByteArrayInputStream(bytes), pwd);
            return ks;
        } catch (Exception e) {
            // JKS failed, try PKCS12
        }

        // Try PKCS12
        try {
            KeyStore ks = KeyStore.getInstance("PKCS12");
            ks.load(new ByteArrayInputStream(bytes), pwd);
            return ks;
        } catch (Exception e) {
            // PKCS12 failed
        }

        // Try JCEKS
        try {
            KeyStore ks = KeyStore.getInstance("JCEKS");
            ks.load(new ByteArrayInputStream(bytes), pwd);
            return ks;
        } catch (Exception e) {
            // JCEKS failed
        }

        // Default to JKS with null password for viewing
        KeyStore ks = KeyStore.getInstance("JKS");
        ks.load(new ByteArrayInputStream(bytes), null);
        return ks;
    }

    /**
     * Get all alias names from the keystore
     * @return list of alias names
     */
    public List<String> listAllAliases() throws Exception {
        List<String> aliases = new ArrayList<>();
        Enumeration<String> enumeration = keyStore.aliases();
        while (enumeration.hasMoreElements()) {
            aliases.add(enumeration.nextElement());
        }
        return aliases;
    }

    /**
     * Get the total number of entries in the keystore
     */
    public int getEntryCount() throws Exception {
        return keyStore.size();
    }

    /**
     * Get keystore type (JKS, PKCS12, etc.)
     */
    public String getKeyStoreType() {
        return keyStore.getType();
    }

    /**
     * Check if an alias is a certificate entry
     */
    public boolean isCertificateEntry(String alias) throws Exception {
        return keyStore.isCertificateEntry(alias);
    }

    /**
     * Check if an alias is a key entry
     */
    public boolean isKeyEntry(String alias) throws Exception {
        return keyStore.isKeyEntry(alias);
    }

    /**
     * Get certificate for a specific alias
     * @param alias the alias name
     * @return the certificate or null
     */
    public Certificate getCertificate(String alias) throws Exception {
        return keyStore.getCertificate(alias);
    }

    /**
     * Get X509 certificate details for an alias
     * @param alias the alias name
     * @return map containing certificate details
     */
    public Map<String, Object> getCertificateDetails(String alias) throws Exception {
        Map<String, Object> details = new HashMap<>();
        Certificate cert = keyStore.getCertificate(alias);

        if (cert == null) {
            return details;
        }

        details.put("alias", alias);
        details.put("type", cert.getType());
        details.put("isCertEntry", keyStore.isCertificateEntry(alias));
        details.put("isKeyEntry", keyStore.isKeyEntry(alias));

        if (cert instanceof X509Certificate) {
            X509Certificate x509 = (X509Certificate) cert;
            details.put("x509", x509);
            details.put("version", x509.getVersion());
            details.put("subject", x509.getSubjectDN().toString());
            details.put("issuer", x509.getIssuerDN().toString());
            details.put("serialNumber", x509.getSerialNumber().toString());
            details.put("signatureAlgorithm", x509.getSigAlgName());
            details.put("notBefore", x509.getNotBefore());
            details.put("notAfter", x509.getNotAfter());
            details.put("basicConstraints", x509.getBasicConstraints());

            // Public key info with key size and curve
            if (x509.getPublicKey() != null) {
                details.put("publicKeyAlgorithm", x509.getPublicKey().getAlgorithm());
                details.put("publicKeyFormat", x509.getPublicKey().getFormat());
                details.put("publicKeyEncoded", bytesToHex(x509.getPublicKey().getEncoded()));

                if (x509.getPublicKey() instanceof RSAPublicKey) {
                    RSAPublicKey rsaKey = (RSAPublicKey) x509.getPublicKey();
                    int keySize = rsaKey.getModulus().bitLength();
                    details.put("keySize", keySize);
                    details.put("keySizeLabel", keySize + "-bit RSA");
                    details.put("publicExponent", rsaKey.getPublicExponent().toString());
                } else if (x509.getPublicKey() instanceof ECPublicKey) {
                    ECPublicKey ecKey = (ECPublicKey) x509.getPublicKey();
                    int fieldSize = ecKey.getParams().getCurve().getField().getFieldSize();
                    details.put("keySize", fieldSize);
                    details.put("curveName", getECCurveName(fieldSize));
                    details.put("keySizeLabel", fieldSize + "-bit EC (" + getECCurveName(fieldSize) + ")");
                } else if (x509.getPublicKey() instanceof DSAPublicKey) {
                    DSAPublicKey dsaKey = (DSAPublicKey) x509.getPublicKey();
                    int keySize = dsaKey.getParams().getP().bitLength();
                    details.put("keySize", keySize);
                    details.put("keySizeLabel", keySize + "-bit DSA");
                }
            }

            // Signature
            if (x509.getSignature() != null) {
                details.put("signature", bytesToHex(x509.getSignature()));
            }

            // Extensions
            if (x509.getCriticalExtensionOIDs() != null) {
                details.put("criticalExtensions", new ArrayList<>(x509.getCriticalExtensionOIDs()));
            }
            if (x509.getNonCriticalExtensionOIDs() != null) {
                details.put("nonCriticalExtensions", new ArrayList<>(x509.getNonCriticalExtensionOIDs()));
            }
            details.put("extensionDetails", getX509ExtensionDetails(x509));

            // Check if self-signed
            try {
                x509.verify(x509.getPublicKey());
                details.put("selfSigned", true);
            } catch (Exception e) {
                details.put("selfSigned", false);
            }

            // Certificate chain
            Certificate[] chain = keyStore.getCertificateChain(alias);
            if (chain != null) {
                details.put("chainLength", chain.length);
            }
        }

        return details;
    }

    /**
     * Export certificate as PEM format
     * @param alias the alias name
     * @return PEM formatted certificate string
     */
    public String exportCertificateAsPEM(String alias) throws Exception {
        Certificate cert = keyStore.getCertificate(alias);
        if (cert == null) {
            throw new Exception("Certificate not found for alias: " + alias);
        }

        StringBuilder pem = new StringBuilder();
        pem.append("-----BEGIN CERTIFICATE-----\n");
        String base64 = Base64.getMimeEncoder(64, "\n".getBytes()).encodeToString(cert.getEncoded());
        pem.append(base64);
        pem.append("\n-----END CERTIFICATE-----\n");

        return pem.toString();
    }

    /**
     * Export full certificate chain as PEM
     */
    public String exportCertificateChainAsPEM(String alias) throws Exception {
        Certificate[] chain = keyStore.getCertificateChain(alias);
        if (chain == null || chain.length == 0) {
            return exportCertificateAsPEM(alias);
        }

        StringBuilder pem = new StringBuilder();
        for (Certificate cert : chain) {
            pem.append("-----BEGIN CERTIFICATE-----\n");
            String base64 = Base64.getMimeEncoder(64, "\n".getBytes()).encodeToString(cert.getEncoded());
            pem.append(base64);
            pem.append("\n-----END CERTIFICATE-----\n\n");
        }

        return pem.toString();
    }

    /**
     * Rename an alias in the keystore
     * @param oldAlias the current alias name
     * @param newAlias the new alias name
     * @return updated keystore bytes
     */
    public byte[] renameAlias(String oldAlias, String newAlias) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password to rename alias");
        }
        if (keyStore.containsAlias(newAlias)) {
            throw new Exception("Alias '" + newAlias + "' already exists");
        }

        if (keyStore.isKeyEntry(oldAlias)) {
            Key key = keyStore.getKey(oldAlias, password.toCharArray());
            Certificate[] chain = keyStore.getCertificateChain(oldAlias);
            keyStore.deleteEntry(oldAlias);
            keyStore.setKeyEntry(newAlias, key, password.toCharArray(), chain);
        } else {
            Certificate cert = keyStore.getCertificate(oldAlias);
            keyStore.deleteEntry(oldAlias);
            keyStore.setCertificateEntry(newAlias, cert);
        }
        return exportKeyStore();
    }

    /**
     * Get fingerprints for a certificate (SHA-256, SHA-1)
     */
    private Map<String, String> getFingerprintsForCert(Certificate cert) {
        Map<String, String> fps = new HashMap<>();
        if (cert == null) return fps;
        try {
            byte[] encoded = cert.getEncoded();
            try {
                MessageDigest md256 = MessageDigest.getInstance("SHA-256");
                fps.put("SHA-256", bytesToHex(md256.digest(encoded)));
            } catch (Exception e) { /* ignore */ }
            try {
                MessageDigest md1 = MessageDigest.getInstance("SHA-1");
                fps.put("SHA-1", bytesToHex(md1.digest(encoded)));
            } catch (Exception e) { /* ignore */ }
        } catch (Exception e) { /* ignore */ }
        return fps;
    }

    /**
     * Get certificate fingerprints (SHA-256, SHA-1)
     */
    public Map<String, String> getCertificateFingerprints(String alias) throws Exception {
        return getFingerprintsForCert(keyStore.getCertificate(alias));
    }

    /**
     * Export certificate as DER (binary)
     */
    public byte[] exportCertificateAsDER(String alias) throws Exception {
        Certificate cert = keyStore.getCertificate(alias);
        if (cert == null) throw new Exception("Certificate not found for alias: " + alias);
        return cert.getEncoded();
    }

    /**
     * Export certificate as Base64 only (no PEM headers)
     */
    public String exportCertificateAsBase64(String alias) throws Exception {
        byte[] der = exportCertificateAsDER(alias);
        return Base64.getMimeEncoder(64, "\n".getBytes()).encodeToString(der);
    }

    /**
     * Delete an alias from the keystore
     * @param alias the alias to delete
     * @return updated keystore bytes
     */
    public byte[] deleteAlias(String alias) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password to delete alias");
        }

        keyStore.deleteEntry(alias);
        return exportKeyStore();
    }

    /**
     * Export the current keystore state as bytes
     * @return keystore bytes
     */
    public byte[] exportKeyStore() throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password to export");
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        keyStore.store(baos, password.toCharArray());
        return baos.toByteArray();
    }

    /**
     * Convert keystore to a different format (JKS, PKCS12, JCEKS)
     * @param targetType JKS, PKCS12, or JCEKS
     * @param newPassword password for the new keystore (can be same as current)
     * @return new keystore bytes
     */
    public byte[] convertKeystoreType(String targetType, String newPassword) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password");
        }
        if (newPassword == null || newPassword.isEmpty()) {
            throw new Exception("New password is required");
        }

        KeyStore targetKs = KeyStore.getInstance(targetType);
        targetKs.load(null, newPassword.toCharArray());

        char[] pwd = password.toCharArray();
        char[] newPwd = newPassword.toCharArray();
        Enumeration<String> aliases = keyStore.aliases();

        while (aliases.hasMoreElements()) {
            String alias = aliases.nextElement();
            if (keyStore.isKeyEntry(alias)) {
                Key key = keyStore.getKey(alias, pwd);
                Certificate[] chain = keyStore.getCertificateChain(alias);
                targetKs.setKeyEntry(alias, key, newPwd, chain);
            } else {
                Certificate cert = keyStore.getCertificate(alias);
                targetKs.setCertificateEntry(alias, cert);
            }
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        targetKs.store(baos, newPwd);
        return baos.toByteArray();
    }

    /**
     * Change the keystore password
     * @param newPassword the new password
     * @return updated keystore bytes
     */
    public byte[] changeStorePassword(String newPassword) throws Exception {
        return convertKeystoreType(keyStore.getType(), newPassword);
    }

    /**
     * Append a certificate to the chain of a key entry (e.g. import CA reply)
     * @param alias the key pair alias
     * @param pemCert PEM-encoded certificate to append
     * @return updated keystore bytes
     */
    public byte[] appendCertificateToChain(String alias, String pemCert) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password");
        }
        if (!keyStore.isKeyEntry(alias)) {
            throw new Exception("Alias '" + alias + "' is not a key entry (no private key)");
        }

        String base64 = pemCert
                .replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s", "");
        byte[] certBytes = Base64.getDecoder().decode(base64);
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate newCert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(certBytes));

        Key key = keyStore.getKey(alias, password.toCharArray());
        Certificate[] existingChain = keyStore.getCertificateChain(alias);
        if (existingChain == null) existingChain = new Certificate[0];

        Certificate[] newChain = new Certificate[existingChain.length + 1];
        System.arraycopy(existingChain, 0, newChain, 0, existingChain.length);
        newChain[existingChain.length] = newCert;

        keyStore.setKeyEntry(alias, key, password.toCharArray(), newChain);
        return exportKeyStore();
    }

    /**
     * Change the key password for a key entry
     * @param alias the key pair alias
     * @param newKeyPassword the new password for the key
     * @return updated keystore bytes
     */
    public byte[] changeKeyPassword(String alias, String newKeyPassword) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password");
        }
        if (!keyStore.isKeyEntry(alias)) {
            throw new Exception("Alias '" + alias + "' is not a key entry");
        }

        Key key = keyStore.getKey(alias, password.toCharArray());
        Certificate[] chain = keyStore.getCertificateChain(alias);
        keyStore.deleteEntry(alias);
        keyStore.setKeyEntry(alias, key, newKeyPassword.toCharArray(), chain);
        return exportKeyStore();
    }

    /**
     * Duplicate an entry (key pair or trusted cert) to a new alias
     * @param sourceAlias the alias to copy
     * @param newAlias the new alias name
     * @return updated keystore bytes
     */
    public byte[] duplicateAlias(String sourceAlias, String newAlias) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password");
        }
        if (keyStore.containsAlias(newAlias)) {
            throw new Exception("Alias '" + newAlias + "' already exists");
        }

        if (keyStore.isKeyEntry(sourceAlias)) {
            Key key = keyStore.getKey(sourceAlias, password.toCharArray());
            Certificate[] chain = keyStore.getCertificateChain(sourceAlias);
            keyStore.setKeyEntry(newAlias, key, password.toCharArray(), chain);
        } else {
            Certificate cert = keyStore.getCertificate(sourceAlias);
            keyStore.setCertificateEntry(newAlias, cert);
        }
        return exportKeyStore();
    }

    /**
     * Import certificate from DER (binary or base64 without PEM headers)
     * @param derOrBase64 either raw DER bytes (as base64) or base64-encoded certificate
     * @param alias the alias to use
     * @param overwrite if true, replace existing alias; if false, throw if exists
     * @return updated keystore bytes
     */
    public byte[] importCertificateFromDer(String derOrBase64, String alias, boolean overwrite) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Password is required to import certificate");
        }

        String cleaned = derOrBase64.replaceAll("\\s", "");
        byte[] certBytes = Base64.getDecoder().decode(cleaned);
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(certBytes));

        if (keyStore.containsAlias(alias)) {
            if (!overwrite) throw new Exception("Alias '" + alias + "' already exists");
            keyStore.deleteEntry(alias);
        }
        keyStore.setCertificateEntry(alias, cert);
        return exportKeyStore();
    }

    /**
     * Import a key pair (private key + certificate chain) into the keystore
     * @param pemPrivateKey PEM-encoded PKCS#8 private key
     * @param pemCertChain PEM certificate(s) - single cert or chain (leaf first)
     * @param alias the alias to use
     * @param keyPassword password for the key entry
     * @return updated keystore bytes
     */
    public byte[] importKeyPair(String pemPrivateKey, String pemCertChain, String alias, String keyPassword) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Keystore password is required");
        }
        if (keyStore.containsAlias(alias)) {
            throw new Exception("Alias '" + alias + "' already exists");
        }

        PrivateKey privateKey = parsePemPrivateKey(pemPrivateKey);
        Certificate[] chain = parsePemCertificateChain(pemCertChain);
        if (chain == null || chain.length == 0) {
            throw new Exception("At least one certificate is required");
        }

        keyStore.setKeyEntry(alias, privateKey, keyPassword.toCharArray(), chain);
        return exportKeyStore();
    }

    private PrivateKey parsePemPrivateKey(String pem) throws Exception {
        if (!pem.contains("-----BEGIN PRIVATE KEY-----")) {
            throw new Exception("PKCS#8 format required (-----BEGIN PRIVATE KEY-----). Use: openssl pkcs8 -topk8 -in key.pem -out key_pkcs8.pem");
        }
        String base64 = pem
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s", "");
        byte[] keyBytes = Base64.getDecoder().decode(base64);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        for (String alg : new String[]{"RSA", "EC", "DSA"}) {
            try {
                return KeyFactory.getInstance(alg).generatePrivate(spec);
            } catch (Exception e) {
                if ("DSA".equals(alg)) throw new Exception("Could not parse private key - supported: RSA, EC, DSA");
            }
        }
        throw new Exception("Could not parse private key");
    }

    private Certificate[] parsePemCertificateChain(String pem) throws Exception {
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        List<Certificate> certs = new ArrayList<>();
        String rest = pem;
        while (rest.contains("-----BEGIN CERTIFICATE-----")) {
            int start = rest.indexOf("-----BEGIN CERTIFICATE-----");
            int end = rest.indexOf("-----END CERTIFICATE-----") + 25;
            String block = rest.substring(start, end);
            String base64 = block.replace("-----BEGIN CERTIFICATE-----", "")
                    .replace("-----END CERTIFICATE-----", "").replaceAll("\\s", "");
            certs.add(cf.generateCertificate(new ByteArrayInputStream(Base64.getDecoder().decode(base64))));
            rest = rest.substring(end);
        }
        return certs.toArray(new Certificate[0]);
    }

    /**
     * Verify the certificate chain for an alias against the keystore trust (CA certs)
     * @param alias the alias to verify (key entry or cert entry)
     * @return map with valid, errorMessage, chainLength
     */
    public Map<String, Object> verifyCertificateChain(String alias) throws Exception {
        Map<String, Object> result = new HashMap<>();
        Certificate cert = keyStore.getCertificate(alias);
        if (cert == null || !(cert instanceof X509Certificate)) {
            result.put("valid", false);
            result.put("errorMessage", "No X509 certificate found for alias");
            return result;
        }

        X509Certificate[] chain;
        if (keyStore.isKeyEntry(alias)) {
            Certificate[] c = keyStore.getCertificateChain(alias);
            if (c != null && c.length > 0) {
                chain = new X509Certificate[c.length];
                for (int i = 0; i < c.length; i++) chain[i] = (X509Certificate) c[i];
            } else {
                chain = new X509Certificate[]{(X509Certificate) cert};
            }
        } else {
            chain = new X509Certificate[]{(X509Certificate) cert};
        }

        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);
            Enumeration<String> aliases = keyStore.aliases();
            while (aliases.hasMoreElements()) {
                String a = aliases.nextElement();
                if (a.equals(alias)) continue;
                Certificate tc = keyStore.getCertificate(a);
                if (tc instanceof X509Certificate) {
                    X509Certificate x = (X509Certificate) tc;
                    if (x.getBasicConstraints() >= 0) {
                        trustStore.setCertificateEntry(a, tc);
                    }
                }
            }
            for (X509Certificate c : chain) {
                if (c.getBasicConstraints() >= 0 && !trustStore.containsAlias("temp-" + c.getSerialNumber())) {
                    trustStore.setCertificateEntry("temp-" + c.getSerialNumber(), c);
                }
            }
            if (trustStore.size() == 0) {
                result.put("valid", false);
                result.put("errorMessage", "No trust anchor (CA cert) found in keystore");
                result.put("chainLength", chain.length);
                return result;
            }

            CertPathValidator validator = CertPathValidator.getInstance("PKIX");
            PKIXParameters params = new PKIXParameters(trustStore);
            params.setRevocationEnabled(false);
            CertPath path = CertificateFactory.getInstance("X.509")
                    .generateCertPath(Arrays.asList(chain));
            validator.validate(path, params);
            result.put("valid", true);
            result.put("chainLength", chain.length);
        } catch (CertPathValidatorException e) {
            result.put("valid", false);
            result.put("errorMessage", e.getMessage());
            result.put("chainLength", chain.length);
        }
        return result;
    }

    /**
     * Get the key for a specific alias (requires password)
     */
    public Key getKey(String alias) throws Exception {
        if (password == null || password.isEmpty()) {
            return null;
        }
        return keyStore.getKey(alias, password.toCharArray());
    }

    /**
     * Get summary info for all aliases
     * @return list of alias summaries
     */
    public List<Map<String, Object>> getAllAliasesSummary() throws Exception {
        List<Map<String, Object>> summaries = new ArrayList<>();
        Enumeration<String> enumeration = keyStore.aliases();

        while (enumeration.hasMoreElements()) {
            String alias = enumeration.nextElement();
            Map<String, Object> summary = new HashMap<>();
            summary.put("alias", alias);
            summary.put("isCertEntry", keyStore.isCertificateEntry(alias));
            summary.put("isKeyEntry", keyStore.isKeyEntry(alias));

            Certificate cert = keyStore.getCertificate(alias);
            if (cert instanceof X509Certificate) {
                X509Certificate x509 = (X509Certificate) cert;
                summary.put("subject", x509.getSubjectDN().toString());
                summary.put("notAfter", x509.getNotAfter());
                summary.put("algorithm", x509.getSigAlgName());

                // Check expiry status
                try {
                    x509.checkValidity();
                    summary.put("valid", true);
                } catch (Exception e) {
                    summary.put("valid", false);
                }
            }

            summaries.add(summary);
        }

        return summaries;
    }

    /**
     * Convert bytes to hex string
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    /** Well-known X.509 extension OID to name mapping */
    private static final Map<String, String> EXT_OID_NAMES = new HashMap<>();
    static {
        EXT_OID_NAMES.put("2.5.29.19", "Basic Constraints");
        EXT_OID_NAMES.put("2.5.29.15", "Key Usage");
        EXT_OID_NAMES.put("2.5.29.37", "Extended Key Usage");
        EXT_OID_NAMES.put("2.5.29.17", "Subject Alternative Name");
        EXT_OID_NAMES.put("2.5.29.18", "Issuer Alternative Name");
        EXT_OID_NAMES.put("2.5.29.14", "Subject Key Identifier");
        EXT_OID_NAMES.put("2.5.29.35", "Authority Key Identifier");
        EXT_OID_NAMES.put("1.3.6.1.5.5.7.1.1", "Authority Information Access");
        EXT_OID_NAMES.put("2.5.29.31", "CRL Distribution Points");
        EXT_OID_NAMES.put("2.5.29.32", "Certificate Policies");
        EXT_OID_NAMES.put("2.5.29.33", "Policy Mappings");
        EXT_OID_NAMES.put("2.5.29.36", "Policy Constraints");
        EXT_OID_NAMES.put("2.5.29.30", "Name Constraints");
        EXT_OID_NAMES.put("2.5.29.54", "Inhibit Any-Policy");
        EXT_OID_NAMES.put("1.3.6.1.5.5.7.1.11", "Subject Info Access");
        EXT_OID_NAMES.put("2.5.29.16", "Private Key Usage Period");
        EXT_OID_NAMES.put("2.5.29.46", "Freshest CRL");
    }

    /**
     * Get parsed X.509 extension details for display
     */
    public List<Map<String, Object>> getX509ExtensionDetails(X509Certificate x509) {
        List<Map<String, Object>> result = new ArrayList<>();
        java.util.Set<String> allOids = new java.util.HashSet<>();
        if (x509.getCriticalExtensionOIDs() != null) {
            allOids.addAll(x509.getCriticalExtensionOIDs());
        }
        if (x509.getNonCriticalExtensionOIDs() != null) {
            allOids.addAll(x509.getNonCriticalExtensionOIDs());
        }

        for (String oid : allOids) {
            Map<String, Object> ext = new HashMap<>();
            ext.put("oid", oid);
            ext.put("name", EXT_OID_NAMES.getOrDefault(oid, "Unknown"));
            ext.put("critical", x509.getCriticalExtensionOIDs() != null && x509.getCriticalExtensionOIDs().contains(oid));
            try {
                byte[] value = x509.getExtensionValue(oid);
                if (value != null) {
                    ext.put("valueHex", bytesToHex(value));
                    ext.put("valueBase64", Base64.getMimeEncoder(64, "\n".getBytes()).encodeToString(value));
                }
            } catch (Exception e) {
                ext.put("error", e.getMessage());
            }
            result.add(ext);
        }
        return result;
    }

    /**
     * Format a date for display
     */
    public static String formatDate(java.util.Date date) {
        if (date == null) return "N/A";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss z");
        return sdf.format(date);
    }

    /**
     * Get health dashboard statistics
     * @return map with valid, expiring, expired, weak counts
     */
    public Map<String, Object> getHealthDashboard() throws Exception {
        Map<String, Object> health = new HashMap<>();
        int valid = 0, expiring = 0, expired = 0, weak = 0;
        long now = System.currentTimeMillis();
        long thirtyDays = 30L * 24 * 60 * 60 * 1000;

        Enumeration<String> enumeration = keyStore.aliases();
        while (enumeration.hasMoreElements()) {
            String alias = enumeration.nextElement();
            Certificate cert = keyStore.getCertificate(alias);

            if (cert instanceof X509Certificate) {
                X509Certificate x509 = (X509Certificate) cert;
                Date notAfter = x509.getNotAfter();
                long daysUntilExpiry = (notAfter.getTime() - now) / (1000 * 60 * 60 * 24);

                if (daysUntilExpiry < 0) {
                    expired++;
                } else if (daysUntilExpiry < 30) {
                    expiring++;
                } else {
                    valid++;
                }

                // Check for weak keys
                List<String> warnings = analyzeSecurityWarnings(x509);
                if (!warnings.isEmpty()) {
                    weak++;
                }
            }
        }

        health.put("valid", valid);
        health.put("expiring", expiring);
        health.put("expired", expired);
        health.put("weak", weak);
        health.put("total", valid + expiring + expired);

        return health;
    }

    /**
     * Analyze certificate for security warnings
     */
    public List<String> analyzeSecurityWarnings(X509Certificate x509) {
        List<String> warnings = new ArrayList<>();

        // Check key size
        if (x509.getPublicKey() instanceof RSAPublicKey) {
            RSAPublicKey rsaKey = (RSAPublicKey) x509.getPublicKey();
            int keySize = rsaKey.getModulus().bitLength();
            if (keySize < 2048) {
                warnings.add("Weak RSA key: " + keySize + " bits (recommend 2048+)");
            }
        } else if (x509.getPublicKey() instanceof ECPublicKey) {
            ECPublicKey ecKey = (ECPublicKey) x509.getPublicKey();
            int keySize = ecKey.getParams().getCurve().getField().getFieldSize();
            if (keySize < 256) {
                warnings.add("Weak EC key: " + keySize + " bits (recommend 256+)");
            }
        } else if (x509.getPublicKey() instanceof DSAPublicKey) {
            warnings.add("DSA keys are deprecated, consider RSA or EC");
        }

        // Check signature algorithm
        String sigAlg = x509.getSigAlgName().toUpperCase();
        if (sigAlg.contains("MD5")) {
            warnings.add("MD5 signature algorithm is broken");
        } else if (sigAlg.contains("SHA1") || sigAlg.contains("SHA-1")) {
            warnings.add("SHA-1 signature algorithm is deprecated");
        }

        // Check self-signed
        try {
            x509.verify(x509.getPublicKey());
            if (!x509.getSubjectDN().equals(x509.getIssuerDN())) {
                // Not really self-signed but verifies with own key
            } else {
                warnings.add("Self-signed certificate");
            }
        } catch (Exception e) {
            // Not self-signed, which is fine
        }

        // Check basic constraints for CA
        if (x509.getBasicConstraints() >= 0) {
            // It's a CA certificate - check if it's being used as end-entity
        }

        return warnings;
    }

    /**
     * Get detailed security analysis for an alias
     */
    public Map<String, Object> getSecurityAnalysis(String alias) throws Exception {
        Map<String, Object> analysis = new HashMap<>();
        Certificate cert = keyStore.getCertificate(alias);

        if (!(cert instanceof X509Certificate)) {
            analysis.put("error", "Not an X509 certificate");
            return analysis;
        }

        X509Certificate x509 = (X509Certificate) cert;

        // Warnings
        List<String> warnings = analyzeSecurityWarnings(x509);
        analysis.put("warnings", warnings);
        analysis.put("hasWarnings", !warnings.isEmpty());

        // Key info
        String keyAlg = x509.getPublicKey().getAlgorithm();
        analysis.put("keyAlgorithm", keyAlg);

        if (x509.getPublicKey() instanceof RSAPublicKey) {
            RSAPublicKey rsaKey = (RSAPublicKey) x509.getPublicKey();
            analysis.put("keySize", rsaKey.getModulus().bitLength());
            analysis.put("keyStrength", rsaKey.getModulus().bitLength() >= 2048 ? "strong" : "weak");
        } else if (x509.getPublicKey() instanceof ECPublicKey) {
            ECPublicKey ecKey = (ECPublicKey) x509.getPublicKey();
            analysis.put("keySize", ecKey.getParams().getCurve().getField().getFieldSize());
            analysis.put("keyStrength", "strong");
        }

        // Signature analysis
        String sigAlg = x509.getSigAlgName();
        analysis.put("signatureAlgorithm", sigAlg);
        if (sigAlg.toUpperCase().contains("SHA256") || sigAlg.toUpperCase().contains("SHA384") || sigAlg.toUpperCase().contains("SHA512")) {
            analysis.put("signatureStrength", "strong");
        } else if (sigAlg.toUpperCase().contains("SHA1")) {
            analysis.put("signatureStrength", "weak");
        } else if (sigAlg.toUpperCase().contains("MD5")) {
            analysis.put("signatureStrength", "broken");
        } else {
            analysis.put("signatureStrength", "unknown");
        }

        // Self-signed check
        try {
            x509.verify(x509.getPublicKey());
            analysis.put("selfSigned", true);
        } catch (Exception e) {
            analysis.put("selfSigned", false);
        }

        // CA check
        analysis.put("isCA", x509.getBasicConstraints() >= 0);

        return analysis;
    }

    /**
     * Import a PEM certificate into the keystore
     * @param overwrite if true, replace existing alias; if false, throw if exists
     */
    public byte[] importCertificate(String pemCert, String alias, boolean overwrite) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Password is required to import certificate");
        }

        String base64 = pemCert
                .replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s", "");
        byte[] certBytes = Base64.getDecoder().decode(base64);
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(certBytes));

        if (keyStore.containsAlias(alias)) {
            if (!overwrite) throw new Exception("Alias '" + alias + "' already exists");
            keyStore.deleteEntry(alias);
        }
        keyStore.setCertificateEntry(alias, cert);
        return exportKeyStore();
    }

    /**
     * Remove a certificate from a key entry's chain (e.g. remove intermediate)
     * @param alias the key pair alias
     * @param index 0=leaf, 1=first intermediate, etc. Must keep at least leaf (index 0)
     * @return updated keystore bytes
     */
    public byte[] removeFromChain(String alias, int index) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Please provide the KeyStore password");
        }
        if (!keyStore.isKeyEntry(alias)) {
            throw new Exception("Alias '" + alias + "' is not a key entry");
        }

        Certificate[] chain = keyStore.getCertificateChain(alias);
        if (chain == null || chain.length <= 1) {
            throw new Exception("Chain has only one certificate - cannot remove");
        }
        if (index < 0 || index >= chain.length) {
            throw new Exception("Invalid index. Chain has " + chain.length + " certificates (0-" + (chain.length - 1) + ")");
        }

        Certificate[] newChain = new Certificate[chain.length - 1];
        for (int i = 0, j = 0; i < chain.length; i++) {
            if (i != index) newChain[j++] = chain[i];
        }

        Key key = keyStore.getKey(alias, password.toCharArray());
        keyStore.setKeyEntry(alias, key, password.toCharArray(), newChain);
        return exportKeyStore();
    }

    /**
     * Compare two certificates (by alias) and return field-by-field differences
     */
    public Map<String, Object> compareCertificates(String alias1, String alias2) throws Exception {
        Certificate c1 = keyStore.getCertificate(alias1);
        Certificate c2 = keyStore.getCertificate(alias2);
        if (c1 == null || !(c1 instanceof X509Certificate)) {
            throw new Exception("No X509 certificate for alias: " + alias1);
        }
        if (c2 == null || !(c2 instanceof X509Certificate)) {
            throw new Exception("No X509 certificate for alias: " + alias2);
        }

        X509Certificate x1 = (X509Certificate) c1;
        X509Certificate x2 = (X509Certificate) c2;

        Map<String, Object> result = new HashMap<>();
        result.put("alias1", alias1);
        result.put("alias2", alias2);
        List<Map<String, Object>> differences = new ArrayList<>();
        List<Map<String, Object>> same = new ArrayList<>();

        compareField("subject", x1.getSubjectDN().toString(), x2.getSubjectDN().toString(), differences, same);
        compareField("issuer", x1.getIssuerDN().toString(), x2.getIssuerDN().toString(), differences, same);
        compareField("serialNumber", x1.getSerialNumber().toString(), x2.getSerialNumber().toString(), differences, same);
        compareField("signatureAlgorithm", x1.getSigAlgName(), x2.getSigAlgName(), differences, same);
        compareField("notBefore", formatDate(x1.getNotBefore()), formatDate(x2.getNotBefore()), differences, same);
        compareField("notAfter", formatDate(x1.getNotAfter()), formatDate(x2.getNotAfter()), differences, same);
        compareField("version", String.valueOf(x1.getVersion()), String.valueOf(x2.getVersion()), differences, same);
        if (x1.getPublicKey() != null && x2.getPublicKey() != null) {
            compareField("publicKeyAlgorithm", x1.getPublicKey().getAlgorithm(), x2.getPublicKey().getAlgorithm(), differences, same);
        }
        Map<String, String> fp1 = getFingerprintsForCert(x1);
        Map<String, String> fp2 = getFingerprintsForCert(x2);
        for (String alg : new String[]{"SHA-256", "SHA-1"}) {
            if (fp1.containsKey(alg) && fp2.containsKey(alg)) {
                compareField("fingerprint." + alg, fp1.get(alg), fp2.get(alg), differences, same);
            }
        }
        result.put("identical", differences.isEmpty());
        result.put("differences", differences);
        result.put("same", same);
        return result;
    }

    private void compareField(String name, String v1, String v2, List<Map<String, Object>> diff, List<Map<String, Object>> same) {
        Map<String, Object> m = new HashMap<>();
        m.put("field", name);
        m.put("value1", v1);
        m.put("value2", v2);
        if ((v1 == null && v2 == null) || (v1 != null && v1.equals(v2))) {
            same.add(m);
        } else {
            diff.add(m);
        }
    }

    /**
     * Detect format of pasted PEM/Base64 data (certificate, private key, etc.)
     * @param pasted the pasted text
     * @return map with format, description, and optionally parsed info
     */
    public static Map<String, Object> detectPastedFormat(String pasted) {
        Map<String, Object> result = new HashMap<>();
        String trimmed = pasted.trim();

        if (trimmed.contains("-----BEGIN CERTIFICATE-----")) {
            result.put("format", "X509_PEM");
            result.put("description", "X.509 Certificate (PEM)");
            try {
                String base64 = trimmed.replace("-----BEGIN CERTIFICATE-----", "")
                        .replace("-----END CERTIFICATE-----", "").replaceAll("\\s", "");
                byte[] der = Base64.getDecoder().decode(base64);
                CertificateFactory cf = CertificateFactory.getInstance("X.509");
                X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(der));
                result.put("subject", cert.getSubjectDN().toString());
                result.put("issuer", cert.getIssuerDN().toString());
                result.put("notAfter", formatDate(cert.getNotAfter()));
            } catch (Exception e) {
                result.put("parseError", e.getMessage());
            }
            return result;
        }
        if (trimmed.contains("-----BEGIN PRIVATE KEY-----")) {
            result.put("format", "PKCS8_PEM");
            result.put("description", "Private Key (PKCS#8 PEM)");
            return result;
        }
        if (trimmed.contains("-----BEGIN RSA PRIVATE KEY-----")) {
            result.put("format", "RSA_PEM");
            result.put("description", "RSA Private Key (Traditional PEM)");
            return result;
        }
        if (trimmed.contains("-----BEGIN EC PRIVATE KEY-----")) {
            result.put("format", "EC_PEM");
            result.put("description", "EC Private Key (PEM)");
            return result;
        }
        if (trimmed.contains("-----BEGIN PKCS7-----") || trimmed.contains("-----BEGIN CMS-----")) {
            result.put("format", "PKCS7_PEM");
            result.put("description", "PKCS#7 / CMS (Certificate chain)");
            return result;
        }
        if (trimmed.contains("-----BEGIN CERTIFICATE REQUEST-----")) {
            result.put("format", "CSR_PEM");
            result.put("description", "Certificate Signing Request (PKCS#10)");
            return result;
        }
        if (trimmed.matches("^[A-Za-z0-9+/=\\s\\n]+$") && trimmed.length() > 50) {
            result.put("format", "BASE64_UNKNOWN");
            result.put("description", "Base64 data (unknown format - could be DER certificate)");
            try {
                byte[] der = Base64.getDecoder().decode(trimmed.replaceAll("\\s", ""));
                if (der.length > 0 && der[0] == 0x30) {
                    CertificateFactory cf = CertificateFactory.getInstance("X.509");
                    X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(der));
                    result.put("format", "X509_DER_B64");
                    result.put("description", "X.509 Certificate (Base64 DER)");
                    result.put("subject", cert.getSubjectDN().toString());
                }
            } catch (Exception e) { /* ignore */ }
            return result;
        }

        result.put("format", "UNKNOWN");
        result.put("description", "Unknown format");
        return result;
    }

    /**
     * Fetch certificates from a remote SSL/TLS server
     */
    public static List<Map<String, Object>> fetchRemoteCertificates(String host, int port) throws Exception {
        List<Map<String, Object>> certs = new ArrayList<>();

        SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();
        try (SSLSocket socket = (SSLSocket) factory.createSocket(host, port)) {
            socket.setSoTimeout(10000);
            socket.startHandshake();

            SSLSession session = socket.getSession();
            Certificate[] chain = session.getPeerCertificates();

            for (int i = 0; i < chain.length; i++) {
                if (chain[i] instanceof X509Certificate) {
                    X509Certificate x509 = (X509Certificate) chain[i];
                    Map<String, Object> certInfo = new HashMap<>();

                    certInfo.put("index", i);
                    certInfo.put("subject", x509.getSubjectDN().toString());
                    certInfo.put("issuer", x509.getIssuerDN().toString());
                    certInfo.put("serialNumber", x509.getSerialNumber().toString());
                    certInfo.put("notBefore", formatDate(x509.getNotBefore()));
                    certInfo.put("notAfter", formatDate(x509.getNotAfter()));
                    certInfo.put("signatureAlgorithm", x509.getSigAlgName());

                    // Check validity
                    long now = System.currentTimeMillis();
                    long daysUntilExpiry = (x509.getNotAfter().getTime() - now) / (1000 * 60 * 60 * 24);
                    certInfo.put("daysUntilExpiry", daysUntilExpiry);

                    if (daysUntilExpiry < 0) {
                        certInfo.put("status", "expired");
                    } else if (daysUntilExpiry < 30) {
                        certInfo.put("status", "expiring");
                    } else {
                        certInfo.put("status", "valid");
                    }

                    // Determine type
                    if (i == 0) {
                        certInfo.put("type", "End Entity");
                    } else if (x509.getBasicConstraints() >= 0) {
                        if (x509.getSubjectDN().equals(x509.getIssuerDN())) {
                            certInfo.put("type", "Root CA");
                        } else {
                            certInfo.put("type", "Intermediate CA");
                        }
                    } else {
                        certInfo.put("type", "Certificate");
                    }

                    // PEM export
                    StringBuilder pem = new StringBuilder();
                    pem.append("-----BEGIN CERTIFICATE-----\n");
                    pem.append(Base64.getMimeEncoder(64, "\n".getBytes()).encodeToString(x509.getEncoded()));
                    pem.append("\n-----END CERTIFICATE-----");
                    certInfo.put("pem", pem.toString());

                    certs.add(certInfo);
                }
            }
        }

        return certs;
    }

    /**
     * Get expiry timeline data for all certificates
     */
    public List<Map<String, Object>> getExpiryTimeline() throws Exception {
        List<Map<String, Object>> timeline = new ArrayList<>();
        long now = System.currentTimeMillis();

        Enumeration<String> enumeration = keyStore.aliases();
        while (enumeration.hasMoreElements()) {
            String alias = enumeration.nextElement();
            Certificate cert = keyStore.getCertificate(alias);

            if (cert instanceof X509Certificate) {
                X509Certificate x509 = (X509Certificate) cert;
                Map<String, Object> entry = new HashMap<>();

                entry.put("alias", alias);
                entry.put("notBefore", x509.getNotBefore().getTime());
                entry.put("notAfter", x509.getNotAfter().getTime());

                long daysUntilExpiry = (x509.getNotAfter().getTime() - now) / (1000 * 60 * 60 * 24);
                entry.put("daysUntilExpiry", daysUntilExpiry);

                if (daysUntilExpiry < 0) {
                    entry.put("status", "expired");
                } else if (daysUntilExpiry < 30) {
                    entry.put("status", "expiring");
                } else {
                    entry.put("status", "valid");
                }

                timeline.add(entry);
            }
        }

        // Sort by expiry date
        timeline.sort((a, b) -> Long.compare((Long) a.get("notAfter"), (Long) b.get("notAfter")));

        return timeline;
    }

    // ============ NEW FEATURES: Create, Detect, Validate, Order, Generate ============

    /**
     * Create a new empty keystore of the given type
     * @param type JKS, PKCS12, or JCEKS
     * @param password the keystore password
     * @return keystore bytes
     */
    public static byte[] createEmptyKeystore(String type, String password) throws Exception {
        if (type == null || type.isEmpty()) type = "JKS";
        type = type.toUpperCase();
        if (!type.equals("JKS") && !type.equals("PKCS12") && !type.equals("JCEKS")) {
            throw new Exception("Unsupported keystore type: " + type + ". Supported: JKS, PKCS12, JCEKS");
        }
        if (password == null || password.isEmpty()) {
            throw new Exception("Password is required to create a keystore");
        }
        KeyStore ks = KeyStore.getInstance(type);
        ks.load(null, null);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ks.store(baos, password.toCharArray());
        return baos.toByteArray();
    }

    /**
     * Detect keystore type by examining magic bytes
     * @param data raw keystore bytes
     * @return map with detectedType, confidence, magicBytes
     */
    public static Map<String, Object> detectKeystoreType(byte[] data) {
        Map<String, Object> result = new HashMap<>();
        if (data == null || data.length < 4) {
            result.put("detectedType", "UNKNOWN");
            result.put("confidence", "low");
            result.put("magicBytes", "");
            result.put("error", "Data too short to detect type");
            return result;
        }

        String hex = String.format("%02X%02X%02X%02X", data[0], data[1], data[2], data[3]);
        result.put("magicBytes", "0x" + hex);

        // JKS magic: 0xFEEDFEED
        if (data[0] == (byte) 0xFE && data[1] == (byte) 0xED
                && data[2] == (byte) 0xFE && data[3] == (byte) 0xED) {
            result.put("detectedType", "JKS");
            result.put("confidence", "high");
            return result;
        }

        // JCEKS magic: 0xCECECECE
        if (data[0] == (byte) 0xCE && data[1] == (byte) 0xCE
                && data[2] == (byte) 0xCE && data[3] == (byte) 0xCE) {
            result.put("detectedType", "JCEKS");
            result.put("confidence", "high");
            return result;
        }

        // PKCS12: ASN.1 SEQUENCE starting with 0x30
        if (data[0] == 0x30) {
            result.put("detectedType", "PKCS12");
            result.put("confidence", "medium");
            return result;
        }

        result.put("detectedType", "UNKNOWN");
        result.put("confidence", "low");
        return result;
    }

    /**
     * Validate that a private key matches its certificate's public key
     * @param alias the key entry alias
     * @return map with valid, algorithm, keySize, error
     */
    public Map<String, Object> validateKeyPair(String alias) throws Exception {
        Map<String, Object> result = new HashMap<>();

        if (!keyStore.containsAlias(alias)) {
            result.put("valid", false);
            result.put("error", "Alias '" + alias + "' not found");
            return result;
        }
        if (!keyStore.isKeyEntry(alias)) {
            result.put("valid", false);
            result.put("error", "Alias '" + alias + "' is not a key entry (no private key)");
            return result;
        }

        Key key = keyStore.getKey(alias, password != null ? password.toCharArray() : null);
        if (!(key instanceof PrivateKey)) {
            result.put("valid", false);
            result.put("error", "Could not retrieve private key (wrong password?)");
            return result;
        }
        PrivateKey privateKey = (PrivateKey) key;

        Certificate cert = keyStore.getCertificate(alias);
        if (cert == null) {
            result.put("valid", false);
            result.put("error", "No certificate found for alias");
            return result;
        }
        PublicKey publicKey = cert.getPublicKey();
        String keyAlg = publicKey.getAlgorithm();
        result.put("algorithm", keyAlg);

        // Determine key size
        if (publicKey instanceof RSAPublicKey) {
            result.put("keySize", ((RSAPublicKey) publicKey).getModulus().bitLength());
        } else if (publicKey instanceof ECPublicKey) {
            result.put("keySize", ((ECPublicKey) publicKey).getParams().getCurve().getField().getFieldSize());
        } else if (publicKey instanceof DSAPublicKey) {
            result.put("keySize", ((DSAPublicKey) publicKey).getParams().getP().bitLength());
        }

        // Pick signature algorithm
        String sigAlg;
        switch (keyAlg) {
            case "RSA": sigAlg = "SHA256withRSA"; break;
            case "EC": sigAlg = "SHA256withECDSA"; break;
            case "DSA": sigAlg = "SHA256withDSA"; break;
            default: sigAlg = "SHA256with" + keyAlg;
        }

        try {
            byte[] challenge = new byte[32];
            new SecureRandom().nextBytes(challenge);

            Signature signer = Signature.getInstance(sigAlg);
            signer.initSign(privateKey);
            signer.update(challenge);
            byte[] signature = signer.sign();

            Signature verifier = Signature.getInstance(sigAlg);
            verifier.initVerify(publicKey);
            verifier.update(challenge);
            boolean valid = verifier.verify(signature);

            result.put("valid", valid);
            if (!valid) {
                result.put("error", "Signature verification failed — private key does not match certificate");
            }
        } catch (Exception e) {
            result.put("valid", false);
            result.put("error", "Validation failed: " + e.getMessage());
        }

        return result;
    }

    /**
     * Reorder the certificate chain for a key entry: leaf first, root last
     * Orders by matching Subject ↔ Issuer using X500Principal
     * @param alias the key entry alias
     * @return updated keystore bytes with reordered chain
     */
    public byte[] orderCertificateChain(String alias) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Password is required to reorder chain");
        }
        if (!keyStore.isKeyEntry(alias)) {
            throw new Exception("Alias '" + alias + "' is not a key entry");
        }

        Certificate[] chain = keyStore.getCertificateChain(alias);
        if (chain == null || chain.length <= 1) {
            return exportKeyStore(); // nothing to reorder
        }

        // Cast to X509
        X509Certificate[] x509Chain = new X509Certificate[chain.length];
        for (int i = 0; i < chain.length; i++) {
            if (!(chain[i] instanceof X509Certificate)) {
                throw new Exception("Certificate at index " + i + " is not X509");
            }
            x509Chain[i] = (X509Certificate) chain[i];
        }

        // Find the leaf: the cert whose subject is NOT the issuer of any other cert,
        // OR whose issuer matches another cert's subject (i.e., it's signed by someone in the chain)
        // Simplest approach: find the cert that is not an issuer to anyone else
        X509Certificate leaf = null;
        for (X509Certificate candidate : x509Chain) {
            boolean isIssuerOfAnother = false;
            for (X509Certificate other : x509Chain) {
                if (candidate == other) continue;
                if (candidate.getSubjectX500Principal().equals(other.getIssuerX500Principal())) {
                    // candidate signed 'other', so candidate is NOT the leaf
                    isIssuerOfAnother = true;
                    break;
                }
            }
            if (!isIssuerOfAnother) {
                leaf = candidate;
                break;
            }
        }
        if (leaf == null) {
            leaf = x509Chain[0]; // fallback
        }

        // Build ordered chain: leaf -> intermediate(s) -> root
        List<X509Certificate> ordered = new ArrayList<>();
        ordered.add(leaf);
        java.util.Set<X509Certificate> used = new java.util.HashSet<>();
        used.add(leaf);

        X509Certificate current = leaf;
        while (ordered.size() < x509Chain.length) {
            X509Certificate issuer = null;
            for (X509Certificate candidate : x509Chain) {
                if (used.contains(candidate)) continue;
                if (current.getIssuerX500Principal().equals(candidate.getSubjectX500Principal())) {
                    // Verify signature to confirm
                    try {
                        current.verify(candidate.getPublicKey());
                        issuer = candidate;
                        break;
                    } catch (Exception e) {
                        // signature doesn't match, keep looking
                    }
                }
            }
            if (issuer == null) {
                // Add remaining certs in original order
                for (X509Certificate c : x509Chain) {
                    if (!used.contains(c)) {
                        ordered.add(c);
                        used.add(c);
                    }
                }
                break;
            }
            ordered.add(issuer);
            used.add(issuer);
            current = issuer;
        }

        // Store reordered chain
        Key key = keyStore.getKey(alias, password.toCharArray());
        keyStore.setKeyEntry(alias, key, password.toCharArray(), ordered.toArray(new Certificate[0]));
        return exportKeyStore();
    }

    /**
     * Generate a new key pair (RSA/DSA/EC) with a self-signed certificate
     * @param alias alias for the new key entry
     * @param keyAlg RSA, DSA, or EC
     * @param keySize key size (2048, 4096 for RSA/DSA; 256, 384, 521 for EC)
     * @param cn Common Name for the self-signed cert (e.g. "localhost")
     * @param validityDays number of days the cert is valid
     * @param keyPassword password for the private key
     * @return updated keystore bytes
     */
    public byte[] generateKeyPair(String alias, String keyAlg, int keySize,
            String cn, int validityDays, String keyPassword) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Keystore password is required");
        }
        if (alias == null || alias.isEmpty()) {
            throw new Exception("Alias is required");
        }
        if (keyStore.containsAlias(alias)) {
            throw new Exception("Alias '" + alias + "' already exists");
        }
        if (cn == null || cn.isEmpty()) cn = alias;
        if (validityDays <= 0) validityDays = 365;
        if (keyPassword == null || keyPassword.isEmpty()) keyPassword = password;

        keyAlg = keyAlg.toUpperCase();
        KeyPairGenerator kpg = KeyPairGenerator.getInstance(keyAlg);

        if ("EC".equals(keyAlg)) {
            String curveName;
            switch (keySize) {
                case 384: curveName = "secp384r1"; break;
                case 521: curveName = "secp521r1"; break;
                default: curveName = "secp256r1"; keySize = 256; break;
            }
            kpg.initialize(new ECGenParameterSpec(curveName), new SecureRandom());
        } else {
            if ("RSA".equals(keyAlg) && keySize < 1024) keySize = 2048;
            if ("DSA".equals(keyAlg) && keySize < 512) keySize = 2048;
            kpg.initialize(keySize, new SecureRandom());
        }

        KeyPair keyPair = kpg.generateKeyPair();

        // Determine signature algorithm
        String sigAlg;
        switch (keyAlg) {
            case "RSA": sigAlg = "SHA256withRSA"; break;
            case "EC": sigAlg = "SHA256withECDSA"; break;
            case "DSA": sigAlg = "SHA256withDSA"; break;
            default: throw new Exception("Unsupported key algorithm: " + keyAlg);
        }

        // Generate self-signed certificate using sun.security.x509 internal API
        // This is the same approach used by keytool in the JDK
        X509Certificate selfSignedCert = generateSelfSignedCert(
                keyPair, cn, sigAlg, validityDays);

        keyStore.setKeyEntry(alias, keyPair.getPrivate(), keyPassword.toCharArray(),
                new Certificate[]{selfSignedCert});
        return exportKeyStore();
    }

    /**
     * Generate a self-signed X509 certificate using sun.security.x509 internal API
     */
    @SuppressWarnings("deprecation")
    private X509Certificate generateSelfSignedCert(KeyPair keyPair, String cn,
            String sigAlg, int validityDays) throws Exception {
        // Use sun.security.x509 internal API (same as keytool)
        sun.security.x509.X500Name x500Name = new sun.security.x509.X500Name("CN=" + cn);
        Date notBefore = new Date();
        Date notAfter = new Date(notBefore.getTime() + (long) validityDays * 86400000L);
        BigInteger serialNumber = new BigInteger(64, new SecureRandom());

        sun.security.x509.CertificateValidity validity =
                new sun.security.x509.CertificateValidity(notBefore, notAfter);

        sun.security.x509.X509CertInfo info = new sun.security.x509.X509CertInfo();
        info.set(sun.security.x509.X509CertInfo.VALIDITY, validity);
        info.set(sun.security.x509.X509CertInfo.SERIAL_NUMBER,
                new sun.security.x509.CertificateSerialNumber(serialNumber));
        info.set(sun.security.x509.X509CertInfo.SUBJECT, x500Name);
        info.set(sun.security.x509.X509CertInfo.ISSUER, x500Name);
        info.set(sun.security.x509.X509CertInfo.KEY,
                new sun.security.x509.CertificateX509Key(keyPair.getPublic()));
        info.set(sun.security.x509.X509CertInfo.VERSION,
                new sun.security.x509.CertificateVersion(sun.security.x509.CertificateVersion.V3));

        sun.security.x509.AlgorithmId algId = sun.security.x509.AlgorithmId.get(sigAlg);
        info.set(sun.security.x509.X509CertInfo.ALGORITHM_ID,
                new sun.security.x509.CertificateAlgorithmId(algId));

        // Sign the certificate
        sun.security.x509.X509CertImpl cert = new sun.security.x509.X509CertImpl(info);
        cert.sign(keyPair.getPrivate(), sigAlg);

        return cert;
    }

    /**
     * Get EC curve name from key size
     */
    private static String getECCurveName(int fieldSize) {
        switch (fieldSize) {
            case 256: return "secp256r1 (P-256)";
            case 384: return "secp384r1 (P-384)";
            case 521: case 520: return "secp521r1 (P-521)";
            default: return "unknown (" + fieldSize + "-bit)";
        }
    }

    /**
     * Get the underlying keystore
     */
    public KeyStore getKeyStore() {
        return keyStore;
    }
}
