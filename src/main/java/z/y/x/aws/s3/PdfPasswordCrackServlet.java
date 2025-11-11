package z.y.x.aws.s3;

import z.y.x.Security.SendEmail;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Handles PDF password cracking submissions by generating S3 pre-signed URLs and
 * persisting metadata for the cracking queue.
 */
public class PdfPasswordCrackServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String BUCKET_NAME = "pdf-7be8c87f";
    private static final long MAX_FILE_SIZE_BYTES = 100L * 1024 * 1024; // 100 MB
    private static final SecureRandom RANDOM = new SecureRandom();

    private final S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
    private final PdfPasswordCrackRepository repository = new PdfPasswordCrackRepository();
    private final SendEmail sendEmail = new SendEmail();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");

        if ("presign".equalsIgnoreCase(action)) {
            handlePresign(request, response);
        } else if ("submit".equalsIgnoreCase(action)) {
            handleSubmit(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter writer = response.getWriter()) {
                writer.print("{\"error\":\"Unsupported action\"}");
            }
        }
    }

    private void handlePresign(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String originalFileName = valueOrEmpty(request.getParameter("fileName"));
        String contentType = valueOrEmpty(request.getParameter("contentType"));
        String fileSizeParam = valueOrEmpty(request.getParameter("fileSize"));

        if (originalFileName.isEmpty()) {
            writeError(response, "Missing file name");
            return;
        }

        if (!isPdfExtension(originalFileName)) {
            writeError(response, "File extension must be .pdf");
            return;
        }

        if (contentType.isEmpty() || !"application/pdf".equalsIgnoreCase(contentType)) {
            writeError(response, "Invalid content type. Only application/pdf is allowed.");
            return;
        }

        long fileSize = parseFileSize(fileSizeParam);
        if (fileSize <= 0) {
            writeError(response, "Missing or invalid file size");
            return;
        }

        if (fileSize > MAX_FILE_SIZE_BYTES) {
            writeError(response, "File too large. Maximum supported size is 100 MB.");
            return;
        }

        String objectKey = generateObjectKey(originalFileName);

        Map<String, String> metadata = new HashMap<>();
        metadata.put("original-filename", truncate(originalFileName, 200));

        try {
            URL presignedUrl = presignedUrlGenerator.createPresignedUrl(BUCKET_NAME, objectKey, contentType, metadata);
            try (PrintWriter writer = response.getWriter()) {
                writer.print("{\"presignedUrl\":\"" + presignedUrl + "\",\"objectKey\":\"" + objectKey + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(response, "Unable to create upload URL");
        }
    }

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = valueOrEmpty(request.getParameter("email")).trim();
        String hintsParam = valueOrEmpty(request.getParameter("hints")).trim();
        String objectKey = valueOrEmpty(request.getParameter("objectKey")).trim();
        String originalFileName = valueOrEmpty(request.getParameter("originalFileName")).trim();
        long fileSize = parseFileSize(request.getParameter("fileSize"));

        if (objectKey.isEmpty()) {
            writeError(response, "Missing uploaded object key");
            return;
        }

        if (originalFileName.isEmpty()) {
            originalFileName = objectKey;
        }

        if (!isPdfExtension(originalFileName)) {
            writeError(response, "Original file must be a PDF");
            return;
        }

        if (!isValidEmail(email)) {
            writeError(response, "Please provide a valid email address");
            return;
        }

        if (hintsParam.isEmpty()) {
            writeError(response, "Please share at least one password hint");
            return;
        }

        long ticketId;
        try {
            ticketId = repository.saveSubmission(email, objectKey, originalFileName, hintsParam, BUCKET_NAME, fileSize);
        } catch (SQLException e) {
            e.printStackTrace();
            writeError(response, "Could not save submission, please try again later");
            return;
        }

        final String referenceCode = generateReferenceCode(ticketId);
        sendAcknowledgementEmailAsync(email, originalFileName, hintsParam, referenceCode);

        try (PrintWriter writer = response.getWriter()) {
            writer.print("{\"status\":\"OK\",\"reference\":\"" + referenceCode + "\"}");
        }
    }

    private void writeError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        try (PrintWriter writer = response.getWriter()) {
            writer.print("{\"error\":\"" + escapeJson(message) + "\"}");
        }
    }

    private static String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }

    private static boolean isPdfExtension(String fileName) {
        return fileName.toLowerCase(Locale.ENGLISH).endsWith(".pdf");
    }

    private static long parseFileSize(String fileSize) {
        if (fileSize == null || fileSize.trim().isEmpty()) {
            return -1L;
        }
        try {
            return Long.parseLong(fileSize.trim());
        } catch (NumberFormatException ex) {
            return -1L;
        }
    }

    private String generateObjectKey(String originalFileName) {
        String base = originalFileName;
        int dotIndex = base.lastIndexOf('.');
        if (dotIndex > 0) {
            base = base.substring(0, dotIndex);
        }

        base = Normalizer.normalize(base, Normalizer.Form.NFD)
                .replaceAll("[^\\p{ASCII}]", "")
                .replaceAll("[^a-zA-Z0-9\\-]+", "-")
                .replaceAll("^-+", "")
                .replaceAll("-+$", "")
                .toLowerCase(Locale.ENGLISH);

        if (base.isEmpty()) {
            base = "encrypted-pdf";
        }

        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String random = Integer.toHexString(RANDOM.nextInt(0xFFFFF));

        return "pdf-crack/" + timestamp + "-" + random + "-" + base + ".pdf";
    }

    private String generateReferenceCode(long ticketId) {
        if (ticketId <= 0) {
            return "PDFQ-" + Integer.toHexString(RANDOM.nextInt(0xFFFFFF));
        }
        return "PDFQ-" + ticketId;
    }

    private void sendAcknowledgementEmailAsync(String email,
                                               String originalFileName,
                                               String hints,
                                               String referenceCode) {
        if (!isValidEmail(email)) {
            return;
        }

        new Thread(() -> {
            try {
                String subject = "We received your PDF password cracking request (" + referenceCode + ")";
                StringBuilder messageBuilder = new StringBuilder();
                messageBuilder.append("<p>Hi,</p>");
                messageBuilder.append("<p>Thanks for submitting your PDF <strong>")
                        .append(escapeHtml(originalFileName))
                        .append("</strong> for password recovery.</p>");
                messageBuilder.append("<p>Your request reference is <strong>")
                        .append(referenceCode)
                        .append("</strong>. Our team will update you once we make progress.</p>");
                messageBuilder.append("<p><strong>Hints provided:</strong></p><ul>");
                String[] lines = hints.split("\\r?\\n");
                for (String line : lines) {
                    if (!line.trim().isEmpty()) {
                        messageBuilder.append("<li>")
                                .append(escapeHtml(line.trim()))
                                .append("</li>");
                    }
                }
                messageBuilder.append("</ul>");
//                messageBuilder.append("<p>You can reply to this email with any additional clues. " +
//                        "We will contact you as soon as we have an update.</p>");
                messageBuilder.append("<p>– 8gwifi.org PDF Recovery Team</p>");

                sendEmail.sendEmail(subject, messageBuilder.toString(), email, "crack-pdf-password.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

    private boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }

        if (sendEmail.isValidEmail(email)) {
            return true;
        }

        try {
            InternetAddress address = new InternetAddress(email);
            address.validate();
            return true;
        } catch (AddressException e) {
            return false;
        }
    }

    private static String truncate(String value, int maxLength) {
        if (value == null || value.length() <= maxLength) {
            return value;
        }
        return value.substring(0, maxLength);
    }

    private static String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}

