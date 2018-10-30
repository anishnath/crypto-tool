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
 * Created by ANish Nath on 28/09/18.
 */
public class JWKFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATEJWK = "CALCULATE_JWK";

    private static final String METHOD_CONVERT_JWK = "CONVERT_JWK";




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

        String nextJSP = "/jwkfunctions.jsp";
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


        String publiKeyParam = request.getParameter("param");
        final String methodName = request.getParameter("methodName");

        if(Utils.vaildate())
        {
            addHorizontalLine(out);
            out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License </font>");
            return;
        }


        if (METHOD_CALCULATEJWK.equalsIgnoreCase(methodName)) {

            if (publiKeyParam == null || publiKeyParam.length() == 0) {
                publiKeyParam = "0";
            }

            publiKeyParam = publiKeyParam.trim();

                    try {

                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jwk/generatekey";
                        HttpPost post = new HttpPost(url1);
                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_param", publiKeyParam));

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


                        addHorizontalLine(out);
                       // System.out.println("encodedMessage-- " + encodedMessage);
                        out.println("<textarea class=\"form-control\" name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"8\" cols=\"40\">" + content1.toString() + "</textarea>");
                        return;


                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> " + e);
                    }


                }

        if (METHOD_CONVERT_JWK.equalsIgnoreCase(methodName)) {

            String param = request.getParameter("param");
            String input = request.getParameter("input");


            if(null==input || input.trim().length()==0)
            {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Input is Null or EMpty....</font>");
                return;
            }

            if("JWK-to-PEM".equalsIgnoreCase(param))
            {
                if(input.contains("BEGIN") &&  input.contains("END")  &&  input.contains("RSA") )
                {

                    String url1 = "http://localhost:8082/crypto/rest/jwk/convertpemtojwk";
                    generateToPem(out, input,url1); ;

                    return;
                }

                if (input.contains("kty") && input.contains("{") && input.contains("}"))

                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "jwk/convertjwktopem";
                    generateToPem(out, input,url1); ;
                }

                else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Not a JWK Key Please input a valid JWK Key</font>");
                    return;
                }

            }

            if("PEM-to-JWK".equalsIgnoreCase(param))
            {
                if(input.contains("BEGIN") &&  input.contains("END")  &&  input.contains("---") )
                {

                    String url1 = "http://localhost:8082/crypto/rest/jwk/convertpemtojwk";
                    generateToPem(out, input,url1); ;

                    return;
                }

                if (input.contains("kty") && input.contains("{") && input.contains("}"))

                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "jwk/convertjwktopem";
                    generateToPem(out, input,url1); ;
                }

                else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Not a ValiD RSA PEM Format</font>");
                    return;
                }

            }


        }

        }

    private void generateToPem(PrintWriter out, String input,String url1) {
        try {

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            //String url1 = "http://localhost:8082/crypto/rest/jwk/convertjwktorsa";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_param", input));

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




            if(url1.contains("convertjwktopem")) {

                jwkpojo jwkpojo = gson.fromJson(content1.toString(), jwkpojo.class);
                addHorizontalLine(out);
                // System.out.println("encodedMessage-- " + encodedMessage);

                if(jwkpojo.getPublicKey()!=null) {
                    out.println("<textarea class=\"form-control\" readonly=\"true\" name=\"rsaprublickey\" id=\"rsaprublickey\" rows=\"4\" cols=\"40\">"  + jwkpojo.getPublicKey() + "</textarea>");
                }

                if(jwkpojo.getPrivateKey()!=null) {
                    out.println("<textarea class=\"form-control\" readonly=\"true\" name=\"rsaprivatekey\" id=\"rsaprivatekey\" rows=\"10\" cols=\"40\">"  + jwkpojo.getPrivateKey() + "</textarea>");
                }

            }

            else{

                out.println("<textarea class=\"form-control\" readonly=\"true\" name=\"encrypedmessagetextarea\" id=\"encrypedmessagetextarea\" rows=\"8\" cols=\"40\">" + content1.toString() + "</textarea>");

            }


          //  out.println(j);
            return;



        } catch (Exception e) {
            addHorizontalLine(out);
            out.println("<font size=\"4\" color=\"red\"> " + e);
        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


}
