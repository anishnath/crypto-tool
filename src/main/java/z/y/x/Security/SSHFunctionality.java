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


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */
public class SSHFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_GENERATE_SSHKEYGEN = "GENERATE_SSHKEYGEN";




    public SSHFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub


        final String methodName = request.getParameter("methodName");


        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (METHOD_GENERATE_SSHKEYGEN.equals(methodName)) {
            String algo = request.getParameter("sshalgo");
            String keysize = request.getParameter("sshkeysize");
            String passphrase = request.getParameter("passphrase");


            if (algo == null || algo.trim().length() == 0) {
                algo="RSA";
            }

            if(passphrase!=null && passphrase.trim().length()>20)
            {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\">password length should be less than 20 </font>");
                return;
            }


            int keySize=2048;
            if(keysize == null || keysize.trim().length()==0)
            {
                keySize=2048 ;
            }

            try {
                keySize= Integer.parseInt(keysize);
            } catch(Exception e) {
                keySize=2048 ;
            }


            algo = algo.trim().toUpperCase();

            if(algo.equals("RSA") || algo.equals("DSA")  || algo.equals("ECDSA")  )
            {

                if(algo.equals("ECDSA"))
                {
                    if( keySize==256 || keySize==384 || keySize==521  )
                    {
                        //DO Nothing
                    }
                    else{
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> valid Key size for  ECDSA is (256,384,521)  </font>");
                        return;
                    }

                    }
                }
                if(algo.equals("DSA"))
                {
                    if( "512,576,640,704,768,832,896,960,1024,2048".contains(keysize)  )
                    {
                        //DO Nothing
                    }
                    else{

                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> valid Key size for  DSA is (512,576,640,704,768,832,896,960,1024,2048)   </font>");
                        return;


                    }
                }


            try {

                Gson gson = new Gson();
                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "ssh/keygen";

                //System.out.println(url1);

                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                post.addHeader("accept", "application/json");


                urlParameters.add(new BasicNameValuePair("p_keysize", keysize));
                urlParameters.add(new BasicNameValuePair("p_algo", algo));
                urlParameters.add(new BasicNameValuePair("p_passphrase", passphrase));


                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(post);

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

                sshpojo sshpojo = gson.fromJson(content.toString(), sshpojo.class);
                if(sshpojo!=null) {
                    out.println("<font size=\"4\" color=\"green\"> <b><u>SSH-keygen for [" + sshpojo.getAlgo() + "-" + sshpojo.getKeySize() + "]  (PrivateKey/PublicKey) </b></u> <br>");
                    out.println("<font size=\"3\" color=\"red\"> FingerPrint [" + sshpojo.getFingerprint() + "]</font> <br>");
                    out.println("<p>Private Key</p>");
                    out.println("<textarea readonly class=\"form-control\" name=\"comment\" rows=\"20\" cols=\"30\" form=\"X\">" + sshpojo.getPrivateKey() + "</textarea>");
                    out.println("<br>");
                    out.println("<p>Public Key</p>");
                    out.println("<textarea readonly class=\"form-control\" name=\"comment\" rows=\"10\" cols=\"30\" form=\"y\">" + sshpojo.getPublicKey() + "</textarea>");
                }

            }catch (Exception ex)
            {
                out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request" + ex +" </font>");
            }


        }


    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
