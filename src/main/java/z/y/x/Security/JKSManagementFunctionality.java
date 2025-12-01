package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * JKS Management Servlet - Pure AJAX/JSON Implementation
 * No session storage, returns JSON responses
 *
 * @author Anish Nath
 */
public class JKSManagementFunctionality extends HttpServlet {

    private static final long serialVersionUID = 2920672111839687204L;
    private static final long MAX_FILE_SIZE = 10485760L; // 10MB
    private static final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss z")
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        sendJsonResponse(response, createErrorResponse("Use POST method"));
    }

    /**
     * Get keystore bytes from request - either from base64 keystoreData or file upload
     */
    private byte[] getKeystoreBytes(Map<String, Object> params) throws Exception {
        // First check for base64 encoded keystoreData (client-side storage)
        String keystoreData = (String) params.get("keystoreData");
        if (keystoreData != null && !keystoreData.isEmpty()) {
            return Base64.getDecoder().decode(keystoreData);
        }

        // Fallback to file upload bytes
        byte[] fileBytes = (byte[]) params.get("fileBytes");
        if (fileBytes != null && fileBytes.length > 0) {
            return fileBytes;
        }

        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Map<String, Object> params = parseMultipartRequest(request);
            String action = (String) params.get("action");

            if (action == null) {
                action = "upload"; // Default action
            }

            switch (action) {
                case "upload":
                    handleUpload(params, response);
                    break;
                case "getDetails":
                    handleGetDetails(params, response);
                    break;
                case "deleteAlias":
                    handleDeleteAlias(params, response);
                    break;
                case "exportPEM":
                    handleExportPEM(params, response);
                    break;
                case "exportKeyStore":
                    handleExportKeyStore(params, response);
                    break;
                case "getHealth":
                    handleGetHealth(params, response);
                    break;
                case "getTimeline":
                    handleGetTimeline(params, response);
                    break;
                case "fetchRemote":
                    handleFetchRemote(params, response);
                    break;
                case "importCert":
                    handleImportCert(params, response);
                    break;
                case "getSecurityAnalysis":
                    handleGetSecurityAnalysis(params, response);
                    break;
                default:
                    sendJsonResponse(response, createErrorResponse("Unknown action: " + action));
            }
        } catch (Exception e) {
            sendJsonResponse(response, createErrorResponse(e.getMessage()));
        }
    }

    private void handleUpload(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String password = (String) params.get("storepassword");
        String fileName = (String) params.get("fileName");
        if (fileName == null) fileName = (String) params.get("uploadFileName");

        if (keystoreBytes == null || keystoreBytes.length == 0) {
            sendJsonResponse(response, createErrorResponse("Please upload a keystore file"));
            return;
        }

        // Create JKS service and get info (no server-side caching)
        JKSService jksService = new JKSService(keystoreBytes, password);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("fileName", fileName);
        result.put("keystoreType", jksService.getKeyStoreType());
        result.put("aliasCount", jksService.getEntryCount());
        result.put("aliases", buildAliasesList(jksService));

        sendJsonResponse(response, result);
    }

    private void handleGetDetails(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String alias = (String) params.get("alias");
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (alias == null || alias.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please select an alias"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        Map<String, Object> details = jksService.getCertificateDetails(alias);

        // Add PEM export
        try {
            details.put("pemExport", jksService.exportCertificateAsPEM(alias));
        } catch (Exception e) {
            details.put("pemExport", null);
        }

        // Convert X509Certificate to serializable format
        X509Certificate x509 = (X509Certificate) details.remove("x509");
        if (x509 != null) {
            details.put("hasX509", true);
            details.put("version", x509.getVersion());
            details.put("subject", x509.getSubjectDN().toString());
            details.put("issuer", x509.getIssuerDN().toString());
            details.put("serialNumber", x509.getSerialNumber().toString());
            details.put("signatureAlgorithm", x509.getSigAlgName());
            details.put("notBefore", formatDate(x509.getNotBefore()));
            details.put("notAfter", formatDate(x509.getNotAfter()));
            details.put("notBeforeTimestamp", x509.getNotBefore().getTime());
            details.put("notAfterTimestamp", x509.getNotAfter().getTime());
            details.put("basicConstraints", x509.getBasicConstraints());

            if (x509.getPublicKey() != null) {
                details.put("publicKeyAlgorithm", x509.getPublicKey().getAlgorithm());
            }

            // Convert Sets to Lists for JSON serialization
            Set<String> criticalExts = x509.getCriticalExtensionOIDs();
            Set<String> nonCriticalExts = x509.getNonCriticalExtensionOIDs();
            details.put("criticalExtensions", criticalExts != null ? new ArrayList<>(criticalExts) : new ArrayList<>());
            details.put("nonCriticalExtensions", nonCriticalExts != null ? new ArrayList<>(nonCriticalExts) : new ArrayList<>());
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("alias", alias);
        result.put("details", details);

        sendJsonResponse(response, result);
    }

    private void handleDeleteAlias(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String alias = (String) params.get("alias");
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (alias == null || alias.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please select an alias to delete"));
            return;
        }

        if (password == null || password.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Password is required to delete an alias"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        byte[] updatedBytes = jksService.deleteAlias(alias);

        // Return updated keystore data to client (client-side storage)
        jksService = new JKSService(updatedBytes, password);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("message", "Alias '" + alias + "' deleted successfully");
        result.put("keystoreData", Base64.getEncoder().encodeToString(updatedBytes));
        result.put("aliasCount", jksService.getEntryCount());
        result.put("aliases", buildAliasesList(jksService));

        sendJsonResponse(response, result);
    }

    private void handleExportPEM(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String alias = (String) params.get("alias");
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (alias == null || alias.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please select an alias to export"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        String pemContent = jksService.exportCertificateChainAsPEM(alias);

        response.setContentType("application/x-pem-file");
        response.addHeader("Content-Disposition", "attachment; filename=" + alias + ".pem");
        ServletOutputStream os = response.getOutputStream();
        os.write(pemContent.getBytes(StandardCharsets.UTF_8));
        os.flush();
    }

    private void handleExportKeyStore(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (password == null || password.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Password is required to export keystore"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        byte[] exportBytes = jksService.exportKeyStore();

        response.setContentType("application/octet-stream");
        response.addHeader("Content-Disposition", "attachment; filename=keystore-export.jks");
        response.addHeader("Content-Length", String.valueOf(exportBytes.length));
        ServletOutputStream os = response.getOutputStream();
        os.write(exportBytes);
        os.flush();
    }

    private List<Map<String, Object>> buildAliasesList(JKSService jksService) throws Exception {
        List<Map<String, Object>> aliases = new ArrayList<>();
        long now = System.currentTimeMillis();

        for (Map<String, Object> summary : jksService.getAllAliasesSummary()) {
            Map<String, Object> aliasInfo = new LinkedHashMap<>();
            aliasInfo.put("name", summary.get("alias"));
            aliasInfo.put("isKeyEntry", summary.get("isKeyEntry"));
            aliasInfo.put("isCertEntry", summary.get("isCertEntry"));

            String subject = (String) summary.get("subject");
            if (subject != null) {
                aliasInfo.put("subject", subject.length() > 80 ? subject.substring(0, 80) + "..." : subject);
            }

            Date notAfter = (Date) summary.get("notAfter");
            if (notAfter != null) {
                aliasInfo.put("notAfter", formatDate(notAfter));
                aliasInfo.put("notAfterTimestamp", notAfter.getTime());

                long daysUntilExpiry = (notAfter.getTime() - now) / (1000 * 60 * 60 * 24);
                aliasInfo.put("daysUntilExpiry", daysUntilExpiry);

                if (daysUntilExpiry < 0) {
                    aliasInfo.put("status", "expired");
                } else if (daysUntilExpiry < 30) {
                    aliasInfo.put("status", "expiring");
                } else {
                    aliasInfo.put("status", "valid");
                }
            }

            aliases.add(aliasInfo);
        }

        return aliases;
    }

    private Map<String, Object> parseMultipartRequest(HttpServletRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();

        if (!ServletFileUpload.isMultipartContent(request)) {
            // Handle regular form data
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String name = paramNames.nextElement();
                params.put(name, request.getParameter(name));
            }
            return params;
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletContext servletContext = getServletConfig().getServletContext();
        File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);

        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(request);

        for (FileItem item : items) {
            if (!item.isFormField()) {
                if (item.getSize() > MAX_FILE_SIZE) {
                    throw new Exception("File size exceeds maximum allowed (10MB)");
                }
                if (item.getSize() > 0) {
                    params.put("fileBytes", item.get());
                    params.put("uploadFileName", item.getName());
                }
            } else {
                params.put(item.getFieldName(), item.getString());
            }
        }

        return params;
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", false);
        result.put("error", message);
        return result;
    }

    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("message", message);
        return result;
    }

    private String formatDate(Date date) {
        if (date == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss z");
        return sdf.format(date);
    }

    // ============ NEW FEATURE HANDLERS ============

    private void handleGetHealth(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        Map<String, Object> health = jksService.getHealthDashboard();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("health", health);

        sendJsonResponse(response, result);
    }

    private void handleGetTimeline(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        List<Map<String, Object>> timeline = jksService.getExpiryTimeline();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("timeline", timeline);

        sendJsonResponse(response, result);
    }

    private void handleFetchRemote(Map<String, Object> params, HttpServletResponse response) throws Exception {
        String url = (String) params.get("url");

        if (url == null || url.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please provide a URL"));
            return;
        }

        // Parse URL to get host and port
        String host;
        int port = 443;

        url = url.trim();
        if (url.startsWith("https://")) {
            url = url.substring(8);
        } else if (url.startsWith("http://")) {
            url = url.substring(7);
            port = 80;
        }

        // Remove path
        int slashIndex = url.indexOf('/');
        if (slashIndex > 0) {
            url = url.substring(0, slashIndex);
        }

        // Extract port if specified
        int colonIndex = url.indexOf(':');
        if (colonIndex > 0) {
            host = url.substring(0, colonIndex);
            port = Integer.parseInt(url.substring(colonIndex + 1));
        } else {
            host = url;
        }

        List<Map<String, Object>> certs = JKSService.fetchRemoteCertificates(host, port);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("host", host);
        result.put("port", port);
        result.put("certificates", certs);
        result.put("count", certs.size());

        sendJsonResponse(response, result);
    }

    private void handleImportCert(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String password = (String) params.get("storepassword");
        String pemCert = (String) params.get("pemCert");
        String alias = (String) params.get("alias");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (pemCert == null || pemCert.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please provide a PEM certificate"));
            return;
        }

        if (alias == null || alias.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please provide an alias name"));
            return;
        }

        if (password == null || password.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Password is required to import certificate"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        byte[] updatedBytes = jksService.importCertificate(pemCert, alias);

        // Return updated keystore data to client (client-side storage)
        jksService = new JKSService(updatedBytes, password);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("message", "Certificate imported successfully as '" + alias + "'");
        result.put("keystoreData", Base64.getEncoder().encodeToString(updatedBytes));
        result.put("aliasCount", jksService.getEntryCount());
        result.put("aliases", buildAliasesList(jksService));
        result.put("health", jksService.getHealthDashboard());

        sendJsonResponse(response, result);
    }

    private void handleGetSecurityAnalysis(Map<String, Object> params, HttpServletResponse response) throws Exception {
        byte[] keystoreBytes = getKeystoreBytes(params);
        String alias = (String) params.get("alias");
        String password = (String) params.get("storepassword");

        if (keystoreBytes == null) {
            sendJsonResponse(response, createErrorResponse("Keystore data not found. Please re-upload."));
            return;
        }

        if (alias == null || alias.isEmpty()) {
            sendJsonResponse(response, createErrorResponse("Please select an alias"));
            return;
        }

        JKSService jksService = new JKSService(keystoreBytes, password);
        Map<String, Object> analysis = jksService.getSecurityAnalysis(alias);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("alias", alias);
        result.put("analysis", analysis);

        sendJsonResponse(response, result);
    }
}
