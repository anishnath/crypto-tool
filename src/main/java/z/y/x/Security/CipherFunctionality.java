package z.y.x.Security;

import java.io.*;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.Provider;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.X509Certificate;
import java.util.*;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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


import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * @author  Anish Nath
 * Demo at 8gwifi.org
 */

public class CipherFunctionality extends HttpServlet {

    private static final String METHOD_ENCRYPRDECRYPT = "CIPHERBLOCK";
    private static final String METHOD_CIPHERCIPHERCAPABLITY = "CIPHERCAPABLITY";
    private static final String METHOD_PEM_DECODER = "PEM_DECODER";
    private static final String METHOD_X509_CERTIFICATECREATOR = "X509_CERTIFICATECREATOR";
    private static final String METHOD_DH = "METHOD_DH";
    private static final String  METHOD_VERIFY_CERTSCSR = "METHOD_VERIFY_CERTSCSR";
    private static final String METHOD_CIPHERBLOCK_NEW = "CIPHERBLOCK_NEW";
    private static final String METHOD_ENCRYPTED_PEM_PASSWORD = "ENCRYPTED_PEM_PASSWORD";
    private static final String METHOD_EXTRACT_PUBLICKEY = "EXTRACT_PUBLICKEY";
    private static final String METHOD_CONVERT_PKCS8 = "CONVERT_PKCS8";
    private static final String FERNET_GENERATE_KEYPAIR = "FERNET_GENERATE_KEYPAIR";
    private static final String FERNET_ENCRYPT_DECRYPT_MESSAGEE ="FERNET_ENCRYPT_DECRYPT_MESSAGEE";



    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
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
        PrintWriter out = response.getWriter();
        
