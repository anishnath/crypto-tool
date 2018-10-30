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


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */
public class ECFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String EC_FUNCTION = "EC_FUNCTION";
    private static final String EC_GENERATE_KEYPAIR = "EC_GENERATE_KEYPAIR";
    private static final String EC_SIGN_MESSAGEE = "EC_SIGN_VERIFY_MESSAGEE";
    private static final String EC_GENERATE_KEYPAIR_ECDSA = "EC_GENERATE_KEYPAIR_ECDSA";



    public ECFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

//        String nextJSP = "/ecfunctions.jsp";
//        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
//        dispatcher.forward(request, response);

        String curvename = request.getParameter("curvename");
        PrintWriter out = response.getWriter();
        if (curvename != null && curvename.trim().length() > 0) {
            try {

                Gson gson = new Gson();
                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/generatekpecdsa/" + curvename;

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
                request.getSession().setAttribute("curvename", curvename);
                String nextJSP = "/ecsignverify.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);

                httpClient.close();



                return;
            } catch (Exception ex) {

                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the Issuer over comment </font>");
                return;
            }
        }

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub


        final String methodName = request.getParameter("methodName");



        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);

        if(Utils.vaildate())
        {
            addHorizontalLine(out);
            out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License </font>");
            return;
        }


        if (EC_SIGN_MESSAGEE.equals(methodName)) {

            String publiKeyParam = request.getParameter("publickeyparam");
            String privateKeParam = request.getParameter("privatekeyparam");
            final String message = request.getParameter("message");
            String algo = request.getParameter("cipherparameter");
            String signature = request.getParameter("signature");
            String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");

            //System.out.println("encryptdecryptparameter  " +encryptdecryptparameter);

            if (null == message || message.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Message is Null or EMpty....</font>");
                return;

            }


            // This is Sign Message
            if ("encrypt".equals(encryptdecryptparameter)) {


                if (publiKeyParam != null && publiKeyParam.trim().length() > 0) {

                    if (!publiKeyParam.contains("BEGIN EC PRIVATE KEY") && !publiKeyParam.contains("END EC PRIVATE KEY"))

                    {

                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + algo + " EC Private Key is not valid for Signature generation </font>");
                        return;

                    }

                    HttpPost post =null;

                    try {

                        byte[] content = privateKeParam.getBytes();
                        InputStream is = new ByteArrayInputStream(content);
                        InputStreamReader isr = new InputStreamReader(is);
                        BufferedReader br = new BufferedReader(isr);

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/sign";
                        post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_privatekey", publiKeyParam));
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
                                out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
                                return;
                            } else {
                                addHorizontalLine(out);
                                out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font></p>");
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
                        out.println("<p><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"40\">" + content1.toString() + "</textarea></p>");
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
                else {
                    addHorizontalLine(out);
                    out.println("<p><font size=\"2\" color=\"red\"> " + algo + " EC Private Key Can't be EMPTY </font></p>");
                }


            }

            // This is Signature Verification
            if ("decryprt".equals(encryptdecryptparameter)) {


                if (null == signature || signature.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> signature is Null or EMpty....</font>");
                    return;

                }


               // System.out.println("privateKeParam  " + privateKeParam);

                if (privateKeParam != null && privateKeParam.trim().length() > 0) {

                    if (!privateKeParam.contains("BEGIN PUBLIC KEY") && !privateKeParam.contains("END PUBLIC KEY"))

                    {

                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + algo + " EC Public Key is not valid for Signature Verification </font>");
                        return;

                    }
                    else  {

                        HttpPost post =null;

                        try {

                            //System.out.println("Signature-- " + signature);

                            byte[] content = privateKeParam.getBytes();
                            InputStream is = new ByteArrayInputStream(content);
                            InputStreamReader isr = new InputStreamReader(is);
                            BufferedReader br = new BufferedReader(isr);

                            Gson gson = new Gson();
                            HttpClient client = HttpClientBuilder.create().build();
                            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/verify";
                            post = new HttpPost(url1);
                            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                            urlParameters.add(new BasicNameValuePair("p_msg", message));
                            urlParameters.add(new BasicNameValuePair("p_publicKey", privateKeParam));
                            urlParameters.add(new BasicNameValuePair("p_signature", signature));
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
                                    out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
                                    return;
                                } else {
                                    addHorizontalLine(out);
                                    out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font></p>");
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

                            //System.out.println("content1.toString()-- " + content1.toString());

                            addHorizontalLine(out);

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
                            out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
                        }finally {

                            if(post!=null)
                            {
                                post.releaseConnection();
                            }

                        }

                    }


                }else{
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + "EC Public Key Can't be EMPTY for Signature Verification </font>");
                }


            }


        }

        if (EC_GENERATE_KEYPAIR_ECDSA.equals(methodName)) {
            final String ec_param = request.getParameter("ecparam");

            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/generateABkp/" + ec_param;

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
            ecpojo ecpojo = gson.fromJson(content.toString(), ecpojo.class);
            session.setAttribute("ecpojo", ecpojo);
            response.sendRedirect("ecsignverify.jsp");
        }


        if (EC_GENERATE_KEYPAIR.equals(methodName)) {
            final String ec_param = request.getParameter("ecparam");

            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/generateABkp/" + ec_param;

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
            ecpojo ecpojo = gson.fromJson(content.toString(), ecpojo.class);
            session.setAttribute("ecpojo", ecpojo);
            response.sendRedirect("ecfunctions.jsp");
        }


        if (EC_FUNCTION.equals(methodName)) {

            String publiKeyParam = request.getParameter("publickeyparama");
            String privateKeParam = request.getParameter("privatekeyparama");
            String publickeyparamb = request.getParameter("publickeyparamb");
            String privatekeyparamb = request.getParameter("privatekeyparamb");
            String iv = request.getParameter("iv");
            final String message = request.getParameter("message");
            String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");




            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/ecencryptdecrypt";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();


            if ("encrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                if (null == privateKeParam || privateKeParam.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Encryption EC-Private Key of Alice is Needed </font>");
                    return;
                }

                if (null == publickeyparamb || publickeyparamb.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Encryption Public Key of Bob is Needed </font>");
                    return;
                }

                urlParameters.add(new BasicNameValuePair("p_publicKey", publickeyparamb));
                urlParameters.add(new BasicNameValuePair("p_privatekey", privateKeParam));
            }

            if ("decrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                if (null == privatekeyparamb || privatekeyparamb.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Decryption EC-Private Key of Bob is Needed </font>");
                    return;
                }

                if (null == publiKeyParam || publiKeyParam.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Decryption Public Key of Alice is Needed </font>");
                    return;
                }


                String pattern = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
                boolean isValidMessage = false;
                if (message.matches(pattern)) {
                    isValidMessage = true;
                }

                if (!isValidMessage) {
                    try {
                        Long.parseLong(message, 16);
                        isValidMessage = true;
                    } catch (NumberFormatException ex) {
                        isValidMessage = false;
                    }
                }
                if (!isValidMessage) {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\"> For Decryption Please input a valid Base64 Message " + message + "</font>");
                    return;
                }

                urlParameters.add(new BasicNameValuePair("p_publicKey", publiKeyParam));
                urlParameters.add(new BasicNameValuePair("p_privatekey", privatekeyparamb));
            }

            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_encryptDecrypt", encryptdecryptparameter));
            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

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

            EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);

            if ("decrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                out.println("Decrypted Message<font size=\"4\" color=\"green\"> [ " + encodedMessage.getMessage() + " ]</font>");
                return;
            }

            if ("encrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                out.println("Base64 Encoded Encrypted Message<font size=\"4\" color=\"green\">  [" + encodedMessage.getBase64Encoded() + "]</font>\n</br>");
                out.println("Random 16 bit Intial Vector Used <font size=\"4\" color=\"green\">  [" + encodedMessage.getIntialVector() + "]</font>\n");
                return;
            }

        }
    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}