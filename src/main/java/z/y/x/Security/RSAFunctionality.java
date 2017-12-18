package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.jce.provider.JCERSAPublicKey;
import org.bouncycastle.openssl.PEMReader;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.security.KeyPair;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by ANish Nath on 11/7/17.
 */
public class RSAFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATERSA = "CALCULATE_RSA";


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
        //out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");


        String keysize = request.getParameter("keysize");
        if (keysize != null && keysize.trim().length() > 0) {
            try {
                KeyPair kp = RSAUtil.generateKey(Integer.parseInt(keysize));
//                String pubKey = RSAUtil.encodeBASE64(kp.getPublic().getEncoded());
//                String privKey = RSAUtil.encodeBASE64(kp.getPrivate().getEncoded());


                request.getSession().setAttribute("pubkey", RSAUtil.toPem(kp.getPublic()));
                request.getSession().setAttribute("privKey", RSAUtil.toPem(kp));
                request.getSession().setAttribute("keysize", keysize);
                String nextJSP = "/rsafunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);


                return;
            } catch (Exception ex) {
                //DO NOTHING
            }
        }
        //System.out.println(keysize);
        // System.out.println("asdas");

    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        //System.out.println("algo" + algo);
        PrintWriter out = response.getWriter();


        String publiKeyParam = request.getParameter("publickeyparam");
        String privateKeParam = request.getParameter("privatekeyparam");
        final String message = request.getParameter("message");
        String algo = request.getParameter("cipherparameter");
        final String methodName = request.getParameter("methodName");
        String keysize = request.getParameter("keysize");
        String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");


        //

//        System.out.println("publiKeyParam " + publiKeyParam);
//        System.out.println("privateKeParam " + privateKeParam);
        // System.out.println("message " + message);