        if(FERNET_ENCRYPT_DECRYPT_MESSAGEE.equalsIgnoreCase(methodName))
        {
        	String privatekeyparam = request.getParameter("privatekeyparam");
            String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");
            final String message = request.getParameter("message");
            
            if (null == message || message.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Message is Null or EMpty....</font>");
                return;

            }
            
            Gson gson = new Gson();
            
            if ("encrypt".equals(encryptdecryptparameter)) {
            	
                HttpPost post =null;

                try {
                    HttpClient client = HttpClientBuilder.create().build();
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "fernet/encrypt";
                    post = new HttpPost(url1);
                    List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                    urlParameters.add(new BasicNameValuePair("p_msg", message));
                    urlParameters.add(new BasicNameValuePair("p_secretkey", privatekeyparam));
                    post.setEntity(new UrlEncodedFormEntity(urlParameters));
                    //post.addHeader("accept", "application/json");

                    HttpResponse response1 = client.execute(post);

                    if (response1.getStatusLine().getStatusCode() != 200) {
                        if (response1.getStatusLine().getStatusCode() == 404) {
                            BufferedReader br1 = new BufferedReader(
                                    new InputStreamReader(
                                            (response1.getEntity().getContent())
                                    )
                            );
                            StringBuilder content1 = new StringBuilder();
                            String line;
                            while (null != (line = br1.readLine())) {
                                content1.append(line);
                            }
                            addHorizontalLine(out);
                            out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
                            return;
                        } else {
                            addHorizontalLine(out);
                            out.println("<p><font size=\"4\" color=\"red\"> System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support. </font></p>");
                            return;
                        }

                    }
                    BufferedReader br1 = new BufferedReader(
                            new InputStreamReader(
                                    (response1.getEntity().getContent())
                            )
                    );
                    StringBuilder content1 = new StringBuilder();
                    String line;
                    while (null != (line = br1.readLine())) {
                        content1.append(line);
                    }
                    fernetpojo fernetpojo = gson.fromJson(content1.toString(), fernetpojo.class);
                    addHorizontalLine(out);
                    out.println("<h4 class=\"mt-4\">Fernet Token</h4>");
                    out.println("<p><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"40\">" + fernetpojo.getSerialize() + "</textarea></p>");
                    
                    out.println("<h4 class=\"mt-4\">Version</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + fernetpojo.getVersion() + "</textarea>");
                    
                    out.println("<h4 class=\"mt-4\">Initial Vector</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + fernetpojo.getIv() + "</textarea>");
                    
                    out.println("<h4 class=\"mt-4\">Time Stamp</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + fernetpojo.getTimestapmp() + "</textarea>");
                    
                    out.println("<h4 class=\"mt-4\">Key</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + fernetpojo.getKey() + "</textarea>");
                    
                    
                    return;


                } catch (Exception e) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
                }finally {

                    if(post!=null)
                    {
                        post.releaseConnection();
                    }

                }
            	
            }
            
            if ("decrypt".equals(encryptdecryptparameter)) {
            	 if (null == privatekeyparam || privatekeyparam.trim().length() == 0) {
                     addHorizontalLine(out);
                     out.println("<font size=\"2\" color=\"red\"> Fernet Key is Null or EMpty....</font>");
                     return;
                 }
            	 
            	  HttpPost post =null;

                  try {
                      HttpClient client = HttpClientBuilder.create().build();
                      String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "fernet/decrypt";
                      post = new HttpPost(url1);
                      List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                      urlParameters.add(new BasicNameValuePair("p_ftoken", message));
                      urlParameters.add(new BasicNameValuePair("p_secretkey", privatekeyparam));
                      post.setEntity(new UrlEncodedFormEntity(urlParameters));
                      //post.addHeader("accept", "application/json");

                      HttpResponse response1 = client.execute(post);

                      if (response1.getStatusLine().getStatusCode() != 200) {
                          if (response1.getStatusLine().getStatusCode() == 404) {
                              BufferedReader br1 = new BufferedReader(
                                      new InputStreamReader(
                                              (response1.getEntity().getContent())
                                      )
                              );
                              StringBuilder content1 = new StringBuilder();
                              String line;
                              while (null != (line = br1.readLine())) {
                                  content1.append(line);
                              }
                              addHorizontalLine(out);
                              out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
                              return;
                          } else {
                              addHorizontalLine(out);
                              out.println("<p><font size=\"4\" color=\"red\"> System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support. </font></p>");
                              return;
                          }

                      }
                      BufferedReader br1 = new BufferedReader(
                              new InputStreamReader(
                                      (response1.getEntity().getContent())
                              )
                      );
                      StringBuilder content1 = new StringBuilder();
                      String line;
                      while (null != (line = br1.readLine())) {
                          content1.append(line);
                      }
                      fernetpojo fernetpojo = gson.fromJson(content1.toString(), fernetpojo.class);
                      addHorizontalLine(out);
                      out.println("<p><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"40\">" + fernetpojo.getMsg() + "</textarea></p>"); 
                      return;


                  } catch (Exception e) {
                      addHorizontalLine(out);
                      out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
                  }finally {

                      if(post!=null)
                      {
                          post.releaseConnection();
                      }

                  }

            	
            }
            
        	
        }
        
        if(FERNET_GENERATE_KEYPAIR.equalsIgnoreCase(methodName))
        {
        	 try {
                 Gson gson = new Gson();
                 DefaultHttpClient httpClient = new DefaultHttpClient();
                 String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "fernet/genkey";

                 //System.out.println(url1);

                 HttpGet getRequest = new HttpGet(url1);
                 getRequest.addHeader("accept", "application/json");

                 HttpResponse response1 = httpClient.execute(getRequest);

                 if (response1.getStatusLine().getStatusCode() != 200) {
                     addHorizontalLine(out);
                     out.println("<font size=\"2\" color=\"red\"> System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support. </font>");
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
                 fernetpojo fernetpojo = gson.fromJson(content.toString(), fernetpojo.class);
                 request.getSession().setAttribute("key", fernetpojo.getKey());
                 String nextJSP = "/fernet.jsp";
                 RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                 dispatcher.forward(request, response);
                 httpClient.close();
                 return;
             
        		 
        	 }catch (Exception ex) {

                 addHorizontalLine(out);
                 out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the Issuer over comment </font>");
                 return;
             }
        }

        if (METHOD_CONVERT_PKCS8.equalsIgnoreCase(methodName)) {

            final String password = request.getParameter("password");
            final String pem = request.getParameter("pem");

            if(null == pem || pem.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> PEM file is null or empty </font>");
                return;
            }

            if (!pem.contains("PRIVATE KEY")) {

                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> PEM file is not Valid </font>");
                return;
            }

            PemParser parser = new PemParser();
            try {
                String message = parser.toPKCS8(pem, password);
                addHorizontalLine(out);
                // System.out.println("encodedMessage-- " + encodedMessage);
                out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" id=\"encrypedmessagetextarea\" readonly=true rows=\"10\" cols=\"80\">" + message + "</textarea>");
                return;
            } catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"3\" color=\"red\"> " + e.getMessage()  + " </font>");
            }

        }

        if (METHOD_EXTRACT_PUBLICKEY.equalsIgnoreCase(methodName)) {

            final String password = request.getParameter("password");
            final String pem = request.getParameter("pem");

            if(null == pem || pem.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> PEM file is null or empty </font>");
                return;
            }

            if (!pem.contains("PRIVATE KEY")) {

                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> PEM file is not Valid </font>");
                return;
            }

            PemParser parser = new PemParser();
            try {
                String message = parser.extractPublicKey(pem, password);
                addHorizontalLine(out);
                // System.out.println("encodedMessage-- " + encodedMessage);
                out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" id=\"encrypedmessagetextarea\" readonly=true rows=\"10\" cols=\"80\">" + message + "</textarea>");
                return;
            } catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"3\" color=\"red\"> " + e.getMessage()  + " </font>");
            }


        }

        if (METHOD_CIPHERBLOCK_NEW.equalsIgnoreCase(methodName)) {

            response.setContentType("application/json");
            String secretkey = request.getParameter("secretkey");
            final String encryptorDecrypt = request.getParameter("encryptorDecrypt");
            final String plaintext = request.getParameter("plaintext");
            //plaintext
            //cipherparameter
            final String cipherparameter = request.getParameter("cipherparameternew");


            if(null == secretkey || secretkey.trim().length()==0)
            {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setErrorMessage("Secret Key is null or empty");
                out.println(errorResponse.toString());
                return;
            }

            if(null == plaintext || plaintext.trim().length()==0)
            {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setErrorMessage("Text is null or empty");
                out.println(errorResponse.toString());
                return;
            }

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "encryptdecrypt/encrypt";

            if("decrypt".equalsIgnoreCase(encryptorDecrypt))
            {
                 url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "encryptdecrypt/decrypt";

                String pattern = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
                boolean isValidMessage = false;
                if (plaintext.matches(pattern)) {
                    isValidMessage = true;
                }

                if (!isValidMessage) {
                    try {
                        Long.parseLong(plaintext, 16);
                        isValidMessage = true;
                    } catch (NumberFormatException ex) {
                        isValidMessage = false;
                    }
                }
                if (!isValidMessage) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setErrorMessage("For Decryption Please provide Base64 or Hex encoded message");
                    errorResponse.setOriginalMessage(plaintext);
                    out.println(errorResponse.toString());
                    return;
                }

            }

            HttpPost post = new HttpPost(url1);

            List<NameValuePair> urlParameters = new ArrayList<>();
            urlParameters.add(new BasicNameValuePair("p_msg", plaintext));
            urlParameters.add(new BasicNameValuePair("p_secretkey", secretkey));
            urlParameters.add(new BasicNameValuePair("p_cipher", cipherparameter));


            try {
//
                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setAlgorithm(cipherparameter);
                    errorResponse.setOperation(encryptorDecrypt);
                    errorResponse.setOriginalMessage(plaintext);

                    if (response1.getStatusLine().getStatusCode() == 404) {
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

                        String errorMsg = content.toString();
                        if(cipherparameter.contains("NOPADDING") && errorMsg.contains("data not block size aligned"))
                        {
                            errorResponse.setErrorMessage("Input Message [" + plaintext +"] is not multiple of 16 bytes (block size)");
                        }
                        else if(errorMsg.contains("java.security.InvalidKeyException: Wrong algorithm: AES or Rijndael required"))
                        {
                            errorResponse.setErrorMessage("Invalid Secret Key Length. Try key length (16, 24, or 32 bytes)");
                        }
                        else {
                            errorResponse.setErrorMessage("System Error: " + errorMsg);
                        }
                    } else {
                        errorResponse.setErrorMessage("System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support.");
                    }

                    out.println(errorResponse.toString());
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

                EncodedMessage result = gson.fromJson(content.toString(), EncodedMessage.class);
                result.setSuccess(true);
                result.setOperation(encryptorDecrypt);
                result.setAlgorithm(cipherparameter);
                result.setOriginalMessage(plaintext);

                // Extract salt and IV for AES_* algorithms (not GCM)
                if(!"decrypt".equalsIgnoreCase(encryptorDecrypt))
                {
                    if (cipherparameter != null && (cipherparameter.startsWith("AES_") && !cipherparameter.contains("GCM"))) {
                        try {
                            ByteBuffer buffer = ByteBuffer.wrap(new BASE64Decoder().decodeBuffer(result.getMessage()));
                            byte[] saltBytes = new byte[20];
                            buffer.get(saltBytes, 0, saltBytes.length);
                            String salt20bit = new BASE64Encoder().encode(saltBytes);
                            result.setSalt(salt20bit);

                            if (!cipherparameter.contains("ECB")) {
                                byte[] ivBytes1 = new byte[16];
                                buffer.get(ivBytes1, 0, ivBytes1.length);
                                String iv16bit = new BASE64Encoder().encode(ivBytes1);
                                result.setIv(iv16bit);
                            }
                        } catch (Exception e) {
                            // If salt/IV extraction fails, continue without them
                        }
                    }
                }

                out.println(result.toString());
                return;



            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setErrorMessage("Exception: " + e.getMessage());
                errorResponse.setAlgorithm(cipherparameter);
                errorResponse.setOperation(encryptorDecrypt);
                out.println(errorResponse.toString());
            }

            return;

        }
        if (METHOD_ENCRYPRDECRYPT.equalsIgnoreCase(methodName)) {
            //secretkey
            //encryptorDecrypt
            String secretkey = request.getParameter("secretkey");
            final String encryptorDecrypt = request.getParameter("encryptorDecrypt");
            final String plaintext = request.getParameter("plaintext");
            //plaintext
            //cipherparameter
            final String cipherparameter = request.getParameter("cipherparameter");
            String algo = getAlgo(cipherparameter);

            //BlowFish Processing
            if (cipherparameter != null && ("Blowfish".equalsIgnoreCase(cipherparameter.trim()) ||
                    "Twofish".equalsIgnoreCase(cipherparameter.trim()) ||
                    "CAST5".equalsIgnoreCase(cipherparameter.trim()) ||
                    "IDEA".equalsIgnoreCase(cipherparameter.trim())
            )) {
                if (secretkey != null) {
                    if (plaintext != null && !plaintext.trim().isEmpty()) {
                        byte[] keyData = (secretkey).getBytes();
                        SecretKeySpec secretKeySpec = new SecretKeySpec(keyData, cipherparameter.trim());
                        Cipher cipher = null;
                        try {
                            cipher = Cipher.getInstance(cipherparameter);
                            if ("encrypt".equals(encryptorDecrypt)) {
                                cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
                                byte[] hasil = cipher.doFinal(plaintext.getBytes());
                                addHorizontalLine(out);
                                String s = new BASE64Encoder().encode(hasil);
                                out.println("<font size=\"4\" color=\"blue\">[" + encryptorDecrypt + "] [" + plaintext + "] using Algo [" + cipherparameter + "] </font><font size=\"5\" color=\"green\">" + s + "</font>");
                            }
                            if ("decrypt".equals(encryptorDecrypt)) {
                                cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
                                byte[] hasil = cipher.doFinal(new BASE64Decoder().decodeBuffer(plaintext));
                                addHorizontalLine(out);
                                out.println("<font size=\"4\" color=\"blue\">[" + encryptorDecrypt + "] [" + plaintext + "] using Algo [" + cipherparameter + "] </font><font size=\"5\" color=\"green\">" + new String(hasil) + "</font>");

                            }
                        } catch (NoSuchAlgorithmException e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">" + e.getMessage() + " </font>");
                        } catch (NoSuchPaddingException e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">" + e.getMessage() + " </font>");
                        } catch (BadPaddingException e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">" + e.getMessage() + " </font>");
                        } catch (IllegalBlockSizeException e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">" + e.getMessage() + " </font>");
                            return;
                        } catch (InvalidKeyException e) {
                            if (cipherparameter != null && ("CAST5".equalsIgnoreCase(cipherparameter.trim()))) {
                                addHorizontalLine(out);
                                out.println("<font size=\"2\" color=\"red\">" + cipherparameter + " key size MISMATCH SUPPORTED Key sizes 40 to 128 bits </font>");
                                return;
                            }
                        }
                    }
                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\">" + cipherparameter + " key size cannot be EMPTY!!! </font>");
                    return;
                }

                return;
            }

            if (secretkey != null && !secretkey.trim().isEmpty()) {
                if (secretkey.trim().length() < 24) {
                    if ("DES".equals(algo) && secretkey.length() < 8) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + algo + " key size must be length greater then 8 </font>");
                        return;
                    }
