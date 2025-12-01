package z.y.x.Security;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.security.Key;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPublicKey;
import java.security.interfaces.ECPublicKey;
import java.security.interfaces.DSAPublicKey;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.SSLSession;

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

            // Public key info
            if (x509.getPublicKey() != null) {
                details.put("publicKeyAlgorithm", x509.getPublicKey().getAlgorithm());
                details.put("publicKeyFormat", x509.getPublicKey().getFormat());
                details.put("publicKeyEncoded", bytesToHex(x509.getPublicKey().getEncoded()));
            }

            // Signature
            if (x509.getSignature() != null) {
                details.put("signature", bytesToHex(x509.getSignature()));
            }

            // Extensions
            if (x509.getCriticalExtensionOIDs() != null) {
                details.put("criticalExtensions", x509.getCriticalExtensionOIDs());
            }
            if (x509.getNonCriticalExtensionOIDs() != null) {
                details.put("nonCriticalExtensions", x509.getNonCriticalExtensionOIDs());
            }

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
     */
    public byte[] importCertificate(String pemCert, String alias) throws Exception {
        if (password == null || password.isEmpty()) {
            throw new Exception("Password is required to import certificate");
        }

        // Parse PEM
        String base64 = pemCert
                .replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s", "");

        byte[] certBytes = Base64.getDecoder().decode(base64);

        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(certBytes));

        // Check if alias already exists
        if (keyStore.containsAlias(alias)) {
            throw new Exception("Alias '" + alias + "' already exists");
        }

        // Add to keystore
        keyStore.setCertificateEntry(alias, cert);

        return exportKeyStore();
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

    /**
     * Get the underlying keystore
     */
    public KeyStore getKeyStore() {
        return keyStore;
    }
}
