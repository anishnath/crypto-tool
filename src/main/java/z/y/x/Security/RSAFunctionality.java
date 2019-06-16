package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.Base64;
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
    private static final String METHOD_SIGN_VERIFY_TERSA = "RSA_SIGN_VERIFY_MESSAGEE";



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
        String pageName=request.getParameter("rsasignverifyfunctions");
        if (keysize != null && keysize.trim().length() > 0) {
            try {

                Gson gson = new Gson();
                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/" + keysize;

                //System.out.println(url1);

                HttpGet getRequest = new HttpGet(url1);
                getRequest.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(getRequest);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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
                pgppojo pgppojo = gson.fromJson(content.toString(), pgppojo.class);


                request.getSession().setAttribute("pubkey", pgppojo.getPubliceKey());
                request.getSession().setAttribute("privKey", pgppojo.getPrivateKey());
                request.getSession().setAttribute("keysize", keysize);

                String nextJSP = "/rsafunctions.jsp";

                if(pageName!=null && "rsasignverifyfunctions".equalsIgnoreCase(pageName))
                {
                    nextJSP = "/rsasignverifyfunctions.jsp";
                }


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

        //System.out.println("Is Valid -- " +Utils.vaildate());

        if(Utils.vaildate())
        {
            addHorizontalLine(out);
            out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License <p>\n" +
                    "<a href=\"mailto:zarigatongy@gmail.com?Subject=Crypto License Required\" target=\"_top\">zarigatongy@gmail.com</a>\n" +
                    "</p>\n </font>");
            return;
        }


        String publiKeyParam = request.getParameter("publickeyparam");
        String privateKeParam = request.getParameter("privatekeyparam");
        final String message = request.getParameter("message");
        String algo = request.getParameter("cipherparameter");
        final String methodName = request.getParameter("methodName");
        String keysize = request.getParameter("keysize");
        String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");

        String signature = request.getParameter("signature");




//        System.out.println("publiKeyParam " + publiKeyParam);
//        System.out.println("privateKeParam " + privateKeParam);
//         System.out.println("message " + message);
//        System.out.println("algo " + algo);
//        System.out.println("keysize " + keysize);
//        System.out.println("encryptdecryptparameter " + encryptdecryptparameter);
//        System.out.println("methodName " + methodName);
//
//        System.out.println("signature " + signature);


        if (METHOD_SIGN_VERIFY_TERSA.equalsIgnoreCase(methodName)) {

            if (algo == null || algo.length() == 0) {
                algo = "SHA256withRSA";
            }



             // This is Verification of the Message
            if ("encrypt".equals(encryptdecryptparameter)) {

                if (null == message || message.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Message is Null or EMpty....</font>");
                    return;

                }

                if (null == signature || signature.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Signature is Empty or Null Please Inpur Signature Value in Base64 Format....</font>");
                    return;

                }

                if (publiKeyParam != null && publiKeyParam.trim().length() > 0) {
//                    publiKeyParam = publiKeyParam.replace("-----BEGIN PUBLIC KEY-----\n", "");
//                    publiKeyParam = publiKeyParam.replace("-----END PUBLIC KEY-----", "");


                    HttpPost post = null;

                    try {


                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "rsa/verify";
                        post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_key", publiKeyParam));
                        urlParameters.add(new BasicNameValuePair("p_algo", algo));
                        urlParameters.add(new BasicNameValuePair("p_sig", signature));

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
                        String ret = content1.toString();

                        if ( ret.contains("Passed"))
                        {
                            out.println("<p><font size=\"4\" color=\"green\">" + ret + "</font></p>");
                        }
                        else {
                            out.println("<p><font size=\"4\" color=\"red\">" + ret + "</font></p>");
                        }

                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }finally {
                        if(post!=null)
                        {
                            post.releaseConnection();
                        }
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


                    HttpPost post =null;

                    try {

                        byte[] content = privateKeParam.getBytes();
                        InputStream is = new ByteArrayInputStream(content);
                        InputStreamReader isr = new InputStreamReader(is);
                        BufferedReader br = new BufferedReader(isr);

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/sign";
                        post = new HttpPost(url1);
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




                        addHorizontalLine(out);
                        out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"40\">" + content1.toString() + "</textarea>");
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


                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + "  Key Can't be EMPTY </font>");
                }
            }
        }

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


                    HttpPost post = null;

                    try {


                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "rsa/rsaencrypt";
                        post = new HttpPost(url1);
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
                        out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\" id=\"encrypedmessagetextarea\" rows=\"8\" cols=\"40\">" + encodedMessage.getBase64Encoded() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }finally {
                        if(post!=null)
                        {
                            post.releaseConnection();
                        }
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

                    HttpPost post =null;

                    try {

                        byte[] content = privateKeParam.getBytes();
                        InputStream is = new ByteArrayInputStream(content);
                        InputStreamReader isr = new InputStreamReader(is);
                        BufferedReader br = new BufferedReader(isr);

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/rsadecrypt";
                         post = new HttpPost(url1);
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
                        out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"40\">" + encodedMessage.getMessage() + "</textarea>");
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
