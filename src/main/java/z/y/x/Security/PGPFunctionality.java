package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import z.y.x.r.LoadPropertyFileFunctionality;


import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.security.Security;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */
public class PGPFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String GENERATE_PGEP_KEY = "GENERATE_PGEP_KEY";
    private static final String VERIFY_PGP_FILE = "VERIFY_PGP_FILE";
    private static final String PGP_ENCRYPTION_DECRYPTION = "PGP_ENCRYPTION_DECRYPTION";
    private static final String PGP_SEND_ENCRYPTION_EMAIL = "PGP_SEND_ENCRYPTION_EMAIL";
    private static final String PGP_DUMP = "PGP_DUMP";



    private long maxFileSize = 1024 * 10 * 10 * 10;

    public PGPFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        if ("yes".equals(request.getParameter("invalidate"))) {

            if (request.getSession() != null) {
                request.getSession().invalidate();
                request.getRequestDispatcher("pgpfileverify.jsp").forward(request,
                        response);
                ;
                return;
            }
        }

        request.getRequestDispatcher("pgpfileverify.jsp").forward(request,
                response);
        ;
        return;

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        boolean isMultipart = ServletFileUpload.isMultipartContent(request);

        if (isMultipart) {
            HttpSession session = request.getSession(true);
            PrintWriter out = response.getWriter();

            Map<String, Object> requestParameter = new HashMap<String, Object>();
            String md = "";
            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(
                    getDiskFileFactory(request));

            String fName = "";

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
                            strbg.append("EMpty file !! Please Upload a valid PGP Encypted file to Verify Signature");
                            // System.out.println("Here....");
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
                session.setAttribute("msg", "<font size=\"2\" color=\"red\"> System Error +" + ex.getMessage() + " </font>");
                response.sendRedirect("pgpfileverify.jsp");
                return;

            }

            if (error) {
                response.setContentType("text/html");
                //out.println("");
                session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");
                //out.println("<font size=\"2\" color=\"red\"> " + strbg.toString()+" </font>");
                response.sendRedirect("pgpfileverify.jsp");
                return;
            }

            final String methodName = (String) requestParameter.get("methodName");

            if (VERIFY_PGP_FILE.equalsIgnoreCase(methodName)) {

                response.setContentType("text/html");
                 out = response.getWriter();

                String samplePGPFile = "\n-----BEGIN PGP PUBLIC KEY BLOCK-----\n" +
                        "Version: BCPG v1.58\n" +
                        "\n" +
                        "mI0EWiDkcQEEANhVhYz3NAbRhpQST2vqsV3nIg9Zx6lWY6viB/wBkbs14KLGPX8D\n" +
                        "DLBkfGonRtknGIU+0cUEnyNvxE5K5VvRMrqeGzusz+iG3jX9zRomeQtOKL9xQJEJ\n" +
                        "fqJ/Y09KbiZy37x85FAlmmfh7xsxHHLN4zZqbDArLBOTKDDk9C2vQ0Y/ABEBAAG0\n" +
                        "BWFuaXNoiJwEEAECAAYFAlog5HEACgkQlN3e89Fl/7YDuQQA0TTw0iYX9kBmMXGF\n" +
                        "CCWEZyJAhqueYDFhJ29+fvcKLN37Agn595oC8/h3mjylyEeaIsdkVL8rVUzexji6\n" +
                        "esiHZyWoDvzti8cqq5kp146gkYOSEoBiTkGN9Lds1qvDrOZDWvD1HtAWBhDNc/kH\n" +
                        "d/4//xH/VMk12zxr/8WLJ9lU6rs=\n" +
                        "=c9OB\n" +
                        "\n-----END PGP PUBLIC KEY BLOCK-----\n";

                String pKey = (String) requestParameter.get("pKey");

                if (pKey == null || pKey.trim().length() == 0) {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-exclamation-circle\"></i> Missing Public Key</h5>");
                    out.println("  <p class=\"mb-0\">PGP Public Key is required for signature verification. Please provide a valid PGP public key.</p>");
                    out.println("</div>");
                    out.println("<div class=\"card\">");
                    out.println("  <div class=\"card-header bg-secondary text-white\"><i class=\"fas fa-key\"></i> Example PGP Public Key</div>");
                    out.println("  <div class=\"card-body p-0\">");
                    out.println("    <pre class=\"mb-0 p-3\" style=\"font-size: 11px;\">" + samplePGPFile + "</pre>");
                    out.println("  </div>");
                    out.println("</div>");
                    return;
                }


                if (pKey.contains("BEGIN PGP PUBLIC KEY BLOCK") && pKey.contains("END PGP PUBLIC KEY BLOCK")) {

                    final FileItem item = (FileItem) requestParameter.get("file");

                    HttpClient httpclient = new DefaultHttpClient();
                    HttpPost httpPost = new HttpPost( LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pgp/pgpverifyfile");

                    String path = System.getProperty("java.io.tmpdir");
                    String fullPathSecretKey = path + "/" + UUID.randomUUID().toString();
                    String fullPathPublicKey = path + "/" + UUID.randomUUID().toString();


                    File f = new File(fullPathSecretKey);
                    FileUtils.copyInputStreamToFile(item.getInputStream(), f);

                    InputStream stream = new ByteArrayInputStream(pKey.getBytes());
                    File f1 = new File(fullPathPublicKey);
                    FileUtils.copyInputStreamToFile(stream, f1);

                    FileBody uploadFilePart = new FileBody(f);
                    FileBody uploadFilePart2 = new FileBody(f1);


                    MultipartEntity reqEntity = new MultipartEntity();
                    reqEntity.addPart("file", uploadFilePart);
                    reqEntity.addPart("pKey", uploadFilePart2);

                    f.deleteOnExit();
                    f1.deleteOnExit();
                    httpPost.setEntity(reqEntity);

                    HttpResponse httpResponse = httpclient.execute(httpPost);
                    String responseString = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
                    //System.out.println(responseString);

                    // Determine if verification passed or failed based on response
                    boolean isSuccess = responseString.toLowerCase().contains("verified") ||
                                       responseString.toLowerCase().contains("good signature") ||
                                       responseString.toLowerCase().contains("valid");
                    boolean isFailure = responseString.toLowerCase().contains("bad signature") ||
                                       responseString.toLowerCase().contains("invalid") ||
                                       responseString.toLowerCase().contains("failed");

                    if (isSuccess && !isFailure) {
                        out.println("<div class=\"alert alert-success\" role=\"alert\">");
                        out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-check-circle\"></i> Signature Verification Result</h5>");
                        out.println("  <hr>");
                        out.println("  <p class=\"mb-0\">" + responseString + "</p>");
                        out.println("</div>");
                    } else if (isFailure) {
                        out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                        out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-times-circle\"></i> Signature Verification Result</h5>");
                        out.println("  <hr>");
                        out.println("  <p class=\"mb-0\">" + responseString + "</p>");
                        out.println("</div>");
                    } else {
                        out.println("<div class=\"alert alert-info\" role=\"alert\">");
                        out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-info-circle\"></i> Verification Result</h5>");
                        out.println("  <hr>");
                        out.println("  <p class=\"mb-0\">" + responseString + "</p>");
                        out.println("</div>");
                    }

                    return;
                } else {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-exclamation-triangle\"></i> Invalid PGP Public Key</h5>");
                    out.println("  <p>The provided key is not a valid PGP public key. Public keys must begin with <code>-----BEGIN PGP PUBLIC KEY BLOCK-----</code> and end with <code>-----END PGP PUBLIC KEY BLOCK-----</code></p>");
                    out.println("  <p class=\"mb-0\">Please check your key format and try again.</p>");
                    out.println("</div>");
                    out.println("<div class=\"card\">");
                    out.println("  <div class=\"card-header bg-secondary text-white\"><i class=\"fas fa-key\"></i> Example Valid PGP Public Key</div>");
                    out.println("  <div class=\"card-body p-0\">");
                    out.println("    <pre class=\"mb-0 p-3\" style=\"font-size: 11px;\">" + samplePGPFile + "</pre>");
                    out.println("  </div>");
                    out.println("</div>");
                    return;
                }

            }


        } 
        
    
        
        else {
            final String methodName = request.getParameter("methodName");
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            if (PGP_SEND_ENCRYPTION_EMAIL.equals(methodName)) {
            	String j_session_id = request.getParameter("j_csrf");
            	String email = request.getParameter("email");
            	String pgp_message = request.getParameter("pgp_message");
            	String p_cmsg = request.getParameter("p_cmsg");
            	
            	String sessionId = request.getSession().getId();
            	
            	if(!sessionId.equalsIgnoreCase(j_session_id))
            	{
            		addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Invalid CSRF token Please refresh the page and Try again....</font>");
                    return;
            	}
            	
            	
//            	System.out.println(j_session_id);
//            	System.out.println(email);
//            	System.out.println(pgp_message);
            	
            	SendEmail sendEmail = new SendEmail();
            	
            	if(sendEmail.isValidEmail(email))
            	{
            		
            		new Thread(new Runnable() {
            			  public void run() {
            			    SendEmail sendEmail = new SendEmail();
            			    	try {
									sendEmail.sendEmail("Result of PGP Encryption", pgp_message , email, "pgpencdec.jsp");
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
            			    }
            			}).start();	
					out.println("<font size=\"2\" color=\"green\"> Email Send Successfully.</font>");
	                return;
            	}
            	else {
            		addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Invalid Email ...</font>");
                    return;
            	}
            	
            }
            
            if (PGP_DUMP.equalsIgnoreCase(methodName)) {
            	String msg = request.getParameter("p_dump");
            	if (msg == null || msg.trim().length() == 0) {
                    out.println("<div class=\"alert alert-warning\" role=\"alert\">");
                    out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-exclamation-triangle\"></i> Missing Input</h5>");
                    out.println("  <p class=\"mb-0\">Please provide a PGP public/private key, message, or signature to analyze.</p>");
                    out.println("</div>");
                    return;
                }
            	
            	msg = msg.trim();

            	// Validate PGP format
            	boolean isValid = (msg.contains("BEGIN PGP MESSAGE") && msg.contains("END PGP MESSAGE")) ||
        				          (msg.contains("BEGIN PGP PRIVATE KEY BLOCK") && msg.contains("END PGP PRIVATE KEY BLOCK")) ||
        				          (msg.contains("BEGIN PGP PUBLIC KEY BLOCK") && msg.contains("END PGP PUBLIC KEY BLOCK")) ||
        				          (msg.contains("BEGIN PGP SIGNATURE") && msg.contains("END PGP SIGNATURE"));
        		
        		if(!isValid) {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-times-circle\"></i> Invalid PGP Format</h5>");
                    out.println("  <p>The input does not contain valid PGP markers. Supported formats:</p>");
                    out.println("  <ul class=\"mb-0\">");
                    out.println("    <li><code>-----BEGIN PGP PUBLIC KEY BLOCK-----</code></li>");
                    out.println("    <li><code>-----BEGIN PGP PRIVATE KEY BLOCK-----</code></li>");
                    out.println("    <li><code>-----BEGIN PGP MESSAGE-----</code></li>");
                    out.println("    <li><code>-----BEGIN PGP SIGNATURE-----</code></li>");
                    out.println("  </ul>");
                    out.println("</div>");
                    return;
        		}
        		
        		Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pgp/pgpdump";
                HttpPost post = new HttpPost(url1);


                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_msg", msg));
                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");
                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> System Error: Unable to process your request. Please try again later. If the problem persists, contact support at <a href=\"https://x.com/anish2good\" target=\"_blank\" style=\"color: #dc2626; text-decoration: underline;\">@anish2good</a> </font>");
                    return;
                }
                BufferedReader br = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }
                
                String s =content.toString();
                s = new String(s.getBytes("UTF-8"));
                s= s.replace("\\n", "&#13;&#10;");
                s=s.replace("\\t", "&#32;&#32;");
                s=s.replace("\"", "");
                //System.out.println(s);

                // Output with modern Bootstrap card wrapper
                out.println("<div class=\"alert alert-success\" role=\"alert\">");
                out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-check-circle\"></i> PGP Packet Dump Successful</h5>");
                out.println("  <p class=\"mb-0\">Packet information decoded and parsed according to RFC 4880 (OpenPGP)</p>");
                out.println("</div>");

                out.println("<div class=\"card\">");
                out.println("  <div class=\"card-header bg-primary text-white\">");
                out.println("    <i class=\"fas fa-file-code\"></i> <strong>Decoded Packet Information</strong>");
                out.println("  </div>");
                out.println("  <div class=\"card-body p-0\">");
                out.println("    <textarea name=\"comment\" class=\"form-control border-0\" readonly=\"true\" rows=\"20\" style=\"font-family: 'Courier New', monospace; font-size: 12px; resize: vertical;\" form=\"X\">" + s + "</textarea>");
                out.println("  </div>");
                out.println("</div>");
                return;
            	
            	
            }
            //PGP_DUMP
            
            
            if (GENERATE_PGEP_KEY.equals(methodName)) {
                String p_identity = request.getParameter("p_identity");
                String p_passpharse = request.getParameter("p_passpharse");
                String cipherparameter = request.getParameter("cipherparameter");
                String p_keysize = request.getParameter("p_keysize");
                
                String j_session_id = request.getParameter("j_csrf");
            	String email = request.getParameter("email");


                if (p_identity == null || p_identity.trim().length() == 0) {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-exclamation-circle\"></i> Validation Error</h6>");
                    out.println("  <p class=\"mb-0\">Identity is required. Please provide a name or email address.</p>");
                    out.println("</div>");
                    return;
                }

                p_identity = p_identity.trim();

                Pattern p = Pattern.compile("[^a-z0-9@. ]", Pattern.CASE_INSENSITIVE);
                Matcher m = p.matcher(p_identity);
                boolean b = m.find();

                if (b) {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-exclamation-circle\"></i> Validation Error</h6>");
                    out.println("  <p class=\"mb-0\">Invalid identity name. Only alphanumeric characters, spaces, @ and . are allowed.</p>");
                    out.println("</div>");
                    return;
                }


                if (p_passpharse == null || p_passpharse.trim().length() == 0) {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                    out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-exclamation-circle\"></i> Validation Error</h6>");
                    out.println("  <p class=\"mb-0\">Passphrase is required. Please provide a strong passphrase to protect your private key.</p>");
                    out.println("</div>");
                    return;
                }


                p_passpharse = p_passpharse.trim();

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pgp/pgpkeygen";
                HttpPost post = new HttpPost(url1);


                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_keysize", p_keysize));
                urlParameters.add(new BasicNameValuePair("p_identity", p_identity));
                urlParameters.add(new BasicNameValuePair("p_passpharse", p_passpharse));
                urlParameters.add(new BasicNameValuePair("p_algo", cipherparameter));

                post.setEntity(new UrlEncodedFormEntity(urlParameters));


                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> System Error: Unable to process your request. Please try again later. If the problem persists, contact support at <a href=\"https://x.com/anish2good\" target=\"_blank\" style=\"color: #dc2626; text-decoration: underline;\">@anish2good</a> </font>");
                    return;
                }
                BufferedReader br = new BufferedReader(
                        new InputStreamReader(
                                (response1.getEntity().getContent())
                        )
                );

                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                pgppojo pgp = gson.fromJson(content.toString(), pgppojo.class);

                // Modern output with better CLS
                out.println("<div class=\"alert alert-success\" role=\"alert\">");
                out.println("  <h5 class=\"alert-heading\"><i class=\"fas fa-check-circle\"></i> PGP Key Pair Generated Successfully</h5>");
                out.println("  <p class=\"mb-0\">Keys generated for identity: <strong>" + p_identity + "</strong></p>");
                out.println("</div>");

                out.println("<div class=\"card mb-3\">");
                out.println("  <div class=\"card-header bg-danger text-white\">");
                out.println("    <i class=\"fas fa-lock\"></i> <strong>Private Key</strong> <span class=\"badge badge-light text-danger ml-2\">KEEP SECRET</span>");
                out.println("  </div>");
                out.println("  <div class=\"card-body p-0\">");
                out.println("    <textarea name=\"comment\" class=\"form-control border-0\" readonly=\"true\" rows=\"20\" style=\"font-family: 'Courier New', monospace; font-size: 12px; resize: none;\" form=\"X\">" + pgp.getPrivateKey() + "</textarea>");
                out.println("  </div>");
                out.println("</div>");

                out.println("<div class=\"card mb-3\">");
                out.println("  <div class=\"card-header bg-success text-white\">");
                out.println("    <i class=\"fas fa-key\"></i> <strong>Public Key</strong> <span class=\"badge badge-light text-success ml-2\">SHARE FREELY</span>");
                out.println("  </div>");
                out.println("  <div class=\"card-body p-0\">");
                out.println("    <textarea name=\"comment\" class=\"form-control border-0\" readonly=\"true\" rows=\"12\" style=\"font-family: 'Courier New', monospace; font-size: 12px; resize: none;\" form=\"y\">" + pgp.getPubliceKey() + "</textarea>");
                out.println("  </div>");
                out.println("</div>");

                out.println("<div class=\"alert alert-info\" role=\"alert\">");
                out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-info-circle\"></i> Next Steps</h6>");
                out.println("  <ul class=\"mb-0 pl-3\">");
                out.println("    <li>Save your <strong>Private Key</strong> securely and never share it</li>");
                out.println("    <li>Share your <strong>Public Key</strong> with anyone who wants to send you encrypted messages</li>");
                out.println("    <li>Use the Copy and Download buttons above to save your keys</li>");
                out.println("  </ul>");
                out.println("</div>");
                
                String sessionId = request.getSession().getId();
            	
                if(email!=null && email.length()>0)
                {
                	if(!sessionId.equalsIgnoreCase(j_session_id))
                	{
                        out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                        out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-exclamation-triangle\"></i> Security Error</h6>");
                        out.println("  <p class=\"mb-0\">Invalid CSRF token. Please refresh the page and try again.</p>");
                        out.println("</div>");
                        return;
                	}

                	SendEmail sendEmail = new SendEmail();

                	final String id = p_identity;
                	final String pw = p_passpharse;
                	final String privKey = pgp.getPrivateKey();
                	final String pubKey =  pgp.getPubliceKey();


                	if(sendEmail.isValidEmail(email))
                	{

                		new Thread(new Runnable() {
                			  public void run() {
                			    SendEmail sendEmail = new SendEmail();
                			    	try {
    									sendEmail.sendEmail("Yours PGP Keys ", id , "Identity" , pw , "Password" , privKey , "PGP Private Key" , pubKey , "PGP PublicKey",  email, "pgpkeyfunction.jsp");
    								} catch (Exception e) {
    									// TODO Auto-generated catch block
    									e.printStackTrace();
    								}
                			    }
                			}).start();
                        out.println("<div class=\"alert alert-success\" role=\"alert\">");
                        out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-envelope-circle-check\"></i> Email Sent</h6>");
                        out.println("  <p class=\"mb-0\">Your PGP keys have been successfully sent to <strong>" + email + "</strong></p>");
                        out.println("</div>");
    	                return;
                	}
                	else {
                        out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                        out.println("  <h6 class=\"alert-heading\"><i class=\"fas fa-exclamation-circle\"></i> Validation Error</h6>");
                        out.println("  <p class=\"mb-0\">Invalid email address. Please provide a valid email.</p>");
                        out.println("</div>");
                        return;
                	}
                	
                	
                }
                
            	
                


            }

            if (PGP_ENCRYPTION_DECRYPTION.equals(methodName)) {

                final String encryptdecrypt = request.getParameter("encryptdecrypt");
                if ("encrypt".equals(encryptdecrypt)) {
                    //p_cmsg
                    //p_publicKey

                    final String msg = request.getParameter("p_cmsg");
                    final String publicKey = request.getParameter("p_publicKey");

                    if (msg == null || msg.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> Input Message is Null or Empty</font>");
                        return;

                    }


                    if (publicKey == null || publicKey.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> PGP Public Key is Null or EMpty</font>");
                        return;

                    }

                    if (publicKey.contains("BEGIN PGP PUBLIC KEY BLOCK") && publicKey.contains("END PGP PUBLIC KEY BLOCK")) {

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pgp/pgpencrypt";
                        HttpPost post = new HttpPost(url1);


                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", msg));
                        urlParameters.add(new BasicNameValuePair("p_publicKey", publicKey));

                        post.setEntity(new UrlEncodedFormEntity(urlParameters));


                        post.addHeader("accept", "application/json");

                        HttpResponse response1 = client.execute(post);

                        if (response1.getStatusLine().getStatusCode() != 200) {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> System Error: Unable to process your request. Please try again later. If the problem persists, contact support at <a href=\"https://x.com/anish2good\" target=\"_blank\" style=\"color: #dc2626; text-decoration: underline;\">@anish2good</a> </font>");
                            return;
                        }
                        BufferedReader br = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );

                        StringBuilder content = new StringBuilder();
                        String line;
                        while (null != (line = br.readLine())) {
                            content.append(line);
                        }

                        String d = content.toString().substring(1, content.toString().length() - 1);

                        d = d.replace("\\n", "&#10;");

                        //out.println("<font size=\"4\" color=\"green\"> " + d + "</font>");
                        out.println("<font size=\"4\" color=\"green\"> PGP MESSAGE </font>");
                        out.println("<textarea name=\"comment\" class=\"form-control animated\" readonly rows=\"10\" form=\"X\">" + d + "</textarea>");

                    } else {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> PGP does not have Valid PGP Public Key it should start with \\n -----BEGIN PGP PUBLIC KEY BLOCK----- \\n and ends with \\n -----END PGP PUBLIC KEY BLOCK----- \\n</font>");
                        return;
                    }

                }

                if ("decrypt".equals(encryptdecrypt)) {

                    final String msg = request.getParameter("p_pgpmessage");
                    final String privateKey = request.getParameter("p_privateKey");
                    final String passPhrase = request.getParameter("p_passpharse");


                    if (msg == null || msg.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> PGP Message is Null or Empty..</font>");
                        return;

                    }
                    if (!msg.contains("BEGIN PGP MESSAGE") && !msg.contains("END PGP MESSAGE")) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\">  does not have Valid PGP MESSAGE with \n" +
                                " -----BEGIN BEGIN PGP MESSAGE----- \n" +
                                " and ends with \n" +
                                " -----END PGP MESSAGE----- .</font>".replace("\\n", "<br />"));
                        return;

                    }

                    if (passPhrase == null || passPhrase.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> does not have a valid Passphrase it's empty or null</font>");
                        return;
                    }

                    if (privateKey == null || privateKey.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> does not have a PGP Private Key it's empty or null</font>");
                        return;

                    }

                    if (privateKey.contains("BEGIN PGP PRIVATE KEY BLOCK") && privateKey.contains("END PGP PRIVATE KEY BLOCK")) {

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "pgp/pgpdecrypt";
                        HttpPost post = new HttpPost(url1);


                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", msg));
                        urlParameters.add(new BasicNameValuePair("p_privateKey", privateKey));
                        urlParameters.add(new BasicNameValuePair("p_passpharse", passPhrase));

                        post.setEntity(new UrlEncodedFormEntity(urlParameters));


                        post.addHeader("accept", "application/json");

                        HttpResponse response1 = client.execute(post);

                        if (response1.getStatusLine().getStatusCode() != 200) {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> System Error: Unable to process your request. Please try again later. If the problem persists, contact support at <a href=\"https://x.com/anish2good\" target=\"_blank\" style=\"color: #dc2626; text-decoration: underline;\">@anish2good</a> </font>");
                            return;
                        }
                        BufferedReader br = new BufferedReader(
                                new InputStreamReader(
                                        (response1.getEntity().getContent())
                                )
                        );

                        StringBuilder content = new StringBuilder();
                        String line;
                        while (null != (line = br.readLine())) {
                            content.append(line);
                        }
                        String d = content.toString().substring(1, content.toString().length() - 1);
                        d = d.replace("\\n", "<br />");

                        // Check if response contains error messages
                        String lowerD = d.toLowerCase();

                        // Common PGP error patterns
                        boolean isError = (lowerD.contains("secret key") && lowerD.contains("not found"))
                                       || (lowerD.contains("secret key") && lowerD.contains("message"))
                                       || lowerD.contains("secret key for message not found")
                                       || lowerD.contains("incorrect passphrase")
                                       || lowerD.contains("wrong passphrase")
                                       || lowerD.contains("checksum mismatch")
                                       || lowerD.contains("invalid")
                                       || lowerD.contains("pgpexception")
                                       || lowerD.contains("exception")
                                       || lowerD.contains("error")
                                       || lowerD.contains("failed")
                                       || lowerD.contains("cannot decrypt")
                                       || lowerD.contains("decryption failed")
                                       || lowerD.contains("no suitable key")
                                       // Short messages with key-related terms are likely errors
                                       || (d.length() < 200 && (lowerD.contains("key") || lowerD.contains("passphrase")));

                        if (isError) {
                            out.println("<font size=\"4\" color=\"red\"> INVALID: " + d + "<br/><br/>This means the private key provided does not belong to the recipient of this encrypted message, or the passphrase is incorrect. The message was encrypted for a different public key.</font>");
                        } else {
                            out.println("<font size=\"4\" color=\"green\"> " + d + "</font>");
                        }

                    } else {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\">  does not have Valid PGP Private Key it should start with \\n -----BEGIN PGP PRIVATE KEY BLOCK----- \\n and ends with \\n -----END PGP PRIVATE KEY BLOCK----- </font>");
                        return;

                    }


                }

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
