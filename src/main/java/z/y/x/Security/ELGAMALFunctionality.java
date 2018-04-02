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
public class ELGAMALFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATERSA = "CALCULATE_ELGAMAL";


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

        int keys =160;
        if (keysize != null && keysize.trim().length() > 0) {
            try {

                try {
                    keys = Integer.parseInt(keysize);
                }catch (NumberFormatException w)
                {
                    keys =160;
                }

                if(keys>512)
                {
                    keys=160;
                }

                KeyPair kp = RSAUtil.generateKey("ELGAMAL",keys);
//                String pubKey = RSAUtil.encodeBASE64(kp.getPublic().getEncoded());
//                String privKey = RSAUtil.encodeBASE64(kp.getPrivate().getEncoded());


                request.getSession().setAttribute("pubkey", RSAUtil.toPem(kp.getPublic()));

                String s = new org.apache.commons.net.util.Base64().encodeToString(kp.getPrivate().getEncoded());

                StringBuilder builder = new StringBuilder();
                builder.append("-----BEGIN PRIVATE KEY-----");
                builder.append("\n");
                builder.append(s);
                builder.append("-----END PRIVATE KEY-----");

                String privKey = builder.toString();

                request.getSession().setAttribute("privKey", privKey);
                request.getSession().setAttribute("keysize", keysize);
                String nextJSP = "/elgamalfunctions.jsp";
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




        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {

            if (algo == null || algo.length() == 0) {
                algo = "ELGAMAL";
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

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = "http://localhost:8082/crypto/rest/elgamal/encrypt";
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
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }

                        //System.out.println("line-- " + line);

                        EncodedMessage encodedMessage = gson.fromJson(content1.toString(), EncodedMessage.class);
                        addHorizontalLine(out);
                       // System.out.println("encodedMessage-- " + encodedMessage);
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

                    try {
                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = "http://localhost:8082/crypto/rest/elgamal/decrypt";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_privatekey", privateKeParam));
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
                        while (null != (line = br1.readLine())) {
                            content1.append(line);
                        }

                        EncodedMessage encodedMessage = gson.fromJson(content1.toString(), EncodedMessage.class);
                        addHorizontalLine(out);
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
