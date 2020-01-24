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

    private static final String METHOD_CONVERT_JWK = "CONVERT_JWK";

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
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }
}
