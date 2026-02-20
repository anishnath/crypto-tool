package com.latexeditor.web.servlets;

import com.latexeditor.web.client.ApiClient;
import com.latexeditor.web.client.ApiException;
import com.latexeditor.web.client.ApiTimeoutException;
import com.latexeditor.web.client.ApiUnavailableException;
import com.latexeditor.web.model.UploadResponse;
import com.latexeditor.web.util.JsonUtil;
import org.apache.commons.io.IOUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * POST /upload
 * Accepts multipart/form-data, validates file, then forwards to Go API.
 */
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,       // 5 MB per file
    maxRequestSize = 5 * 1024 * 1024,
    fileSizeThreshold = 512 * 1024        // 512 KB
)
public class UploadProxyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Allowed file extensions for LaTeX documents
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
        "png", "jpg", "jpeg", "gif", "svg", "eps", "pdf",   // images
        "tex", "bib", "bst", "cls", "sty",                   // latex sources
        "csv", "dat", "txt"                                   // data files
    ));

    // Allowed MIME type prefixes
    private static final Set<String> ALLOWED_MIME_PREFIXES = new HashSet<>(Arrays.asList(
        "image/png", "image/jpeg", "image/gif", "image/svg+xml",
        "application/pdf", "application/postscript",          // eps
        "text/plain", "text/x-tex", "text/csv",
        "application/x-tex", "application/x-latex",
        "application/octet-stream"                            // fallback for .eps, .bib, etc.
    ));

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Part filePart;
        try {
            filePart = req.getPart("file");
        } catch (IllegalStateException e) {
            // File exceeds @MultipartConfig limits
            resp.setStatus(HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE);
            resp.getWriter().write("{\"error\":\"File too large. Maximum size is 5 MB.\"}");
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"No file provided\"}");
            return;
        }

        // ── Validate filename ──
        String filename = sanitizeFilename(getFileName(filePart));
        if (filename == null || filename.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid filename\"}");
            return;
        }

        // ── Validate extension ──
        String ext = getExtension(filename);
        if (ext == null || !ALLOWED_EXTENSIONS.contains(ext)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"File type not allowed. Accepted: "
                + String.join(", ", ALLOWED_EXTENSIONS) + "\"}");
            return;
        }

        // ── Validate size ──
        if (filePart.getSize() > MAX_FILE_SIZE) {
            resp.setStatus(HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE);
            resp.getWriter().write("{\"error\":\"File too large. Maximum size is 5 MB.\"}");
            return;
        }

        // ── Validate MIME type ──
        String contentType = filePart.getContentType();
        if (contentType != null && !isAllowedMime(contentType)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"File content type not allowed: " + contentType + "\"}");
            return;
        }

        // ── Forward to Go API ──
        InputStream fileStream = filePart.getInputStream();
        byte[] fileBytes = IOUtils.toByteArray(fileStream);

        try {
            ApiClient client = new ApiClient();
            UploadResponse result = client.upload(fileBytes, filename);
            resp.getWriter().write(JsonUtil.toJson(result));
        } catch (ApiUnavailableException e) {
            resp.setStatus(503);
            resp.getWriter().write("{\"error\":\"Compilation service unavailable\"}");
        } catch (ApiTimeoutException e) {
            resp.setStatus(504);
            resp.getWriter().write("{\"error\":\"Upload timed out\"}");
        } catch (ApiException e) {
            resp.setStatus(502);
            resp.getWriter().write("{\"error\":" + JsonUtil.toJson(e.getMessage()) + "}");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    /**
     * Sanitize filename: strip path separators, null bytes, and control chars.
     */
    private String sanitizeFilename(String name) {
        if (name == null) return null;
        // Strip path components (Windows or Unix)
        name = name.replaceAll(".*[\\\\/]", "");
        // Remove null bytes and control characters
        name = name.replaceAll("[\\x00-\\x1f]", "");
        // Remove leading dots (no hidden files)
        name = name.replaceAll("^\\.+", "");
        // Collapse spaces
        name = name.replaceAll("\\s+", "_");
        // Limit length
        if (name.length() > 100) {
            String ext = getExtension(name);
            name = name.substring(0, 95) + (ext != null ? "." + ext : "");
        }
        return name.isEmpty() ? null : name;
    }

    private String getExtension(String filename) {
        if (filename == null) return null;
        int dot = filename.lastIndexOf('.');
        if (dot < 0 || dot == filename.length() - 1) return null;
        return filename.substring(dot + 1).toLowerCase();
    }

    private boolean isAllowedMime(String mime) {
        if (mime == null) return false;
        String lower = mime.toLowerCase().split(";")[0].trim();
        return ALLOWED_MIME_PREFIXES.contains(lower);
    }
}
