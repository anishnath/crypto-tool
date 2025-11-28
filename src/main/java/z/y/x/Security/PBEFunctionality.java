package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.*;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.ByteBuffer;
import java.security.Security;
import java.util.*;
import java.util.Base64;

/**
 * 14 November 2017
 *
 * @author Anish Nath
 */
public class PBEFunctionality extends HttpServlet {

    /**
     *
     */
    private static final long serialVersionUID = 2920672118396887204L;
    static Map<String, byte[]> map = new HashMap<String, byte[]>();



    private final String METHOD_NAME = "PBEBLOCK";
    private final String METHOD_NAME_PBE_MESSAGE ="PBEMESSAGE";
    private final String METHOD_NAME_PBKDF2DERIVEKEY ="PBKDFDERIVEKEY";

    private long maxFileSize = 1024 * 10 * 10 *10;

    public static void main(String[] args) throws ServletException, IOException {
        new PBEFunctionality().doPost(null, null);
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        String msg = request.getParameter("uid");
       // System.out.println(msg);
        {
            if (msg != null && msg.length()>0) {
                try {
                    byte[] b = (byte[]) request.getSession().getAttribute(msg);
                    if(b!=null && b.length>0) {
                        response.setContentType("application/octet-stream");
                        response.setHeader("Content-disposition", "attachment; filename=" + msg);
                        OutputStream os = response.getOutputStream();
                        if (os != null) {
                            os.write(b);
                        }
                        os.flush();
                        os.close();
                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    response.sendRedirect("redirect-pbefile.jsp");
                }

            }
        }

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        try {
            //PrintWriter out = response.getWriter();

            boolean isMultipart = ServletFileUpload.isMultipartContent(request);

            //System.out.println(isMultipart);

            String fName = "";


            if (isMultipart) {

                Map<String, Object> requestParameter = new HashMap<String, Object>();
                String md = "";
                // Create a new file upload handler
                ServletFileUpload upload = new ServletFileUpload(
                        getDiskFileFactory(request));

                boolean error = false;
                StringBuilder strbg = new StringBuilder();

                try {

                    List<FileItem> items = upload.parseRequest(request);
                    // Process the uploaded items
                    Iterator<FileItem> iter = items.iterator();
                    while (iter.hasNext()) {
                        FileItem item = iter.next();

                        // Process a file upload
                        if (!item.isFormField()) {
                            String fieldName = item.getFieldName();
                            fName = item.getName();
                            String contentType = item.getContentType();
                            boolean isInMemory = item.isInMemory();
                            long sizeInBytes = item.getSize();

                            //System.out.println(sizeInBytes);
                            if (sizeInBytes == 0) {
                                strbg.append("EMpty file !! Please Upload file for PBE encyption/decyption Max Size 10MB");
                                System.out.println("Here....");
                                error = true;


                            }
                            if (sizeInBytes < maxFileSize) {
                                requestParameter.put(fieldName, item);
                            } else {
                               // System.out.println("Here....22");
                                strbg.append("Only File Size of 10 MB Supported ");
                                error = true;


                            }

                        } else {
                            String name = item.getFieldName();
                            String value = item.getString();
                            requestParameter.put(name, value);
                            // System.out.println("name =" + name + " value =" + value);
                        }
                    } // end while

                } catch (Exception ex) {
                    session.setAttribute("msg","<font size=\"2\" color=\"red\"> System Error +" + ex.getMessage()+ " </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;

                }

                if (error) {
                    response.setContentType("text/html");
                    //out.println("");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;
                }

                String plainText = (String) requestParameter.get("plaintext");
                String rounds = (String) requestParameter.get("rounds");
                int rs = 100;
                try {
                    rs = Integer.parseInt(rounds);
                    if (rs > 5001) {
                        response.setContentType("text/html");
                        //out.println("");
                        session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Currenlty Only Supported upto 5000 round raise feature request </font>");
                        response.sendRedirect("pbefile.jsp");
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    response.setContentType("text/html");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Valid Number of Rounds required in Integer </font>");
                    response.sendRedirect("pbefile.jsp");
                    //out.println("<font size=\"2\" color=\"red\"> A Valid Integer round required </font>");
                    return;
                }
                final String secret = (String) requestParameter.get("secretkey");

                if (secret == null || secret.trim().length() == 0) {
                    response.setContentType("text/html");
                    //out.println("");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Please privide the password for PBE encryption </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;

                }


                String algo = (String) requestParameter.get("cipherparameter");
                final String methodName = (String) requestParameter.get("methodName");
                String encryptdecryptparameter = (String) requestParameter.get("encryptorDecrypt");
                final FileItem item = (FileItem) requestParameter.get("upfile");


                if (METHOD_NAME.equals(methodName)) {
//                    System.out.println(plainText);
//                    System.out.println(rounds);
//                    System.out.println(secret);
//                    System.out.println(algo);
//                    System.out.println(methodName);
//                    System.out.println(encryptdecryptparameter);


                    if ("encrypt".equals(encryptdecryptparameter)) {
                        byte[] b = PBEUtils.encryptFile(IOUtils.toByteArray(item.getInputStream()), secret, algo, rs);
                        if (b != null && b.length > 0) {
                            String msg = " <font size=\"4\" color=\"green\"> Successfully Encrypted file Name [" + fName + "] Encrypted Using Algo [" + algo + "] with round[" + rounds + "]</font>";
                            String uid = UUID.randomUUID().toString();
                            session.setAttribute("msg", msg);
                            session.setAttribute(uid, b);
                            session.setAttribute("downloadlink", uid);
                            response.sendRedirect("pbefile.jsp");
                            return;
                        } else {
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Error Occured Raise feature Request</font>");
                            response.sendRedirect("pbefile.jsp");
                            return;
                        }
                    }
                    if ("decrypt".equals(encryptdecryptparameter)) {
                        byte[] b = PBEUtils.decryptFile(item.getInputStream(), secret, algo, rs);
                        if (b != null && b.length > 0) {
                            System.out.println("-------");
                            String msg = " <font size=\"4\" color=\"green\"> Successfully Decrypted file Name [" + fName + "] Decrypted Using Algo [" + algo + "] with round[" + rounds + "]</font>";
                            String uid = UUID.randomUUID().toString();
                            session.setAttribute("msg", msg);
                            session.setAttribute(uid, b);
                            session.setAttribute("downloadlink", uid);
                            response.sendRedirect("pbefile.jsp");

                            return;
                        } else {
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Error Occured Raise feature Request</font>");
                            response.sendRedirect("pbefile.jsp");
                            return;
                        }
                    }

                }


            }
        } catch (Exception e) {
            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> "+ e.getMessage() +" </font>");
            session.setAttribute("downloadlink", null);
            response.sendRedirect("pbefile.jsp");
            return;
        }

            String  mName= request.getParameter("methodName");

            if(METHOD_NAME_PBE_MESSAGE.equalsIgnoreCase(mName))
            {

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                Gson gson = new Gson();

                String encryptdecryptparameter=request.getParameter("encryptdecryptparameter");
                String message = request.getParameter("message");
                String salt = request.getParameter("salt");
                String rounds = request.getParameter("rounds");
                String algo = request.getParameter("cipherparameter");
                int rs = 100;

                try {
                    rs = Integer.parseInt(rounds);
                    if (rs > 20001) {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("pbe");
                        errorResponse.setErrorMessage("Currently only supported up to 20000 rounds");
                        out.println(gson.toJson(errorResponse));
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("pbe");
                    errorResponse.setErrorMessage("Valid number of rounds required (integer)");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
                String password = request.getParameter("password");

                if (password == null || password.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("pbe");
                    errorResponse.setErrorMessage("Please provide a password for PBE encryption");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (message == null || message.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("pbe");
                    errorResponse.setErrorMessage("Please provide a message for PBE encryption");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                try
                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "pbe/encrypt";
                    boolean isDecrypt = "decryprt".equals(encryptdecryptparameter);

                if (isDecrypt) {
                    // Remove whitespace/newlines that may have been introduced during copy-paste
                    message = message.replaceAll("\\s+", "");

                    // Validate Base64 - try to decode it
                    boolean isValidMessage = false;
                    try {
                        // Try Base64 decoding
                        byte[] decoded = Base64.getDecoder().decode(message);
                        if (decoded != null && decoded.length > 0) {
                            isValidMessage = true;
                        }
                    } catch (Exception ex) {
                        isValidMessage = false;
                    }

                    // Also check for hex format as fallback
                    if (!isValidMessage) {
                        try {
                            // Check if it's a valid hex string
                            if (message.matches("^[0-9A-Fa-f]+$") && message.length() % 2 == 0) {
                                isValidMessage = true;
                            }
                        } catch (Exception ex) {
                            isValidMessage = false;
                        }
                    }

                    if (!isValidMessage) {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("pbe_decrypt");
                        errorResponse.setErrorMessage("For decryption, please input the Base64 encoded message generated during encryption");
                        out.println(gson.toJson(errorResponse));
                        return;
                    }

                    url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pbe/decrypt";
                }

                final String[] cipherparameter = request.getParameterValues("cipherparameternew");

                HttpClient client = HttpClientBuilder.create().build();
                HttpPost post = new HttpPost(url1);

                // Build results for all selected algorithms
                java.util.List<java.util.Map<String, Object>> results = new java.util.ArrayList<>();

                for(int i=0; i<cipherparameter.length; i++)
                {
                    List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                    urlParameters.add(new BasicNameValuePair("p_msg", message));
                    urlParameters.add(new BasicNameValuePair("p_cipher", cipherparameter[i]));
                    urlParameters.add(new BasicNameValuePair("p_secretkey", password));
                    urlParameters.add(new BasicNameValuePair("p_rounds", String.valueOf(rs)));

                    post.setEntity(new UrlEncodedFormEntity(urlParameters));
                    post.addHeader("accept", "application/json");

                    HttpResponse response1 = client.execute(post);

                    if (response1.getStatusLine().getStatusCode() != 200) {
                        BufferedReader br = new BufferedReader(
                                new InputStreamReader((response1.getEntity().getContent()))
                        );
                        StringBuilder content = new StringBuilder();
                        String line;
                        while (null != (line = br.readLine())) {
                            content.append(line);
                        }
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("pbe");
                        errorResponse.setErrorMessage("System error: " + content.toString());
                        out.println(gson.toJson(errorResponse));
                        return;
                    }

                    BufferedReader br = new BufferedReader(
                            new InputStreamReader((response1.getEntity().getContent()))
                    );
                    StringBuilder content = new StringBuilder();
                    String line;
                    while (null != (line = br.readLine())) {
                        content.append(line);
                    }

                    EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);

                    java.util.Map<String, Object> resultItem = new java.util.HashMap<>();
                    resultItem.put("algorithm", cipherparameter[i]);

                    if (!isDecrypt) {
                        // Encryption - extract salt and IV from the result
                        ByteBuffer buffer = ByteBuffer.wrap(new BASE64Decoder().decodeBuffer(encodedMessage.getMessage()));
                        byte[] saltBytes = new byte[8];
                        buffer.get(saltBytes, 0, saltBytes.length);
                        byte[] ivBytes1 = new byte[16];
                        buffer.get(ivBytes1, 0, ivBytes1.length);

                        String salt8bit = new BASE64Encoder().encode(saltBytes);
                        String iv16bit = new BASE64Encoder().encode(ivBytes1);

                        resultItem.put("encryptedMessage", encodedMessage.getMessage());
                        resultItem.put("salt", salt8bit);
                        resultItem.put("iv", iv16bit);
                    } else {
                        resultItem.put("decryptedMessage", encodedMessage.getMessage());
                    }

                    results.add(resultItem);
                }

                // Build success response
                java.util.Map<String, Object> successResponse = new java.util.HashMap<>();
                successResponse.put("success", true);
                successResponse.put("operation", isDecrypt ? "pbe_decrypt" : "pbe_encrypt");
                successResponse.put("inputMessage", message);
                successResponse.put("rounds", rs);
                successResponse.put("results", results);

                out.println(gson.toJson(successResponse));

                }catch (Exception ex)
                {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("pbe");
                    errorResponse.setErrorMessage("System error: " + ex.getMessage());
                    out.println(gson.toJson(errorResponse));
                }

            }


        if(METHOD_NAME_PBKDF2DERIVEKEY.equalsIgnoreCase(mName))
        {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();

            String keylength=request.getParameter("keylength");
            String salt = request.getParameter("salt");
            String rounds = request.getParameter("rounds");
            int rs = 100;

            try {
                rs = Integer.parseInt(rounds);
            } catch (NumberFormatException nfe) {
                java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("operation", "pbkdf2_derive");
                errorResponse.put("errorMessage", "Valid number of iterations required (integer)");
                out.println(gson.toJson(errorResponse));
                return;
            }

            int keyLength = 32;

            try {
                keyLength = Integer.parseInt(keylength);

                if(keyLength > 100000) {
                    java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("operation", "pbkdf2_derive");
                    errorResponse.put("errorMessage", "Maximum supported key length is 100,000 bytes");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

            } catch (NumberFormatException nfe) {
                java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("operation", "pbkdf2_derive");
                errorResponse.put("errorMessage", "Key length must be a valid integer");
                out.println(gson.toJson(errorResponse));
                return;
            }

            String password = request.getParameter("password");

            if (password == null || password.trim().length() == 0) {
                java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("operation", "pbkdf2_derive");
                errorResponse.put("errorMessage", "Please provide a password to derive the key");
                out.println(gson.toJson(errorResponse));
                return;
            }

            try
            {
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pbe/derivekey";

                final String[] cipherparameter = request.getParameterValues("cipherparameternew");

                if (cipherparameter == null || cipherparameter.length == 0) {
                    java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("operation", "pbkdf2_derive");
                    errorResponse.put("errorMessage", "Please select at least one algorithm");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                HttpClient client = HttpClientBuilder.create().build();
                HttpPost post = new HttpPost(url1);

                // Build results for all selected algorithms
                java.util.List<java.util.Map<String, Object>> results = new java.util.ArrayList<>();

                for(int i=0; i<cipherparameter.length; i++)
                {
                    List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                    urlParameters.add(new BasicNameValuePair("p_keylength", keylength));
                    urlParameters.add(new BasicNameValuePair("p_cipher", cipherparameter[i]));
                    urlParameters.add(new BasicNameValuePair("p_password", password));
                    urlParameters.add(new BasicNameValuePair("p_rounds", String.valueOf(rs)));
                    urlParameters.add(new BasicNameValuePair("p_salt", salt));

                    post.setEntity(new UrlEncodedFormEntity(urlParameters));
                    post.addHeader("accept", "application/json");

                    HttpResponse response1 = client.execute(post);

                    if (response1.getStatusLine().getStatusCode() != 200) {
                        BufferedReader br = new BufferedReader(
                                new InputStreamReader((response1.getEntity().getContent()))
                        );
                        StringBuilder content = new StringBuilder();
                        String line;
                        while (null != (line = br.readLine())) {
                            content.append(line);
                        }
                        java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                        errorResponse.put("success", false);
                        errorResponse.put("operation", "pbkdf2_derive");
                        errorResponse.put("errorMessage", "System error: " + content.toString());
                        out.println(gson.toJson(errorResponse));
                        return;
                    }

                    BufferedReader br = new BufferedReader(
                            new InputStreamReader((response1.getEntity().getContent()))
                    );

                    StringBuilder content = new StringBuilder();
                    String line;
                    while (null != (line = br.readLine())) {
                        content.append(line);
                    }

                    EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);

                    java.util.Map<String, Object> resultItem = new java.util.HashMap<>();
                    resultItem.put("algorithm", cipherparameter[i]);
                    resultItem.put("derivedKey", encodedMessage.getBase64Decoded());
                    resultItem.put("iv", encodedMessage.getIntialVector());

                    results.add(resultItem);
                }

                // Build success response
                java.util.Map<String, Object> successResponse = new java.util.HashMap<>();
                successResponse.put("success", true);
                successResponse.put("operation", "pbkdf2_derive");
                successResponse.put("salt", salt);
                successResponse.put("iterations", rs);
                successResponse.put("keyLengthBytes", keyLength);
                successResponse.put("results", results);

                out.println(gson.toJson(successResponse));

            } catch (Exception ex) {
                java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("operation", "pbkdf2_derive");
                errorResponse.put("errorMessage", "System error: " + ex.getMessage());
                out.println(gson.toJson(errorResponse));
            }
        }


            }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }





    /**
     * @param request
     * @return
     */
    private DiskFileItemFactory getDiskFileFactory(HttpServletRequest request) {
        // Check that we have a file upload request

        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();

        // Configure a repository (to ensure a secure temp location is used)
        ServletContext servletContext = this.getServletConfig()
                .getServletContext();
        File repository = (File) servletContext
                .getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        return factory;
    }

}
