package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import z.y.x.r.LoadPropertyFileFunctionality;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */
public class SSHFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_GENERATE_SSHKEYGEN = "GENERATE_SSHKEYGEN";




    public SSHFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub


        final String methodName = request.getParameter("methodName");


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (METHOD_GENERATE_SSHKEYGEN.equals(methodName)) {
            String algo = request.getParameter("sshalgo");
            String keysize = request.getParameter("sshkeysize");
            String passphrase = request.getParameter("passphrase");


            if (algo == null || algo.trim().length() == 0) {
                algo="ED25519";  // Default to ED25519 (recommended)
            }

            if(passphrase!=null && passphrase.trim().length()>128)
            {
                Gson gson = new Gson();
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate");
                errorResponse.setErrorMessage("Passphrase length should be less than 128 characters");
                out.println(gson.toJson(errorResponse));
                return;
            }


            int keySize=256;  // Default for ED25519
            if(keysize == null || keysize.trim().length()==0)
            {
                keySize=256 ;
            }

            try {
                keySize= Integer.parseInt(keysize);
            } catch(Exception e) {
                keySize=256 ;
            }


            algo = algo.trim().toUpperCase();
            Gson gson = new Gson();

            // Validate algorithm and key size combinations
            if(algo.equals("ED25519"))
            {
                // ED25519 has fixed 256-bit key size
                keySize = 256;
            }
            else if(algo.equals("RSA") || algo.equals("DSA") || algo.equals("ECDSA"))
            {
                if(algo.equals("ECDSA"))
                {
                    if( keySize==256 || keySize==384 || keySize==521 )
                    {
                        // Valid ECDSA key size
                    }
                    else{
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("generate");
                        errorResponse.setAlgorithm("ECDSA");
                        errorResponse.setErrorMessage("Valid key size for ECDSA is (256, 384, 521)");
                        out.println(gson.toJson(errorResponse));
                        return;
                    }
                }
                else if(algo.equals("DSA"))
                {
                    // Fix: Use proper list contains check instead of string contains
                    java.util.List<String> validDsaSizes = java.util.Arrays.asList("512","576","640","704","768","832","896","960","1024","2048");
                    if( validDsaSizes.contains(String.valueOf(keySize)) )
                    {
                        // Valid DSA key size
                    }
                    else{
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("generate");
                        errorResponse.setAlgorithm("DSA");
                        errorResponse.setErrorMessage("Valid key size for DSA is (512, 576, 640, 704, 768, 832, 896, 960, 1024, 2048). Note: DSA is deprecated.");
                        out.println(gson.toJson(errorResponse));
                        return;
                    }
                }
                else if(algo.equals("RSA"))
                {
                    // Validate RSA key size (minimum 1024, recommended 2048+)
                    if(keySize < 1024)
                    {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("generate");
                        errorResponse.setAlgorithm("RSA");
                        errorResponse.setErrorMessage("RSA key size must be at least 1024 bits. Recommended: 2048 or 4096 bits.");
                        out.println(gson.toJson(errorResponse));
                        return;
                    }
                }
            }
            else
            {
                // Unsupported algorithm
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate");
                errorResponse.setErrorMessage("Unsupported algorithm: " + algo + ". Supported algorithms: ED25519, RSA, ECDSA, DSA");
                out.println(gson.toJson(errorResponse));
                return;
            }


            try {

                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "ssh/keygen";

                //System.out.println(url1);

                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                post.addHeader("accept", "application/json");


                urlParameters.add(new BasicNameValuePair("p_keysize", String.valueOf(keySize)));
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_passphrase", passphrase));


                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("generate");
                    errorResponse.setAlgorithm(algo);
                    errorResponse.setErrorMessage("System error: External API returned status " + response1.getStatusLine().getStatusCode() + ". Please try later.");
                    out.println(gson.toJson(errorResponse));
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

                sshpojo sshpojo = gson.fromJson(content.toString(), sshpojo.class);
                if(sshpojo!=null) {
                    // Return structured JSON response
                    EncodedMessage successResponse = new EncodedMessage();
                    successResponse.setSuccess(true);
                    successResponse.setOperation("generate");
                    successResponse.setAlgorithm(sshpojo.getAlgo());
                    successResponse.setOriginalMessage(String.valueOf(sshpojo.getKeySize()));
                    successResponse.setMessage(sshpojo.getPublicKey());  // Public key
                    successResponse.setBase64Encoded(sshpojo.getPrivateKey());  // Private key
                    successResponse.setHexEncoded(sshpojo.getFingerprint());  // Fingerprint

                    // Store keys in session for potential email sending
                    request.getSession().setAttribute("ssh_private_key", sshpojo.getPrivateKey());
                    request.getSession().setAttribute("ssh_public_key", sshpojo.getPublicKey());
                    request.getSession().setAttribute("ssh_fingerprint", sshpojo.getFingerprint());
                    request.getSession().setAttribute("ssh_algo", sshpojo.getAlgo());
                    request.getSession().setAttribute("ssh_keysize", sshpojo.getKeySize());

                    String sessionId = request.getSession().getId();
                    String email = request.getParameter("email");
                    String j_session_id = request.getParameter("j_csrf");

                    // Handle email sending if requested
                    if(email!=null && email.length()>0)
                    {
                        if(!sessionId.equalsIgnoreCase(j_session_id))
                        {
                            EncodedMessage errorResponse = new EncodedMessage();
                            errorResponse.setSuccess(false);
                            errorResponse.setOperation("generate");
                            errorResponse.setAlgorithm(algo);
                            errorResponse.setErrorMessage("Invalid CSRF token. Can't send email. Please refresh the page and try again.");
                            out.println(gson.toJson(errorResponse));
                            return;
                        }

                        SendEmail sendEmail = new SendEmail();
                        final String pw = passphrase;
                        final String privKey = sshpojo.getPrivateKey();
                        final String pubKey =  sshpojo.getPublicKey();


                        if(sendEmail.isValidEmail(email))
                        {
                            // Send email asynchronously
                            new Thread(new Runnable() {
                                  public void run() {
                                    SendEmail sendEmail = new SendEmail();
                                        try {
                                            if(pw!=null && pw.length()>1)
                                            {
                                                sendEmail.sendEmail("Your SSH Keys", pw , "Password" , privKey , "SSH Private Key" , pubKey , "Public Key (authorized_keys)",  email, "sshfunctions.jsp");
                                            }
                                            else {
                                                sendEmail.sendEmail("Your SSH Keys", privKey , "Private Key" , pubKey , "Public Key (authorized_keys)",  email, "sshfunctions.jsp");
                                            }

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }).start();

                            // Add email sent status to response
                            successResponse.setIv("Email sent successfully to: " + email);
                        }
                        else {
                            EncodedMessage errorResponse = new EncodedMessage();
                            errorResponse.setSuccess(false);
                            errorResponse.setOperation("generate");
                            errorResponse.setAlgorithm(algo);
                            errorResponse.setErrorMessage("Invalid email address: " + email);
                            out.println(gson.toJson(errorResponse));
                            return;
                        }
                    }

                    // Return success response with keys
                    out.println(gson.toJson(successResponse));
                }

            }catch (Exception ex)
            {
                gson = new Gson();
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate");
                errorResponse.setAlgorithm(algo);
                errorResponse.setErrorMessage("System error: " + ex.getMessage() + ". Please try later or report the issue.");
                out.println(gson.toJson(errorResponse));
            }


        }


    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