//        System.out.println("algo " + algo);
//        System.out.println("keysize " + keysize);
//        System.out.println("encryptdecryptparameter " + encryptdecryptparameter);
//        System.out.println("methodName " + methodName);


        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {

            if (algo == null || algo.length() == 0) {
                algo = "RSA";
            }


            if ("encrypt".equals(encryptdecryptparameter)) {

                if (null == message || message.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Message is Null or EMpty....</font>");
                    return;

                }

                if (publiKeyParam != null && publiKeyParam.trim().length() > 0) {
//                    publiKeyParam = publiKeyParam.replace("-----BEGIN PUBLIC KEY-----\n", "");
//                    publiKeyParam = publiKeyParam.replace("-----END PUBLIC KEY-----", "");

                    try {
                        byte[] content = publiKeyParam.getBytes();
                        InputStream is = new ByteArrayInputStream(content);
                        InputStreamReader isr = new InputStreamReader(is);
                        BufferedReader br = new BufferedReader(isr);
                        PEMReader pemReader = new PEMReader(br, null);

                        Object obj = pemReader.readObject();

                        System.out.println("Encrypt RSA -- " + obj.getClass());


                        if (obj instanceof org.bouncycastle.jce.provider.JCERSAPublicKey) {
                            JCERSAPublicKey jcersaPublicKey = (org.bouncycastle.jce.provider.JCERSAPublicKey) obj;

                            // PublicKey publicKeyObj = RSAUtil.getPublicKeyFromString(publiKeyParam);
                            String encryptedMessage = RSAUtil.encrypt(message, jcersaPublicKey, algo);
                            addHorizontalLine(out);
                            out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + encryptedMessage + "</textarea>");
                            return;
                            //out.println(encryptedMessage);

                        }

                        if (obj instanceof java.security.KeyPair) {
                            KeyPair kp = (KeyPair) obj;
                            String encryptedMessage = RSAUtil.encrypt(message, kp.getPrivate(), algo);
                            addHorizontalLine(out);
                            //out.println(encryptedMessage);
                            out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + encryptedMessage + "</textarea>");
                            return;
                        }

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = "http://localhost/crypto/rest/rsa/rsaencrypt";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_key", publiKeyParam));
                        urlParameters.add(new BasicNameValuePair("p_algo", algo));

                        post.setEntity(new UrlEncodedFormEntity(urlParameters));
                        post.addHeader("accept", "application/json");

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
                                out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font>");
                                return;
                            } else {
                                addHorizontalLine(out);
                                out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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
                        while (null != (line = br.readLine())) {
                            content1.append(line);
                        }

                        EncodedMessage encodedMessage = gson.fromJson(content1.toString(), EncodedMessage.class);
                        out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + encodedMessage.getBase64Encoded() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }

                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + " Public Key Can't be EMPTY </font>");

                }
            } else {

                //Assumed Decrypt ...
                // System.out.println(encryptdecryptparameter);
                String encrypedmessagetextarea = request.getParameter("encrypedmessagetextarea");
                //System.out.println("encrypedmessagetextarea ---> " + encrypedmessagetextarea);

                if (privateKeParam != null && privateKeParam.trim().length() > 0) {

                    boolean isBase64 = Base64.isArrayByteBase64(message.getBytes());
                    if (!isBase64) {
                        addHorizontalLine(out);
                        out.println("<font size=\"3\" color=\"red\"> " + "Please Provide Base64 Encoded value Failed to Decrypt.. </font>");
                        return;
                    }

                    if (null == message || message.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> RSA Encryped Message is Null or EMpty....</font>");
                        return;

                    }

//                    privateKeParam = privateKeParam.replace("-----BEGIN PRIVATE KEY-----\n", "");
//                    privateKeParam = privateKeParam.replace("-----END PRIVATE KEY-----", "");


                    try {

                        byte[] content = privateKeParam.getBytes();
                        InputStream is = new ByteArrayInputStream(content);
                        InputStreamReader isr = new InputStreamReader(is);
                        BufferedReader br = new BufferedReader(isr);
                        PEMReader pemReader = new PEMReader(br, null);

                        Object obj = pemReader.readObject();

                        System.out.println("Decrypt RSA-- " + obj.getClass());
                        if (obj instanceof java.security.KeyPair) {
                            KeyPair kp = (KeyPair) obj;
                            String decryptMessage = RSAUtil.decrypt(message, kp.getPrivate(), algo);
                            // out.println(decryptMessage);
                            addHorizontalLine(out);
                            out.println("<textarea name=\"decryptedmessagetextarea\" id=\"decryptedmessagetextarea\" rows=\"10\" cols=\"40\">" + decryptMessage + "</textarea>");
                            return;
                        }

                        if (obj instanceof org.bouncycastle.jce.provider.JCERSAPublicKey) {

                            JCERSAPublicKey jcersaPublicKey = (org.bouncycastle.jce.provider.JCERSAPublicKey) obj;
                            String decryptMessage = RSAUtil.decrypt(message, jcersaPublicKey, algo);

                            addHorizontalLine(out);
                            out.println("<textarea name=\"decryptedmessagetextarea\" id=\"decryptedmessagetextarea\" rows=\"10\" cols=\"40\">" + decryptMessage + "</textarea>");
                            return;


                        }

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = "http://localhost/crypto/rest/rsa/rsadecrypt";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_key", privateKeParam));
                        urlParameters.add(new BasicNameValuePair("p_algo", algo));

                        post.setEntity(new UrlEncodedFormEntity(urlParameters));
                        post.addHeader("accept", "application/json");

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
                                while (null != (line = br.readLine())) {
                                    content1.append(line);
                                }
                                addHorizontalLine(out);
                                out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font>");
                                return;
                            } else {
                                addHorizontalLine(out);
                                out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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

                        EncodedMessage encodedMessage = gson.fromJson(content1.toString(), EncodedMessage.class);
                        out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + encodedMessage.getMessage() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
                    }


                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + "  Key Can't be EMPTY </font>");
                }
            }
        }

    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


}
