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
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

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

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

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

        if (METHOD_CIPHERBLOCK_NEW.equalsIgnoreCase(methodName)) {

            String secretkey = request.getParameter("secretkey");
            final String encryptorDecrypt = request.getParameter("encryptorDecrypt");
            final String plaintext = request.getParameter("plaintext");
            //plaintext
            //cipherparameter
            final String cipherparameter = request.getParameter("cipherparameternew");


            if(null == secretkey || secretkey.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Secret Key is null or empty </font>");
                return;
            }

            if(null == plaintext || plaintext.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Text is null or empty </font>");
                return;
            }

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = "http://localhost/crypto/rest/encryptdecrypt/encrypt";

            if("decrypt".equalsIgnoreCase(encryptorDecrypt))
            {
                 url1 = "http://localhost/crypto/rest/encryptdecrypt/decrypt";

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
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Decryption Please Base64 Message whihc is generated during encryption process " + plaintext + "</font>");
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
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.append(content);
                        if(cipherparameter.contains("NOPADDING") && content.toString().contains("data not block size aligned"))
                        {
                            stringBuilder.append("<br>");
                            stringBuilder.append("Input Message [" + plaintext +"] is not multiple of 16");
                        }
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + stringBuilder + "</font>");
                        return;
                    } else {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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

                EncodedMessage certpojo1 = gson.fromJson(content.toString(), EncodedMessage.class);
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"blue\">[" + encryptorDecrypt + "] [" + plaintext + "] using Algo [" + cipherparameter + "] </font><font size=\"5\" color=\"green\">" + certpojo1.getMessage() + "</font></br>");

                if(!"decrypt".equalsIgnoreCase(encryptorDecrypt))
                {
                    if (cipherparameter != null && (cipherparameter.startsWith("AES_") && !cipherparameter.contains("GCM"))) {
                        ByteBuffer buffer = ByteBuffer.wrap(new BASE64Decoder().decodeBuffer(certpojo1.getMessage()));
                        byte[] saltBytes = new byte[20];
                        buffer.get(saltBytes, 0, saltBytes.length);
                        String salt20bit = new BASE64Encoder().encode(saltBytes);
                        out.println("</br><font size=\"4\" color=\"blue\">20 bit salt used[  "+  salt20bit + "] </font> </br>");
                        byte[] ivBytes1 = null;

                        if (!cipherparameter.contains("ECB")) {
                            ivBytes1 = new byte[16];
                            buffer.get(ivBytes1, 0, ivBytes1.length);
                            String iv16bit = new BASE64Encoder().encode(ivBytes1);
                            out.println("<font size=\"4\" color=\"blue\">16 bit Initial Vector[  "+  iv16bit + "] </font> </br>");
                        }

                    }
                }


                return;



            } catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " +e +" </font>");
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
                String message = parser.parsePemFile(pem, certpassword);
                addHorizontalLine(out);
                // System.out.println("encodedMessage-- " + encodedMessage);
                out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" readonly=true rows=\"20\" cols=\"80\">" + message + "</textarea>");
                return;
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
            String url1 = "http://localhost/crypto/rest/certs/genselfsignwithprivkey";

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
                    url1 = "http://localhost/crypto/rest/certs/genselfsignwithprivkey";
                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Not a Valid RSA Private   </font>");
                    return;
                }

            } else {
                url1 = "http://localhost/crypto/rest/certs/genselfsign";
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
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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
                out.print("<textarea name=\"comment\" readonly=true rows=\"20\" cols=\"40\" form=\"X\">" + certpojo1.getMessage() + "</textarea>");
                out.print("<textarea name=\"comment\" readonly=true rows=\"20\" cols=\"40\" form=\"X\">" + certpojo1.getMessage2() + "</textarea>");

                if(!x)
                {
                    out.print("<textarea name=\"comment\" readonly=true rows=\"20\" cols=\"40\" form=\"X\">" + certpojo1.getPrivatekey() + "</textarea>");
                }



            } catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " +e +" </font>");
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
            String url1 = "http://localhost/crypto/rest/certs/verifycsrcrtkey";
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
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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
                out.println( "<textarea name=\"comment\" rows=\"40\" cols=\"80\" form=\"X\">" + DH.generateTwoWayDump(G, P) +  "</textarea>");
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
