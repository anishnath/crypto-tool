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
import java.util.Date;
import java.util.HashMap;

public class PasteBinFunctionality extends HttpServlet {
    private static final String BUCKET_NAME = "f81821f3";
    private static final long serialVersionUID = 2L;
    private static final String PAGE_NAME = "securebin.jsp" ;

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String shortcode = request.getParameter("shortcode");


        if (null == shortcode || shortcode.length() == 0) {
            response.sendRedirect(PAGE_NAME);
            return;
        }

        HttpSession session = request.getSession(true);
        S3UrlShortner s3UrlShortner = new S3UrlShortner();
        String fileName = s3UrlShortner.getfileName(shortcode);

        if (fileName != null) {

            System.out.println("fileName " + fileName);

            S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
            boolean isFileExist = presignedUrlGenerator.isObjectExist(BUCKET_NAME, fileName);
            if (isFileExist) {
                s3UrlShortner.updateClickCount(shortcode);
                String presignedUrl = presignedUrlGenerator.getPresignedUrl(BUCKET_NAME, fileName);
                String jsonResponse = "{\"presignedUrl\":\"" + presignedUrl.toString() + "\"}";
                response.getWriter().write(jsonResponse);

            } else {
                response.sendRedirect(request.getContextPath() + PAGE_NAME);
            }

        }else{
            response.sendRedirect(request.getContextPath() + PAGE_NAME);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contentType = "text/plain";
        String isEncrypted = request.getParameter("isEncrypted");
        String email = request.getParameter("email");
        String sendEmail = request.getParameter("sendEmail");


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

            S3UrlShortner s3UrlShortner = new S3UrlShortner();
            String shortCode = s3UrlShortner.getShortCode(fileName, email);

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

            String fileName = s3UrlShortner.getfileName(shortcode);
            if (fileName != null) {

                System.out.println("fileName " + fileName);

                S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
                boolean isFileExist = presignedUrlGenerator.isObjectExist(BUCKET_NAME, fileName);
                if (isFileExist) {
                    String path = request.getRequestURL().toString().replace("pastebin", "securebind.jsp?q=" + shortcode);;
                    System.out.println("path " + path);

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


                    String headerMessage = "Your Encrypted Content Msg Code "+shortcode+ "";
                    String pageName = "securebin.jsp";

                    SendEmail sendEmail1 = new SendEmail();

                    if (sendEmail1.isValidEmail(email)) {

                        String finalHeaderMessage = headerMessage;
                        String finalPageName = pageName;
                        String finalEmail = email;
                        new Thread(new Runnable() {
                            public void run() {
                                SendEmail sendEmail = new SendEmail();
                                try {
                                    sendEmail.sendEmail(finalHeaderMessage, msg, finalEmail, finalPageName);
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
