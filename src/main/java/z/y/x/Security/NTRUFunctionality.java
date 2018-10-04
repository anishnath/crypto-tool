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
public class NTRUFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATERSA = "CALCULATE_NTRU";
    private static final String METHOD_GENERATE_KEYS = "GENERATE_KEYS";





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

        String nextJSP = "/ntrufunctions.jsp";
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
        dispatcher.forward(request, response);
        return;


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
 //       System.out.println("methodName " + methodName);


        if (METHOD_GENERATE_KEYS.equalsIgnoreCase(methodName)) {

            String password = request.getParameter("password");
            String salt = request.getParameter("salt");
            String ntruparam= request.getParameter("ntruparam");

            request.getSession().setAttribute("errorMsg","");

            try
            {

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 = "http://localhost/ntru/rest/ntru/generatekeypair";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_password", password));
                urlParameters.add(new BasicNameValuePair("p_ntru", ntruparam));
                urlParameters.add(new BasicNameValuePair("p_salt", salt));

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
                        request.getSession().setAttribute("errorMsg",content1);
                        request.getSession().setAttribute("pubkey", "");
                        request.getSession().setAttribute("privKey", "");
                        request.getSession().setAttribute("ntru", ntruparam);
                        String nextJSP = "/ntrufunctions.jsp";
                        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                        dispatcher.forward(request, response);

                        return;
                    } else {
                        request.getSession().setAttribute("errorMsg"," SYSTEM Error Please Try Later If Problem Persist raise the feature request");
                        request.getSession().setAttribute("pubkey", "");
                        request.getSession().setAttribute("privKey", "");
                        request.getSession().setAttribute("ntru", ntruparam);
                        String nextJSP = "/ntrufunctions.jsp";
                        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                        dispatcher.forward(request, response);
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

                ntrupojo encodedMessage = gson.fromJson(content1.toString(), ntrupojo.class);

                request.getSession().setAttribute("pubkey", encodedMessage.getPublickey());
                request.getSession().setAttribute("privKey", encodedMessage.getPrivatekey());
                request.getSession().setAttribute("ntru", ntruparam);
                String nextJSP = "/ntrufunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);


                return;

            }catch (Exception e)
            {
                request.getSession().setAttribute("pubkey", null);
                request.getSession().setAttribute("privKey", null);
                request.getSession().setAttribute("keysize", keysize);
                String nextJSP = "/ntrufunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);
                return;

            }



        }

        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {


            String p_ntru= request.getParameter("p_ntru");

            System.out.println("p_ntru-- " + p_ntru);

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
                        String url1 = "http://localhost/ntru/rest/ntru/encrypt";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_key", publiKeyParam));
                        urlParameters.add(new BasicNameValuePair("p_ntru", p_ntru ));

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

                        ntrupojo encodedMessage = gson.fromJson(content1.toString(), ntrupojo.class);
                        addHorizontalLine(out);
                        // System.out.println("encodedMessage-- " + encodedMessage);
                        out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"50\">" + encodedMessage.getMessage() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }

                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + " Public Key Can't be EMPTY for NTRU Encryption </font>");

                }
            } else {


                String encrypedmessagetextarea = request.getParameter("encrypedmessagetextarea");


                if (privateKeParam != null && privateKeParam.trim().length() > 0) {


                    if (publiKeyParam == null || publiKeyParam.trim().length() == 0)
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"3\" color=\"red\"> " + " NTRU  Public Key Can't be EMPTY .. </font>");
                        return;
                    }

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
                        String url1 = "http://localhost/ntru/rest/ntru/decrypt";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", message));
                        urlParameters.add(new BasicNameValuePair("p_key", publiKeyParam));
                        urlParameters.add(new BasicNameValuePair("p_privkey", privateKeParam));
                        urlParameters.add(new BasicNameValuePair("p_ntru", p_ntru));

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

                        ntrupojo encodedMessage = gson.fromJson(content1.toString(), ntrupojo.class);
                        addHorizontalLine(out);
                        out.println("<textarea name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"50\">" + encodedMessage.getMessage() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
                    }


                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + "  NTRU  Private Key Can't be EMPTY </font>");
                }
            }
        }

    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


}
