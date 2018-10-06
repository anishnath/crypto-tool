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
public class OCSPFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATE_OCSP = "CALCULATE_OCSP";




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

                String nextJSP = "/ocsp.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        //System.out.println("algo" + algo);
        PrintWriter out = response.getWriter();


        String pem_1 = request.getParameter("p_pem1");
        String pem_2 = request.getParameter("p_pem2");
        String methodName = request.getParameter("methodName");


        //

//        System.out.println("publiKeyParam " + publiKeyParam);
//        System.out.println("privateKeParam " + privateKeParam);
        // System.out.println("message " + message);
//        System.out.println("algo " + algo);
//        System.out.println("keysize " + keysize);
//        System.out.println("encryptdecryptparameter " + encryptdecryptparameter);
//        System.out.println("methodName " + methodName);


        if (METHOD_CALCULATE_OCSP.equalsIgnoreCase(methodName)) {

            if (pem_1 == null || pem_1.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Server Certifictae is EMpty or Null.</font>");
                return;
            }

            if (pem_2 == null || pem_2.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Chain Certifictae is EMpty or Null.</font>");
                return;
            }


            if(!pem_1.contains("BEGIN CERTIFICATE") && !pem_1.contains("END CERTIFICATE"))
            {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Server Certifictae is not PEM format</font>");
                return;
            }

            if(!pem_2.contains("BEGIN CERTIFICATE") && !pem_2.contains("END CERTIFICATE"))
            {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Chain Certifictae is not PEM format</font>");
                return;
            }




                    try {


                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "ocsp/query";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_pem1", pem_1));
                        urlParameters.add(new BasicNameValuePair("p_pem2", pem_2));
                       // urlParameters.add(new BasicNameValuePair("p_algo", algo));

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

                        ocsppojo encodedMessage = gson.fromJson(content1.toString(), ocsppojo.class);
                        addHorizontalLine(out);
                        out.println("<table class=\"table\">");
                        out.println("<tr>");
                        out.println("<td>");
                        out.println(encodedMessage.getOcspurl()+"<br>");
                        out.println("</td>");
                        out.println("<td>");
                        out.println("<font size=\"5\" color=\"green\">Cert Status " + encodedMessage.getCertstatus()+" </font></br>");
                        out.println("</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("</td>");
                        out.println("<textarea name=\"decryptedmessagetextarea\" id=\"decryptedmessagetextarea\" rows=\"5\" cols=\"40\">" + encodedMessage.getOcsprequest()+ "</textarea>");
                        out.println("</td>");
                        out.println("</td>");
                        out.println("<textarea name=\"decryptedmessagetextarea\" id=\"decryptedmessagetextarea\" rows=\"5\" cols=\"40\">" + encodedMessage.getOcspresponse()+ "</textarea>");
                        out.println("</td>");
                        out.println("</tr>");
                        out.println("</table>");
                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }

                }



    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


}