//                    if ("DES".equals(algo) && secretkey.length() >= 8) {
//                        //DO Nthing
//                    } else {
//                        addHorizontalLine(out);
//                        out.println("<font size=\"4\" color=\"red\">" + algo + " key size must be length greater then 24 </font>");
//                        return;
//                    }

                }
                if (plaintext != null && !plaintext.isEmpty()) {

                    SecretKey skey = null;
                    if ("DES".equals(algo)) {
                        DESKeySpec keySpec;
                        try {
                            keySpec = new DESKeySpec(secretkey.getBytes());
                            SecretKeyFactory factory = SecretKeyFactory.getInstance("DES");
                            SecretKey key = factory.generateSecret(keySpec);
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"blue\">[" + encryptorDecrypt + "] [" + plaintext + "] using Algo [" + cipherparameter + "] </font><font size=\"5\" color=\"green\">" + enCryptDecrypt(plaintext, cipherparameter, encryptorDecrypt, key) + "</font>");
                        } catch (Exception e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> " + e.getMessage() + " </font>");
                            return;
                        }

                    } else {
                        try{
                        secretkey = secretkey.trim();
                        skey = new SecretKeySpec(secretkey.getBytes(), getAlgo(cipherparameter));
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"blue\">[" + encryptorDecrypt + "] [" + plaintext + "] using Algo [" + cipherparameter + "] </font><font size=\"5\" color=\"green\">" + enCryptDecrypt(plaintext, cipherparameter, encryptorDecrypt, skey) + "</font>");
                        } catch (Exception e) {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> " + e.getMessage() + " </font>");
                            return;
                        }
                    }
                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Message is null or empty  </font>");
                    return;
                }

            } else {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Secret Key is null or empty </font>");
                return;

            }
        }

        //PROVIDER CAPABLITY
        if (METHOD_CIPHERCIPHERCAPABLITY.equalsIgnoreCase(methodName)) {

            final String provider = request.getParameter("cipherparameter");
            if (provider != null && !provider.isEmpty()) {
                if (!"NONE".equals(provider)) {
                    addHorizontalLine(out);
                    out.print("<font size=\"3\" color=\"blue\">Capabilities of the provider  </font>" + addProviderCapablities(provider));
                } else {
                    addHorizontalLine(out);
                }

            }

            final String listalgo = request.getParameter("listalgo");
            if (listalgo != null && !listalgo.isEmpty()) {
                if (!"NONE".equals(listalgo)) {
                    addHorizontalLine(out);
                    out.println("<font size=\"3\" color=\"blue\">List of Algorithms  </font>" + ListAlgorithms.addToListAlgoSet(listalgo));
                } else {
                    addHorizontalLine(out);
                }
            }
        }

        //METHOD_PEM_DECODER
        if (METHOD_PEM_DECODER.equalsIgnoreCase(methodName)) {
            final String pem = request.getParameter("pem");
            String certpassword = request.getParameter("certpassword");

            //Had a Default Password
            if (certpassword == null) {
                certpassword = "";
            }
            addHorizontalLine(out);
            PemParser parser = new PemParser();
            try {
                EncodedMessage message = parser.parsePemFile2(pem, certpassword);
                addHorizontalLine(out);
                // System.out.println("encodedMessage-- " + encodedMessage);


                Gson gson = new Gson();

                if(message.getX509()!=null)
                {

                    x509pojo x509pojo =  gson.fromJson(message.getX509().toString(), x509pojo.class);

                    if(x509pojo.getIsSelfSigned()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">"+x509pojo.getIsSelfSigned()+"</h4>");
                    }

                    if(x509pojo.getType()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Type</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getType() + "</textarea>");
                    }

                    if(x509pojo.getVersion()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Version</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getVersion() + "</textarea>");
                    }



                    if(x509pojo.getSerialNumber()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Serial Number</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + x509pojo.getSerialNumber() + "</textarea>");
                    }

                    if(x509pojo.getNotBefore()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Not Before</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getNotBefore() + "</textarea>");
                    }

                    if(x509pojo.getNotAfter()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Not After</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getNotAfter() + "</textarea>");
                    }
                    if(x509pojo.getSubjectDN()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Subject DN</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getSubjectDN() + "</textarea>");
                    }

                    if(x509pojo.getIssuerDN()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Issuer DN</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getIssuerDN() + "</textarea>");
                    }

                    if(x509pojo.getSubjectAlternativeNames()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">SANS</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + x509pojo.getSubjectAlternativeNames() + "</textarea>");

                    }




                    if(x509pojo.getSigAlgName()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Signature Algo</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getSigAlgName() + "</textarea>");
                    }

                    if(x509pojo.getSignature()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Signature</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + x509pojo.getSignature() + "</textarea>");
                    }

                    if(x509pojo.getEncoded()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">Encoded</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + x509pojo.getEncoded() + "</textarea>");
                    }

                    if(x509pojo.getMd5()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">MD5</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getMd5() + "</textarea>");

                    }

                    if(x509pojo.getSha1()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">SHA-1</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + x509pojo.getSha1() + "</textarea>");

                    }

                    if(x509pojo.getSha256()!=null)
                    {
                        out.println("<h4 class=\"mt-4\">SHA-256</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + x509pojo.getSha256() + "</textarea>");

                    }

                    if(x509pojo.getCrticalExtensions()!=null && x509pojo.getCrticalExtensions().length()>0)
                    {
                        out.println("<h4 class=\"mt-4\">Critical Extensions</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + x509pojo.getCrticalExtensions() + "</textarea>");

                    }

                    if(x509pojo.getNoncrticalExtensions()!=null && x509pojo.getNoncrticalExtensions().length()>0 )
                    {
                        out.println("<h4 class=\"mt-4\">Non Critical Extensions</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + x509pojo.getNoncrticalExtensions() + "</textarea>");

                    }


                    return;


                }

                else if(message.getRsapojo()!=null)
                {

                    rsapojo rsapojo =  gson.fromJson(message.getRsapojo().toString(), rsapojo.class);

                    if(rsapojo.getKeySize()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Private-Key:</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getKeySize() + "</textarea>");

                    }

                    if(rsapojo.getAlgo()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Algo</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getAlgo() + "</textarea>");

                    }

                    if(rsapojo.getFormat()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Format</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getFormat() + "</textarea>");

                    }

                    if(rsapojo.getFingerprint()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Fingerprint</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getFingerprint() + "</textarea>");

                    }

                    if(rsapojo.getType()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Type</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getType() + "</textarea>");

                    }

                    if(rsapojo.getModulus()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Modulus</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + rsapojo.getModulus() + "</textarea>");

                    }

                    if(rsapojo.getPublicexponent()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Public Exponent</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getPublicexponent() + "</textarea>");

                    }

                    if(rsapojo.getPrivateexponent()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Private Exponent</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + rsapojo.getPrivateexponent() + "</textarea>");

                    }

                    if(rsapojo.getPrimeP()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Prime P</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=8  form=\"X\">" + rsapojo.getPrimeP() + "</textarea>");

                    }


                    if(rsapojo.getPrimeQ()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Prime Q</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=8  form=\"X\">" + rsapojo.getPrimeQ() + "</textarea>");

                    }


                    if(rsapojo.getPrimeExponentP()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Prime Exponent P</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=8  form=\"X\">" + rsapojo.getPrimeExponentP() + "</textarea>");

                    }

                    if(rsapojo.getPrimeExponentQ()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Prime Exponent Q</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=8  form=\"X\">" + rsapojo.getPrimeExponentQ() + "</textarea>");

                    }

                    if(rsapojo.getCrtCoefficient()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Coefficient</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + rsapojo.getCrtCoefficient() + "</textarea>");

                    }

                    if(rsapojo.getEncoded()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Encoded</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + rsapojo.getEncoded() + "</textarea>");

                    }

                    if(rsapojo.getMd5()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">MD5</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getMd5() + "</textarea>");

                    }

                    if(rsapojo.getSha1()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-1</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + rsapojo.getSha1() + "</textarea>");

                    }

                    if(rsapojo.getSha256()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-256</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + rsapojo.getSha256() + "</textarea>");

                    }



                    return;

                }

                else if(message.getEckeypojo()!=null)
                {

                    eckeypojo eckeypojo =  gson.fromJson(message.getEckeypojo().toString(), eckeypojo.class);

                    if(eckeypojo.getKeySize()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Private-Key(Size)</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getKeySize() + "</textarea>");

                    }

                    if(eckeypojo.getAlgo()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Algo</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getAlgo() + "</textarea>");

                    }

                    if(eckeypojo.getFormat()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Format</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getFormat() + "</textarea>");

                    }

                    if(eckeypojo.getCurveName()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Curve Name</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getCurveName() + "</textarea>");

                    }

                    if(eckeypojo.getPrivateKey()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Priv</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + eckeypojo.getPrivateKey() + "</textarea>");

                    }

                    if(eckeypojo.getPublicKey()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Pub</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=4  form=\"X\">" + eckeypojo.getPublicKey() + "</textarea>");

                    }

                    if(eckeypojo.getAffineX()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Affine X</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + eckeypojo.getAffineX() + "</textarea>");

                    }

                    if(eckeypojo.getAffineY()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Affine Y</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + eckeypojo.getAffineY() + "</textarea>");

                    }

                    if(eckeypojo.getCofactor()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Cofactor</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getCofactor() + "</textarea>");

                    }

                    if(eckeypojo.getOrder()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Order</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + eckeypojo.getOrder() + "</textarea>");

                    }

                    if(eckeypojo.getMd5()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">MD5</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getMd5() + "</textarea>");

                    }

                    if(eckeypojo.getSha1()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-1</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + eckeypojo.getSha1() + "</textarea>");

                    }

                    if(eckeypojo.getSha256()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-256</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + eckeypojo.getSha256() + "</textarea>");

                    }

                }

                else if(message.getDsapojo()!=null)
                {

                    dsapojo dsapojo =  gson.fromJson(message.getDsapojo().toString(), dsapojo.class);

                    if(dsapojo.getKeySize()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Private-Key(Size)</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + dsapojo.getKeySize() + "</textarea>");

                    }

                    if(dsapojo.getAlgo()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Algo</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + dsapojo.getAlgo() + "</textarea>");

                    }

                    if(dsapojo.getFormat()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Format</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + dsapojo.getFormat() + "</textarea>");

                    }





                    if(dsapojo.getG()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">G</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + dsapojo.getG() + "</textarea>");

                    }

                    if(dsapojo.getP()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">P</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + dsapojo.getP() + "</textarea>");

                    }

                    if(dsapojo.getQ()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Q</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + dsapojo.getQ() + "</textarea>");

                    }

                    if(dsapojo.getX()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">X</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=3  form=\"X\">" + dsapojo.getX() + "</textarea>");

                    }

                    if(dsapojo.getY()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Y</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=6  form=\"X\">" + dsapojo.getY() + "</textarea>");

                    }

                    if(dsapojo.getPub()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Pub</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=5  form=\"X\">" + dsapojo.getPub() + "</textarea>");

                    }


                    if(dsapojo.getEncoded()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">Priv</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=5  form=\"X\">" + dsapojo.getEncoded() + "</textarea>");

                    }


                    if(dsapojo.getMd5()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">MD5</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + dsapojo.getMd5() + "</textarea>");

                    }

                    if(dsapojo.getSha1()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-1</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + dsapojo.getSha1() + "</textarea>");

                    }

                    if(dsapojo.getSha256()!=null )
                    {
                        out.println("<h4 class=\"mt-4\">SHA-256</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + dsapojo.getSha256() + "</textarea>");

                    }




                }

                else{


                    out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" id=\"encrypedmessagetextarea\" readonly=true rows=\"10\" cols=\"80\">" + message.getMessage() + "</textarea>");
                    return;
                }


            } catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"3\" color=\"red\"> " + e.getMessage()  + " </font>");
            }
        }

        //X509_CERTIFICATECREATOR
        if (METHOD_X509_CERTIFICATECREATOR.equalsIgnoreCase(methodName)) {
            final String hostname = request.getParameter("hostname");
            final String company = request.getParameter("company");
            final String department = request.getParameter("department");
            final String email = request.getParameter("email");
            final String city = request.getParameter("city");
            final String state = request.getParameter("state");
            final String country = request.getParameter("country");
            final String alt_name = request.getParameter("alt_name");
            final int expiry = Integer.valueOf(request.getParameter("expiry"));
            String p_privateKey = request.getParameter("p_privatekey");

            final String format = request.getParameter("format");

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "certs/genselfsignwithprivkey";

            List<NameValuePair> urlParameters = new ArrayList<>();

            if (hostname == null || hostname.isEmpty()) {
                //addHorizontalLine(out);
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\">  Host Name is Empty or Null  </font>");
                return;
            }

            String encryptdecrypt = request.getParameter("encryptdecrypt");

            boolean x= false;

            if ("useprivatekey".equalsIgnoreCase(encryptdecrypt)) {
                if (null == p_privateKey || p_privateKey.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\">  RSA Private Key is Empty or NULL   </font>");
                    return;
                }
                p_privateKey = p_privateKey.trim();
                if (p_privateKey.contains("BEGIN RSA PRIVATE KEY") && p_privateKey.contains("END RSA PRIVATE KEY")) {
                    x=true;
                    urlParameters.add(new BasicNameValuePair("p_privatekey", p_privateKey.trim()));
                    url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "certs/genselfsignwithprivkey";
                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Not a Valid RSA Private   </font>");
                    return;
                }

            } else {
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "certs/genselfsign";
            }


            HttpPost post = new HttpPost(url1);



            CertInfo certInfo = null;
            if(alt_name!=null)
            {

                String[] namesList = alt_name.split(",");
                certInfo = new CertInfo(hostname, company, department, email, city, state, country,namesList, expiry);
            }
            else {
                certInfo = new CertInfo(hostname, company, department, email, city, state, country, expiry);
            }


            //System.out.println(certInfo);
            //final int bits = Integer.valueOf(request.getParameter("bits"));
            final String version = request.getParameter("version");
            urlParameters.add(new BasicNameValuePair("p_version", version));

            String json = certInfo.toString();

            urlParameters.add(new BasicNameValuePair("p_certinfo", json));

            try {
//
                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    if (response1.getStatusLine().getStatusCode() == 404) {
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
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + content + "</font>");
                        return;
                    } else {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support. </font>");
                        return;
                    }

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

                certpojo certpojo1 = gson.fromJson(content.toString(), certpojo.class);

                addHorizontalLine(out);
                String msg = "<b><u> Certificate in PEM and in X.509 Decoded Format </b></u> <br>";
                if(!x)
                {
                    msg = "<b><u> Certificate in PEM, in X.509 Decoded Format and RSA Private Key </b></u> <br>";
                }
                out.println(msg);
                out.print("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"10\" cols=\"10\" form=\"X\">" + certpojo1.getMessage() + "</textarea><hr>");
                out.print("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"10\" cols=\"10\" form=\"X\">" + certpojo1.getMessage2() + "</textarea><hr>");

                if(!x)
                {

                    out.print("<p>Private Key </p>");
                    out.print("<textarea name=\"comment\" class=\"form-control\" readonly=\"true\" rows=\"5\" cols=\"10\" form=\"X\">" + certpojo1.getPrivatekey() + "</textarea>");
                }



            } catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " +e +" </font>");
            }finally {
                if(post!=null)
                {
                    post.releaseConnection();
                }
            }

            //final String version =
            //Department
            //Email
            //City
            //State
            //Country

        }

        //METHOD_DH
        if (METHOD_VERIFY_CERTSCSR.equalsIgnoreCase(methodName)) {

            String pem1 = request.getParameter("publickeyparama");
            String pem2 = request.getParameter("privatekeyparama");


            if(null==pem1 || pem1.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Input field 1 is empty or null </font>");
            }

            pem1 = pem1.trim();

            if(null==pem2 || pem2.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Input field 2 is empty or null </font>");
                return;
            }

            pem2 = pem2.trim();

            if(pem1.equals(pem2))
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Input field 1 and field2 is Equal  </font>");
                return;
            }

            boolean isValid = false;

            if (pem1.contains("BEGIN RSA PRIVATE KEY") && pem1.contains("END RSA PRIVATE KEY")) {
                isValid = true;
            }

            if (pem1.contains("BEGIN CERTIFICATE REQUEST") && pem1.contains("END CERTIFICATE REQUEST")) {
                isValid = true;
            }

            if (pem1.contains("BEGIN CERTIFICATE") && pem1.contains("END CERTIFICATE")) {
                isValid = true;
            }

            if(!isValid)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Input field 1 is Invalid, provide a Valid CSR or X509 or RSA Private key  </font>");
                return;
            }

            if (pem2.contains("BEGIN RSA PRIVATE KEY") && pem2.contains("END RSA PRIVATE KEY")) {
                isValid = true;
            }

            if (pem2.contains("BEGIN CERTIFICATE REQUEST") && pem2.contains("END CERTIFICATE REQUEST")) {
                isValid = true;
            }

            if (pem2.contains("BEGIN CERTIFICATE") && pem2.contains("END CERTIFICATE")) {
                isValid = true;
            }

            if(!isValid)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Input field 2 is Invalid, provide a Valid CSR or X509 or RSA Private key  </font>");
                return;
            }


            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "certs/verifycsrcrtkey";
            HttpPost post = new HttpPost(url1);

            List<NameValuePair> urlParameters = new ArrayList<>();
            urlParameters.add(new BasicNameValuePair("p_pem1", pem1));
            urlParameters.add(new BasicNameValuePair("p_pem2", pem2));

            try {

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    if (response1.getStatusLine().getStatusCode() == 404) {
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
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + content + "</font>");
                        return;
                    } else {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> System error encountered. Please try again later. If the issue persists, contact us at https://x.com/anish2good for support. </font>");
                        return;
                    }

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

                certpojo certpojo1 = gson.fromJson(content.toString(), certpojo.class);

                addHorizontalLine(out);
                if (certpojo1!=null)
                {
                    if("match".equalsIgnoreCase(certpojo1.getMessage()))
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"green\"> Key Matched  SHA-1 Input1 Key [ " +certpojo1.getMessage2() + "] SHA1-input2 key ["  +certpojo1.getMessage3() + "]  </font>");
                        return;

                    }
                    else
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> Failed SHA-1 Input1 Key [ " +certpojo1.getMessage2() + "] SHA-2 input2 key ["  +certpojo1.getMessage3() + "]  </font>");
                        return;
                    }
                }



            }catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " +e +" </font>");
            }finally {
                if(post!=null)
                {
                    post.releaseConnection();
                }
            }


        }


        if(METHOD_ENCRYPTED_PEM_PASSWORD.equalsIgnoreCase(methodName))
        {
            final String pem = request.getParameter("pem");
            final String certpassword = request.getParameter("certpassword");
            final String email = request.getParameter("email");

            if(email!=null && email.length()>0)
            {
                if(!isValidEmailAddress(email))
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Email Address is Invalid  </font>");
                    return;
                }
            }

            if(null==pem || pem.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Please provide an Encrypted Pem File </font>");
                return;
            }

            if(pem!=null)
            {
                if (!pem.contains("ENCRYPTED")) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Pem file is not encrypted </font>");
                    return;
                }

                if (!pem.contains("BEGIN")) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Pem file is not valid </font>");
                    return;
                }

                if (!pem.contains("END")) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> Pem file is not valid </font>");
                    return;
                }

                addHorizontalLine(out);
                PemParser parser = new PemParser();
                try {
                    String message = parser.crackPemFile(pem, certpassword,email);
                    addHorizontalLine(out);
                    // System.out.println("encodedMessage-- " + encodedMessage);
                    if(message!=null) {
                        if(message.contains("Will Email your password once "))
                        {
                            out.println("<font size=\"4\" color=\"red\"> Password Not Found[ " + message + " ]</font>");
                        }
                        else {
                            out.println("<font size=\"6\" color=\"green\"> Password Found[ " + message + " ]</font>");
                           }

                    }
                    return;
                } catch (Exception e) {
                    addHorizontalLine(out);
                    out.println("<font size=\"3\" color=\"red\"> " + e.getMessage()  + " </font>");
                }

            }
        }

        //METHOD_DH
        if (METHOD_DH.equalsIgnoreCase(methodName)) {
            final String dhparamp = request.getParameter("dhparamp");
            final String dhparamq = request.getParameter("dhparamq");

            if (dhparamq == null || dhparamq.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("DH Paramter cannot be null or empty ");
                return;
            }

            if (dhparamp == null || dhparamp.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("DH Paramter cannot be null or empty ");
                return;
            }

            try {
                BigInteger G = new BigInteger(dhparamp, 16);
                BigInteger P = new BigInteger(dhparamq, 16);
                addHorizontalLine(out);
                out.println( "<textarea class=\"form-control\" readonly=\"true\"  name=\"comment\" rows=\"40\" cols=\"80\" form=\"X\">" + DH.generateTwoWayDump(G, P) +  "</textarea>");
                //out.print(DH.generateTwoWayDump(G, P));
            } catch (Exception ex) {
                addHorizontalLine(out);
                out.println(ex.getMessage());
                return;
            }


        }

    }

    private static String addProviderCapablities(final String provide) {
        Provider provider = Security.getProvider(provide);
        StringBuilder builder = new StringBuilder();

        Iterator it = provider.keySet().iterator();

        builder.append("<center><table  border=\"10\">");
        builder.append("<b>" + provider.getName() + "</b>");
        while (it.hasNext()) {
            String entry = (String) it.next();

            // this indicates the entry refers to another entry

            if (entry.startsWith("Alg.Alias.")) {
                entry = entry.substring("Alg.Alias.".length());
            }
            builder.append("<tr>");
            String factoryClass = entry.substring(0, entry.indexOf('.'));
            String name = entry.substring(factoryClass.length() + 1);
            builder.append("<td>");
            builder.append(factoryClass + " : ");
            builder.append("</td");

            builder.append("<td><font color=\"green\">");
            builder.append(name);
            builder.append("</font></td>");
            builder.append("</tr>");
            // System.out.println(factoryClass + ": " + name);
        }
        builder.append("</table>");
        return builder.toString();
    }

    public boolean isValidEmailAddress(String email) {
        String ePattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(ePattern);
        java.util.regex.Matcher m = p.matcher(email);
        return m.matches();
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


    public static String enCryptDecrypt(String inputText, String cipherparameter,
                                        String encryptOrDecrypt, Key key) throws Exception {

        try {


            byte[] iv;

			/*
             * The input to the encryption processes of the CBC, CFB, and OFB modes includes, in addition to
			   the plaintext, a data block called the initialization vector (IV), denoted IV
			 */
            //java.security.InvalidAlgorithmParameterException: Parameters missing
            if ("DESede/CBC/PKCS5Padding".equals(cipherparameter)
                    || "DES/CBC/NoPadding".equals(cipherparameter)
                    || "DES/CBC/PKCS5Padding".equals(cipherparameter)
                    || "DESede/CBC/NoPadding".equalsIgnoreCase(cipherparameter)) {
                // The INitialVector Must Be 8 bit
                iv = new byte[]{0, 0, 0, 0, 0, 0, 0, 0};
            } else {
                //The InitialVector Must Be 16 bit
                iv = new byte[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            }
            //The InitialVector It's Not Valid for all
            IvParameterSpec ivspec = new IvParameterSpec(iv);
            if ("encrypt".equals(encryptOrDecrypt)) {
                byte b[] = enCrypt(inputText, cipherparameter, key, ivspec);
                return new BASE64Encoder().encode(b);
            }

            if ("decrypt".equals(encryptOrDecrypt)) {

                byte[] data = new BASE64Decoder().decodeBuffer(inputText);
                return deCrypt(data, cipherparameter, key, ivspec);
            }

            if ("Encrypt".equals(encryptOrDecrypt)) {
                byte b[] = enCrypt(inputText, cipherparameter, key, ivspec);
                deCrypt(inputText.getBytes(), cipherparameter, key, ivspec);
            }

        } catch (Exception e) {
           throw  new Exception(e);
        }
        return "PROBLEM CANNOT PERFORM";
    }

    private static byte[] enCrypt(String inputText, String cipherparameter, Key key, IvParameterSpec ivspec)
            throws NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidKeyException, UnsupportedEncodingException,
            IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {

        //System.out.println("Encryting   " + inputText);

        /**Returns a Cipher object that implements the specified transformation.*/
        Cipher cipher = Cipher.getInstance(cipherparameter);
        byte b1[];

        if ("AES/CBC/NoPadding".equals(cipherparameter)) {
            //javax.crypto.IllegalBlockSizeException: Input length not multiple of 16 bytes
            b1 = inputText.getBytes();
            //System.out.println(inputText.getBytes().length);
        } else {
            b1 = inputText.getBytes();
        }

        if (cipherparameter.contains("CBC")) {
            /**Initializes this cipher with a key.*/
            cipher.init(Cipher.ENCRYPT_MODE, key, ivspec);
        } else {
            /**Initializes this cipher with a key.*/
            cipher.init(Cipher.ENCRYPT_MODE, key);
        }

        /** Encrypts or decrypts data in a single-part operation, or finishes a multiple-part operation. */
        byte[] b = cipher.doFinal(b1);
        //System.out.println("Encrpted ==" + StringUtils.byteToHex(b));
        return b;

    }

    private static String deCrypt(byte inputText[], String cipherparameter, Key key, IvParameterSpec ivspec)
            throws NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidKeyException, UnsupportedEncodingException,
            IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {

        //System.out.println("Decrypting " +  StringUtils.byteToHex(inputText));

        /**Returns a Cipher object that implements the specified transformation.*/
        Cipher cipher = Cipher.getInstance(cipherparameter);

        if (cipherparameter.contains("CBC")) {
            cipher.init(Cipher.DECRYPT_MODE, key, ivspec);
        } else {
            cipher.init(Cipher.DECRYPT_MODE, key);
        }

        byte[] b = cipher.doFinal(inputText);
        return new String(b);

    }

    private static String getAlgo(final String transformation) {
        String algo = "DES";
        if (transformation == null || transformation.isEmpty()) {
            // Default
            return algo;
        }
        StringTokenizer stringTokenizer = new StringTokenizer(transformation,
                "/");
        while (stringTokenizer.hasMoreTokens()) {
            algo = stringTokenizer.nextToken();
            break;
        }
        return algo;

    }

    public static void main(String[] args) throws Exception {
		
		/*
		 * five confidentiality modes of operation for symmetric key block 
		   cipher algorithms
		 */
        //The Electronic Codebook Mode (ECB) -->PADDING (the total
        //	(number of bits in the plaintext must be a positive
        //   multiple of the block )
        //The Cipher Block Chaining Mode (CBC) -->PADDING
        //The Cipher Feedback Mode (CFB) -->>PADDING
        //The Output Feedback Mode (OFB)
        //The Counter Mode (CT)

        //A transformation is of the form:
        //	"algorithm/mode/padding" or
        //	"algorithm"
        //e.g  Cipher c = Cipher.getInstance("DES/CBC/PKCS5Padding");
        //e.g  Cipher c = Cipher.getInstance("AES");
		
		/*
		 * For the ECB and CBC modes, the total number of bits in the plaintext must be a multiple of the block size
		 */
		
		/*
		 * For the CFB mode, the total number of bits in the plaintext must be a multiple of a parameter, denoted s
		 */
		
		/*
		 * For the OFB and CTR modes, the plaintext need not be a multiple of the block size
		 */

        //Random Generated SharedSecret
        Key k = null;
        KeyGenerator generator;
        generator = KeyGenerator.getInstance(getAlgo("DES/ECB/PKCS5Padding"));
        generator.init(new SecureRandom());
        k = generator.generateKey();
        //new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",k);

        //User Defined Key
        //Note length Play Important Role Here
        //2b7e151628aed2a6abf7158809cf4f3c
        byte[] keyBytes = "2b7e151628aed2a6abf71589".getBytes();
        //System.out.println("2b7e151628aed2a6abf71589".length());
		
		/*There is no AESKeySpec Sun Only Provide DESKeySpec, DESedeKeySpec, PBEKeySpec*/
        //Using DESKeySpec
        DESKeySpec keySpec = new DESKeySpec(keyBytes);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("DES");
        SecretKey key = factory.generateSecret(keySpec);
        //  new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",key);

        //Using DESedeKeySpec
        DESedeKeySpec deSedeKeySpec = new DESedeKeySpec(keyBytes);
        factory = SecretKeyFactory.getInstance("DESede");
        key = factory.generateSecret(deSedeKeySpec);
        // new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",key);


        //The AES/CBC/PKCS5Padding
        SecretKey skey = new SecretKeySpec(keyBytes, "AES");
        String s = new CipherFunctionality().enCryptDecrypt("SomeText", "AES/CBC/PKCS5Padding", "encrypt", skey);
        System.out.println(s);
        //= new Hex().decode(s.getBytes());
        s = new CipherFunctionality().enCryptDecrypt(s, "AES/CBC/PKCS5Padding", "decrypt", skey);
        System.out.println(s);


        //
        //The AES
        skey = new SecretKeySpec(keyBytes, "AES");
        // new CipherFunctionality().enCryptDecrypt("SomeText","AES", "Encrypt",skey);

        //The DESede/CBC/PKCS5Padding
        skey = new SecretKeySpec(keyBytes, "DESede");
        //new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",skey);

        //The DESede/ECB/NoPadding
        skey = new SecretKeySpec(keyBytes, "DESede");
        //new CipherFunctionality().enCryptDecrypt("SomeText","DESede/ECB/NoPadding", "Encrypt",skey);

        //AES/CBC/NoPadding
        skey = new SecretKeySpec(keyBytes, "AES");
        //new CipherFunctionality().enCryptDecrypt("SomeTextISNOTGREATWHYNOTALLCALLL","AES/CBC/NoPadding", "Encrypt",skey);

    }

}
