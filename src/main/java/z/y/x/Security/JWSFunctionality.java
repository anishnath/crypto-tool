package z.y.x.Security;

import com.google.gson.Gson;
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
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by aninath on 24/01/20.
 */
public class JWSFunctionality extends HttpServlet {

    private static final String METHOD_GENERATE_JSONKEY = "GENERATE_JSONKEY";

    private static final String METHOD_SIGN_JSON = "SIGN_JSON";
    private static final String METHOD_PARSE_JWS = "PARSE_JWS";

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        //out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

        String nextJSP = "/jwsgen.jsp";
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
        dispatcher.forward(request, response);

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        //System.out.println("algo" + algo);
        PrintWriter out = response.getWriter();



        final String methodName = request.getParameter("methodName");

        if (METHOD_PARSE_JWS.equalsIgnoreCase(methodName)) {

            String serialized = request.getParameter("serialized");

            if (serialized == null || serialized.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> JWS Seriazed Object is Null or EMpty....</font>");
                return;
            }

            final String t =serialized.trim();

            final int dot1 = t.indexOf(".");
            if (dot1 == -1) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> JWS Seriazed Object is Not Valid....</font>");
                return;
            }

            final int dot2 = t.indexOf(".", dot1 + 1);
            if (dot2 == -1) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> JWS Seriazed Object is Not Valid....</font>");
                return;
            }

            try {

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/parse";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_serialzed", serialized));


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

                jwspojo jwspojo = gson.fromJson(content.toString(), jwspojo.class);

                if(jwspojo.getHeader()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Header</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getHeader() + "</textarea>");
                }


                if(jwspojo.getPayload()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Payload</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + jwspojo.getPayload() + "</textarea>");
                }

                if(jwspojo.getSignature()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Singature</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=4  form=\"X\">" + jwspojo.getSignature() + "</textarea>");
                }


                if(jwspojo.getState()!=null)
                {
                    out.println("<h4 class=\"mt-4\">State</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getState() + "</textarea>");
                }


                return;



            }catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> " + e);
            }



        }

        if (METHOD_GENERATE_JSONKEY.equalsIgnoreCase(methodName)) {
            String algo = request.getParameter("algo");
            String payload = request.getParameter("payload");

            if (algo == null || algo.length() == 0) {
                algo = "HS256";
            }

            if (payload == null || payload.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Payload is Null or EMpty....</font>");
                return;
            }

            try {

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/generatekey";
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_payload", payload));

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

                jwspojo jwspojo = gson.fromJson(content.toString(), jwspojo.class);

                if(jwspojo.getHeader()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Header</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getHeader() + "</textarea>");
                }

                if(jwspojo.getState()!=null)
                {
                    out.println("<h4 class=\"mt-4\">State</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getState() + "</textarea>");
                }

                if(jwspojo.getSerialize()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Serialize</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=5  form=\"X\">" + jwspojo.getSerialize() + "</textarea>");
                }

                if(jwspojo.getSignature()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Singature</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=4  form=\"X\">" + jwspojo.getSignature() + "</textarea>");
                }


                if(jwspojo.getSharedSecret()!=null)
                {
                    out.println("<h4 class=\"mt-4\">SharedSecret (Generated for MAC key (Base64 encoded))</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getSharedSecret() + "</textarea>");
                }

                if(jwspojo.getPrivateKey()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Private Key</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + jwspojo.getPrivateKey() + "</textarea>");
                }

                if(jwspojo.getPublicKey()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Public Key</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + jwspojo.getPublicKey() + "</textarea>");
                }

                return;



            }catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> " + e);
            }


        }

        if (METHOD_SIGN_JSON.equalsIgnoreCase(methodName)) {

            String algo = request.getParameter("algo");
            String payload = request.getParameter("payload");
            String sharedsecret = request.getParameter("sharedsecret");
            String key = request.getParameter("key");




            if (algo == null || algo.length() == 0) {
                algo = "HS256";
            }

            if (payload == null || payload.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Payload is Null or EMpty....</font>");
                return;
            }

            if(algo.equalsIgnoreCase("HS256") || algo.equalsIgnoreCase("HS384") || algo.equalsIgnoreCase("HS512")) {
                if (sharedsecret == null || sharedsecret.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Shared secret is Null or EMpty....</font>");
                    return;
                }

                if(sharedsecret.length()< 384)
                {
                    if(algo.equalsIgnoreCase("HS384"))
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> shared secret length is too small for HS384 it should be minimum of 48byte </font>");
                        return;
                    }
                }

                if(sharedsecret.length()> 384 && sharedsecret.length()<512)
                {
                    if(algo.equalsIgnoreCase("H512"))
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> shared secret length is too small for H512 it should be minimum of 64byte </font>");
                        return;
                    }
                }

                if(algo.equalsIgnoreCase("RS256") || algo.equalsIgnoreCase("RS384") || algo.equalsIgnoreCase("RS512") || algo.equalsIgnoreCase("PS256") || algo.equalsIgnoreCase("PS384") || algo.equalsIgnoreCase("PS512") )
                {
                    if (key == null || key.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\">PEM key is Null or EMpty....</font>");
                        return;
                    }

                        if (!(key.contains("BEGIN PRIVATE KEY") && key.contains("END PRIVATE KEY")) || !(key.contains("BEGIN RSA PRIVATE KEY") && key.contains("END RSA PRIVATE KEY"))) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">Private key is Not Valid Check the format....</font>");
                            return;

                        }


                }

                if(algo.equalsIgnoreCase("ES256") || algo.equalsIgnoreCase("ES384") || algo.equalsIgnoreCase("ES512") ) {
                    if (key == null || key.trim().length() == 0) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\">PEM key is Null or EMpty....</font>");
                        return;
                    }

                        if (!(key.contains("BEGIN EC PRIVATE KEY") && key.contains("END EC PRIVATE KEY"))) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">Private key is Null or EMpty....</font>");
                            return;
                        }


                }
            }


            try {

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();
                String url1 =LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "jws/sign";;
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_payload", payload));
                urlParameters.add(new BasicNameValuePair("p_sharedsecret", sharedsecret));
                urlParameters.add(new BasicNameValuePair("p_key", key));

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

                jwspojo jwspojo = gson.fromJson(content.toString(), jwspojo.class);

                if(jwspojo.getHeader()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Header</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getHeader() + "</textarea>");
                }

                if(jwspojo.getState()!=null)
                {
                    out.println("<h4 class=\"mt-4\">State</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getState() + "</textarea>");
                }

                if(jwspojo.getSerialize()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Serialize</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=5  form=\"X\">" + jwspojo.getSerialize() + "</textarea>");
                }

                if(jwspojo.getSignature()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Singature</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=4  form=\"X\">" + jwspojo.getSignature() + "</textarea>");
                }


                if(jwspojo.getSharedSecret()!=null)
                {
                    out.println("<h4 class=\"mt-4\">SharedSecret (Generated for MAC key (Base64 encoded))</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=1  form=\"X\">" + jwspojo.getSharedSecret() + "</textarea>");
                }

                if(jwspojo.getPrivateKey()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Private Key</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + jwspojo.getPrivateKey() + "</textarea>");
                }

                if(jwspojo.getPublicKey()!=null)
                {
                    out.println("<h4 class=\"mt-4\">Public Key</h4>");
                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + jwspojo.getPublicKey() + "</textarea>");
                }

                return;



            }catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> " + e);
            }



        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }
}
