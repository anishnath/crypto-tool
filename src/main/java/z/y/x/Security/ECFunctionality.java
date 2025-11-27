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

        // Set JSON response for EC_SIGN_MESSAGEE and EC_FUNCTION
        if (EC_SIGN_MESSAGEE.equals(methodName) || EC_FUNCTION.equals(methodName)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        } else {
            response.setContentType("text/html");
        }

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);


        if (EC_SIGN_MESSAGEE.equals(methodName)) {

            String publiKeyParam = request.getParameter("publickeyparam");
            String privateKeParam = request.getParameter("privatekeyparam");
            final String message = request.getParameter("message");
            String algo = request.getParameter("cipherparameter");
            String signature = request.getParameter("signature");
            String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");
            Gson gson = new Gson();

            if (null == message || message.trim().length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("ec_sign_verify");
                errorResponse.setErrorMessage("Message is null or empty. Please provide a message to sign or verify.");
                out.println(gson.toJson(errorResponse));
                return;
            }


            // This is Sign Message
            if ("encrypt".equals(encryptdecryptparameter)) {


                if (publiKeyParam != null && publiKeyParam.trim().length() > 0) {

                    if (!publiKeyParam.contains("BEGIN EC PRIVATE KEY") && !publiKeyParam.contains("END EC PRIVATE KEY"))

                    {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("ec_sign");
                        errorResponse.setErrorMessage("EC Private Key is not valid for signature generation. Please provide a valid EC private key in PEM format.");
                        out.println(gson.toJson(errorResponse));
                        return;

                    }

                    HttpPost post =null;

                    try {

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
                            EncodedMessage errorResponse = new EncodedMessage();
                            errorResponse.setSuccess(false);
                            errorResponse.setOperation("ec_sign");

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
                                errorResponse.setErrorMessage("System Error: " + content1.toString());
                            } else {
                                errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                            }
                            out.println(gson.toJson(errorResponse));
                            return;
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

                        EncodedMessage successResponse = new EncodedMessage();
                        successResponse.setSuccess(true);
                        successResponse.setOperation("ec_sign");
                        successResponse.setJwsSignature(content1.toString());
                        successResponse.setOriginalMessage(message);
                        out.println(gson.toJson(successResponse));
                        return;


                    } catch (Exception e) {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("ec_sign");
                        errorResponse.setErrorMessage("Error generating signature: " + e.getMessage());
                        out.println(gson.toJson(errorResponse));
                    }finally {

                        if(post!=null)
                        {
                            post.releaseConnection();
                        }

                    }


                }
                else {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_sign");
                    errorResponse.setErrorMessage("EC Private Key cannot be empty for signature generation.");
                    out.println(gson.toJson(errorResponse));
                }


            }

            // This is Signature Verification
            if ("decryprt".equals(encryptdecryptparameter)) {


                if (null == signature || signature.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_verify");
                    errorResponse.setErrorMessage("Signature is null or empty. Please provide a signature to verify.");
                    out.println(gson.toJson(errorResponse));
                    return;

                }


                if (privateKeParam != null && privateKeParam.trim().length() > 0) {

                    if (!privateKeParam.contains("BEGIN PUBLIC KEY") && !privateKeParam.contains("END PUBLIC KEY"))

                    {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("ec_verify");
                        errorResponse.setErrorMessage("EC Public Key is not valid for signature verification. Please provide a valid EC public key in PEM format.");
                        out.println(gson.toJson(errorResponse));
                        return;

                    }
                    else  {

                        HttpPost post =null;

                        try {

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
                                EncodedMessage errorResponse = new EncodedMessage();
                                errorResponse.setSuccess(false);
                                errorResponse.setOperation("ec_verify");

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
                                    errorResponse.setErrorMessage("System Error: " + content1.toString());
                                } else {
                                    errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                                }
                                out.println(gson.toJson(errorResponse));
                                return;
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

                            String ret = content1.toString();

                            EncodedMessage verifyResponse = new EncodedMessage();
                            verifyResponse.setOperation("ec_verify");
                            verifyResponse.setOriginalMessage(message);
                            verifyResponse.setJwsSignature(signature);

                            if (ret.contains("Passed")) {
                                verifyResponse.setSuccess(true);
                                verifyResponse.setMessage("Signature Verification Passed");
                                verifyResponse.setJwsState("VALID");
                            } else {
                                verifyResponse.setSuccess(true);  // Request succeeded, but signature invalid
                                verifyResponse.setMessage("Signature Verification Failed");
                                verifyResponse.setJwsState("INVALID");
                            }

                            out.println(gson.toJson(verifyResponse));
                            return;


                        } catch (Exception e) {
                            EncodedMessage errorResponse = new EncodedMessage();
                            errorResponse.setSuccess(false);
                            errorResponse.setOperation("ec_verify");
                            errorResponse.setErrorMessage("Error verifying signature: " + e.getMessage());
                            out.println(gson.toJson(errorResponse));
                        }finally {

                            if(post!=null)
                            {
                                post.releaseConnection();
                            }

                        }

                    }


                }else{
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_verify");
                    errorResponse.setErrorMessage("EC Public Key cannot be empty for signature verification.");
                    out.println(gson.toJson(errorResponse));
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

            // Validate message
            if (null == message || message.trim().length() == 0) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("encrypt".equalsIgnoreCase(encryptdecryptparameter) ? "ec_encrypt" : "ec_decrypt");
                errorResponse.setErrorMessage("Message is required. Please enter a message to encrypt or decrypt.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ec/ecencryptdecrypt";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();


            if ("encrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                if (null == privateKeParam || privateKeParam.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_encrypt");
                    errorResponse.setErrorMessage("For Encryption, EC Private Key of Alice is required.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (null == publickeyparamb || publickeyparamb.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_encrypt");
                    errorResponse.setErrorMessage("For Encryption, Public Key of Bob is required.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                urlParameters.add(new BasicNameValuePair("p_publicKey", publickeyparamb));
                urlParameters.add(new BasicNameValuePair("p_privatekey", privateKeParam));
            }

            if ("decrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                if (null == privatekeyparamb || privatekeyparamb.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_decrypt");
                    errorResponse.setErrorMessage("For Decryption, EC Private Key of Bob is required.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                if (null == publiKeyParam || publiKeyParam.trim().length() == 0) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_decrypt");
                    errorResponse.setErrorMessage("For Decryption, Public Key of Alice is required.");
                    out.println(gson.toJson(errorResponse));
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
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("ec_decrypt");
                    errorResponse.setErrorMessage("For Decryption, please input a valid Base64 encoded message.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                urlParameters.add(new BasicNameValuePair("p_publicKey", publiKeyParam));
                urlParameters.add(new BasicNameValuePair("p_privatekey", privatekeyparamb));
            }

            urlParameters.add(new BasicNameValuePair("p_msg", message));
            urlParameters.add(new BasicNameValuePair("p_encryptDecrypt", encryptdecryptparameter));
            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            try {
                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("encrypt".equalsIgnoreCase(encryptdecryptparameter) ? "ec_encrypt" : "ec_decrypt");

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
                        errorResponse.setErrorMessage("System Error: " + content.toString());
                    } else {
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    }
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

                EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);

                if ("decrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                    EncodedMessage successResponse = new EncodedMessage();
                    successResponse.setSuccess(true);
                    successResponse.setOperation("ec_decrypt");
                    successResponse.setMessage(encodedMessage.getMessage());
                    successResponse.setOriginalMessage(message);
                    out.println(gson.toJson(successResponse));
                    return;
                }

                if ("encrypt".equalsIgnoreCase(encryptdecryptparameter)) {
                    EncodedMessage successResponse = new EncodedMessage();
                    successResponse.setSuccess(true);
                    successResponse.setOperation("ec_encrypt");
                    successResponse.setBase64Encoded(encodedMessage.getBase64Encoded());
                    successResponse.setIntialVector(encodedMessage.getIntialVector());
                    successResponse.setOriginalMessage(message);
                    out.println(gson.toJson(successResponse));
                    return;
                }
            } catch (Exception e) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("encrypt".equalsIgnoreCase(encryptdecryptparameter) ? "ec_encrypt" : "ec_decrypt");
                errorResponse.setErrorMessage("Error: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            } finally {
                if (post != null) {
                    post.releaseConnection();
                }
            }

        }
    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}