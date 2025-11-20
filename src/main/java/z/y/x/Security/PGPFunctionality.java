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
                    StringBuilder builder = new StringBuilder();
                    builder.append("<font size=\"2\" color=\"red\"> PGP Public Key is Empty or NULL  </font>\n");
                    builder.append("\n");
                    builder.append("<font size=\"2\" color=\"red\">" + samplePGPFile + "</font>");

                    response.setContentType("text/html");

                    session.setAttribute("msg", builder.toString());
                    response.sendRedirect("pgpfileverify.jsp");
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
                    response.setContentType("text/html");

                    session.setAttribute("msg", "<font size=\"4\" color=\"green\"> " + responseString + "</font>");

                    session.setAttribute("pKey", pKey);
                    response.sendRedirect("pgpfileverify.jsp");
                    return;
                } else {
                    StringBuilder builder = new StringBuilder();
                    response.setContentType("text/html");
                    builder.append("<font size=\"2\" color=\"red\"> Not a Valid PGP Key File  </font>\n");
                    builder.append("<font size=\"2\" color=\"red\"> Sample PGP File  </font>\n");
                    builder.append("<font size=\"2\" color=\"red\">" + samplePGPFile + "</font>");
                    session.setAttribute("msg", builder.toString());
                    session.setAttribute("pKey", pKey);
                    response.sendRedirect("pgpfileverify.jsp");
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
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Please input either PGP Public/Private Key pair</font>");
                    return;
                }
            	
            	msg = msg.trim();
            	
            	boolean isValid=false;
        		
        		if(msg.contains("BEGIN PGP MESSAGE") && msg.contains("END PGP MESSAGE"))
        		{
        			isValid=true;
        		}
        		
        		if(!isValid)
        		{
        			if (msg.contains("BEGIN PGP PRIVATE KEY BLOCK") && msg.contains("END PGP PRIVATE KEY BLOCK")) 
        			{
        				isValid=true;
        			}
        		}
        		
        		if(!isValid)
        		{
        			if (msg.contains("BEGIN PGP PUBLIC KEY BLOCK") && msg.contains("END PGP PUBLIC KEY BLOCK"))  
        			{
        				isValid=true;
        			}
        		}
        		
        		if(!isValid) {
        			addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Please input either PGP Public/Private Key pair</font>");
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
                
                out.println("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"20\" cols=\"20\" form=\"X\">" + s + "</textarea>");
                out.println("<hr>");
                addHorizontalLine(out);
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
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Identity is Null Associate a Name or Email</font>");
                    return;
                }

                p_identity = p_identity.trim();

                Pattern p = Pattern.compile("[^a-z0-9@. ]", Pattern.CASE_INSENSITIVE);
                Matcher m = p.matcher(p_identity);
                boolean b = m.find();

                if (b) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Invalid Indentity Name No Special Chanacters</font>");
                    return;
                }


                if (p_passpharse == null || p_passpharse.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Passphrase is EMpty or Null </font>");
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
                out.println("<b><u>PGP Key Information for Identity  [" + p_identity + "] (Private Key/Public Key)  </b></u> <br>");
                out.println("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"20\" cols=\"20\" form=\"X\">" + pgp.getPrivateKey() + "</textarea>");
                out.println("<hr>");
                out.println("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"10\" cols=\"10\" form=\"y\">" + pgp.getPubliceKey() + "</textarea>");

                addHorizontalLine(out);
                
                String sessionId = request.getSession().getId();
            	
                if(email!=null && email.length()>0)
                {
                	if(!sessionId.equalsIgnoreCase(j_session_id))
                	{
                		addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> Invalid CSRF token can't send email. Please refresh the page and Try again....</font>");
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
    					out.println("<font size=\"2\" color=\"green\"> Email Send Successfully.</font>");
    	                return;
                	}
                	else {
                		addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> Invalid Email ...</font>");
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
