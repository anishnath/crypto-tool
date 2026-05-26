package z.y.x.aws.s3;

import z.y.x.Security.SendEmail;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class PasteBinFunctionality extends HttpServlet {
    private static final String BUCKET_NAME = "f81821f3";
    private static final long serialVersionUID = 2L;
    private static final String PAGE_NAME = "securebin.jsp" ;

    // Allow-listed values for the create-secret form.
    private static final Set<Long> ALLOWED_EXPIRY_SECONDS = new HashSet<Long>(Arrays.asList(
            300L, 3600L, 86400L, 604800L));
    private static final Set<Integer> ALLOWED_MAX_VIEWS = new HashSet<Integer>(Arrays.asList(
            0, 1, 3, 5));
    private static final long DEFAULT_EXPIRY_SECONDS = 86400L; // 24h
    private static final int  DEFAULT_MAX_VIEWS      = 0;      // unlimited until expiry (legacy pastebin.jsp default)

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String shortcode = request.getParameter("shortcode");

        if (null == shortcode || shortcode.length() == 0) {
            response.sendRedirect(PAGE_NAME);
            return;
        }

        S3UrlShortner s3UrlShortner = new S3UrlShortner();
        String fileName = s3UrlShortner.resolveForView(shortcode);

        if (fileName == null) {
            // Generic gone response. Don't distinguish expired vs burned vs invalid —
            // that's a free oracle for shortcode-guessing.
            response.setStatus(HttpServletResponse.SC_GONE);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"gone\"}");
            return;
        }

        S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
        String presignedUrl = presignedUrlGenerator.getPresignedUrl(BUCKET_NAME, fileName);
        response.setContentType("application/json");
        response.getWriter().write("{\"presignedUrl\":\"" + presignedUrl + "\"}");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Encrypted payloads from securebin.jsp are raw binary (iv || ciphertext).
        // The legacy text-paste path in pastebin.jsp still POSTs text/plain via isEncrypted=false.
        String isEncrypted = request.getParameter("isEncrypted");
        boolean isEncryptedFlag = "true".equalsIgnoreCase(isEncrypted);
        String contentType = isEncryptedFlag ? "application/octet-stream" : "text/plain";
        String email = request.getParameter("email");
        String sendEmail = request.getParameter("sendEmail");
        String password = request.getParameter("password");
        String from = request.getParameter("from");


        if (email == null || email.length() == 0) {
            email = "anonymous_securebin";
        }

        if (sendEmail == null || sendEmail.length() == 0) {

            boolean isEncryptedBool = false;

            if (null == isEncrypted || isEncrypted.length() == 0) {
                isEncryptedBool = false;
            } else if ("true".equalsIgnoreCase(isEncrypted)) {
                isEncryptedBool = true;
            } else {
                isEncryptedBool = false;
            }

            final String fileName = generateFilename(isEncryptedBool);

            long expirySeconds = parseExpirySeconds(request.getParameter("expirySeconds"));
            int  maxViews      = parseMaxViews(request.getParameter("maxViews"));

            S3UrlShortner s3UrlShortner = new S3UrlShortner();
            String shortCode = s3UrlShortner.createSecret(fileName, email, expirySeconds, maxViews);

            S3PresignedUrlGenerator s3PresignedUrlGenerator = new S3PresignedUrlGenerator();
            URL presignedRequest = s3PresignedUrlGenerator.createPresignedUrl(BUCKET_NAME, fileName, contentType,
                    new HashMap<>());
            String myURL = presignedRequest.toString();
            String jsonResponse = "{\"presignedUrl\":\"" + myURL.toString() + "\", \"fileName\":\"" + fileName + "\", \"shortCode\":\"" + shortCode + "\"}";
            response.getWriter().write(jsonResponse);
        } else {

            if ("anonymous_securebin".equalsIgnoreCase(email)) {
                return;
            }

            S3UrlShortner s3UrlShortner = new S3UrlShortner();
            String shortcode = request.getParameter("shortcode");
            String headerMessage = "Your Encrypted Content Msg Code "+shortcode+ "";

            String fileName = s3UrlShortner.getfileName(shortcode);
            if (fileName != null) {



                S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
                boolean isFileExist = presignedUrlGenerator.isObjectExist(BUCKET_NAME, fileName);
                if (isFileExist) {
                    String path = request.getRequestURL().toString().replace("pastebin", "securebind.jsp?q=" + shortcode);;
                    System.out.println("path " + path);
                    String pageName = "securebin.jsp";

                    String msg = "<table>" +
                            "<thead>" +
                            "<tr>" +
                            "<th scope=\"col\">Secret Content View URL</th>" +
                            "</tr>" +
                            "</thead>" +
                            "<tbody>" +
                            "<tr>" +
                            "<td><a href=\"" + path + "\" target=\"_blank\">" + path + "</a></td>" +
                            "</tr>" +
                            "</tbody>" +
                            "</table>" +
                            "<p>This file is password protected if you don't have the password it's impossible to decrypt it. The server don't store passwords for security reason</p>" +
                            "<p>This content will get deleted after 12 hour. </p>";

                    if (from!=null && from.length() > 0 ){

                        pageName = "pastebin.jsp";

                        if (password!=null && password.length() > 0) {
                            msg = "<table>" +
                                    "<thead>" +
                                    "<tr>" +
                                    "<th scope=\"col\">Secret Content View URL</th>" +
                                    "</tr>" +
                                    "</thead>" +
                                    "<tbody>" +
                                    "<tr>" +
                                    "<td><a href=\"" + path + "\" target=\"_blank\">" + path + "</a></td>" +
                                    "<td> & password : <code>" + password + "</code></td>" +
                                    "</tr>" +
                                    "</tbody>" +
                                    "</table>" +
                                    "<p>This file is password protected if you don't have the password it's impossible to decrypt it. The server don't store passwords for security reason</p>" +
                                    "<p>This content will get deleted after 12 hour. </p>";
                        } else {
                            headerMessage = "Your Content Msg Code "+shortcode+ "";
                            msg = "<table>" +
                                    "<thead>" +
                                    "<tr>" +
                                    "<th scope=\"col\">Secret Content View URL</th>" +
                                    "</tr>" +
                                    "</thead>" +
                                    "<tbody>" +
                                    "<tr>" +
                                    "<td><a href=\"" + path + "\" target=\"_blank\">" + path + "</a></td>" +
                                    "</tr>" +
                                    "</tbody>" +
                                    "</table>" +
                                    "<p>This content will get deleted after 12 hour. </p>";
                        }

                    }


                    SendEmail sendEmail1 = new SendEmail();

                    if (sendEmail1.isValidEmail(email)) {

                        String finalHeaderMessage = headerMessage;
                        String finalPageName = pageName;
                        String finalEmail = email;
                        String finalMsg = msg;
                        new Thread(new Runnable() {
                            public void run() {
                                SendEmail sendEmail = new SendEmail();
                                try {
                                    sendEmail.sendEmail(finalHeaderMessage, finalMsg, finalEmail, finalPageName);
                                } catch (Exception e) {
                                    // TODO Auto-generated catch block
                                    e.printStackTrace();
                                }
                            }
                        }).start();
                    }
                }
            }
        }
    }

    private static long parseExpirySeconds(String raw) {
        if (raw == null || raw.isEmpty()) return DEFAULT_EXPIRY_SECONDS;
        try {
            long v = Long.parseLong(raw);
            return ALLOWED_EXPIRY_SECONDS.contains(v) ? v : DEFAULT_EXPIRY_SECONDS;
        } catch (NumberFormatException e) {
            return DEFAULT_EXPIRY_SECONDS;
        }
    }

    private static int parseMaxViews(String raw) {
        if (raw == null || raw.isEmpty()) return DEFAULT_MAX_VIEWS;
        try {
            int v = Integer.parseInt(raw);
            return ALLOWED_MAX_VIEWS.contains(v) ? v : DEFAULT_MAX_VIEWS;
        } catch (NumberFormatException e) {
            return DEFAULT_MAX_VIEWS;
        }
    }

    public static String generateFilename(boolean isEncrypted) {
        // Get current time in milliseconds
        long currentTimeMillis = System.currentTimeMillis();

        // Format the time using SimpleDateFormat
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String formattedTime = dateFormat.format(new Date(currentTimeMillis));

        // Generate the filename with .txt extension and append "ENC" if encrypted
        String filename = formattedTime + (isEncrypted ? "_ENC" : "") + ".txt";

        return filename;
    }
}
