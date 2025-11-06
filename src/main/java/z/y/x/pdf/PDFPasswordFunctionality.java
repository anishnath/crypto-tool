package z.y.x.pdf;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.InvalidPasswordException;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.List;

/**
 * Servlet to Add/Remove password protection from PDF files using Apache PDFBox 3.x
 *
 * Request (multipart/form-data):
 *  - action: "add" or "remove"
 *  - password: required for add, required for remove (existing password)
 *  - ownerPassword: optional for add (defaults to same as password)
 *  - pdfFile: uploaded PDF file
 *
 * Response: application/pdf with Content-Disposition attachment on success,
 *           400 text/plain with error message on failure.
 */
public class PDFPasswordFunctionality extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!ServletFileUpload.isMultipartContent(request)) {
            badRequest(response, "Expected multipart/form-data request");
            return;
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletContext servletContext = this.getServletConfig().getServletContext();
        File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        ServletFileUpload upload = new ServletFileUpload(factory);

        String action = null;
        String password = null; // new password or current for remove
        String currentPassword = null; // for change/remove where needed
        String ownerPassword = null;
        FileItem pdfItem = null;
        String originalName = "document.pdf";

        try {
            List<FileItem> items = upload.parseRequest(request);
            Iterator<FileItem> iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = iter.next();
                if (item.isFormField()) {
                    String field = item.getFieldName();
                    String value = item.getString("UTF-8");
                    if ("action".equalsIgnoreCase(field)) action = value;
                    else if ("password".equalsIgnoreCase(field)) password = value;
                    else if ("currentPassword".equalsIgnoreCase(field)) currentPassword = value;
                    else if ("ownerPassword".equalsIgnoreCase(field)) ownerPassword = value;
                } else {
                    if ("pdfFile".equalsIgnoreCase(item.getFieldName()) || "upfile".equalsIgnoreCase(item.getFieldName())) {
                        pdfItem = item;
                        if (item.getName() != null && !item.getName().trim().isEmpty()) {
                            originalName = new File(item.getName()).getName();
                        }
                    }
                }
            }
        } catch (Exception e) {
            badRequest(response, "Failed to parse request: " + e.getMessage());
            return;
        }

        if (pdfItem == null || pdfItem.getSize() == 0) {
            badRequest(response, "Missing PDF file");
            return;
        }
        if (action == null || !("add".equalsIgnoreCase(action) || "remove".equalsIgnoreCase(action) || "change".equalsIgnoreCase(action))) {
            badRequest(response, "Invalid or missing action (use 'add', 'remove', or 'change')");
            return;
        }

        if ("add".equalsIgnoreCase(action)) {
            if (password == null || password.trim().isEmpty()) {
                badRequest(response, "Password required to add protection");
                return;
            }
            if (ownerPassword == null || ownerPassword.trim().isEmpty()) {
                ownerPassword = password;
            }
            try (InputStream in = pdfItem.getInputStream()) {
                byte[] inputBytes = IOUtils.toByteArray(in);
                ensureIsPdf(inputBytes);

                try (PDDocument document = Loader.loadPDF(inputBytes)) {
                    AccessPermission ap = new AccessPermission();
                    // Default: allow printing, disallow content extraction; customize if needed.
                    // ap.setCanExtractContent(true/false) ...

                    StandardProtectionPolicy spp = new StandardProtectionPolicy(ownerPassword, password, ap);
                    spp.setEncryptionKeyLength(128); // 128-bit AES
                    document.protect(spp);

                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    document.save(baos);
                    sendPdf(response, baos.toByteArray(), buildFileName(originalName, true));
                } catch (InvalidPasswordException ipe) {
                    badRequest(response, "Input PDF appears to be encrypted. Use 'change' or 'remove' with the current password.");
                }
            } catch (Exception e) {
                badRequest(response, "Failed to add password: " + e.getMessage());
            }
        } else if ("remove".equalsIgnoreCase(action)) { // remove
            if ((password == null || password.trim().isEmpty()) && (currentPassword == null || currentPassword.trim().isEmpty())) {
                badRequest(response, "Password required to remove protection");
                return;
            }
            try (InputStream in = pdfItem.getInputStream()) {
                byte[] inputBytes = IOUtils.toByteArray(in);
                ensureIsPdf(inputBytes);

                String removePwd = (currentPassword != null && !currentPassword.isEmpty()) ? currentPassword : password;
                try (PDDocument document = Loader.loadPDF(inputBytes, removePwd)) {
                    // Save without protection
                    document.setAllSecurityToBeRemoved(true);
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    document.save(baos);
                    sendPdf(response, baos.toByteArray(), buildFileName(originalName, false));
                } catch (InvalidPasswordException ipe) {
                    badRequest(response, "Incorrect password for encrypted PDF");
                }
            } catch (Exception e) {
                badRequest(response, "Failed to remove password: " + e.getMessage());
            }
        } else { // change
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                badRequest(response, "Current password required to change protection");
                return;
            }
            if (password == null || password.trim().isEmpty()) {
                badRequest(response, "New password required to change protection");
                return;
            }
            if (ownerPassword == null || ownerPassword.trim().isEmpty()) {
                ownerPassword = password;
            }
            try (InputStream in = pdfItem.getInputStream()) {
                byte[] inputBytes = IOUtils.toByteArray(in);
                ensureIsPdf(inputBytes);
                try (PDDocument document = Loader.loadPDF(inputBytes, currentPassword)) {
                    // remove old and apply new protection
                    document.setAllSecurityToBeRemoved(true);
                    AccessPermission ap = new AccessPermission();
                    StandardProtectionPolicy spp = new StandardProtectionPolicy(ownerPassword, password, ap);
                    spp.setEncryptionKeyLength(128);
                    document.protect(spp);
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    document.save(baos);
                    sendPdf(response, baos.toByteArray(), buildFileName(originalName, true));
                } catch (InvalidPasswordException ipe) {
                    badRequest(response, "Incorrect current password; cannot change protection");
                }
            } catch (Exception e) {
                badRequest(response, "Failed to change password: " + e.getMessage());
            }
        }
    }

    private void sendPdf(HttpServletResponse response, byte[] bytes, String filename) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/pdf");
        String safe = URLEncoder.encode(filename, StandardCharsets.UTF_8.name()).replace("+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + safe + "\"; filename*=UTF-8''" + safe);
        response.setContentLength(bytes.length);
        try (OutputStream os = response.getOutputStream()) {
            os.write(bytes);
        }
    }

    private void badRequest(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/plain; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.write(message);
        }
    }

    private void ensureIsPdf(byte[] data) throws IOException {
        if (data == null || data.length < 4) {
            throw new IOException("Invalid PDF file");
        }
        // PDF header starts with %PDF
        if (!(data[0] == '%' && data[1] == 'P' && data[2] == 'D' && data[3] == 'F')) {
            throw new IOException("Input is not a PDF");
        }
    }

    private String buildFileName(String original, boolean secured) {
        String base = original;
        int dot = original.lastIndexOf('.')
                ;
        if (dot > 0) base = original.substring(0, dot);
        return base + (secured ? "_protected.pdf" : "_unprotected.pdf");
    }
}
