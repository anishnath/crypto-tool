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
import org.bouncycastle.jce.provider.BouncyCastleProvider;

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
public class PGPFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String GENERATE_PGEP_KEY = "GENERATE_PGEP_KEY";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public PGPFunctionality() {

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

        if (GENERATE_PGEP_KEY.equals(methodName)) {
            String p_identity = request.getParameter("p_identity");
            String p_passpharse = request.getParameter("p_passpharse");
            String cipherparameter = request.getParameter("cipherparameter");
            String p_keysize = request.getParameter("p_keysize");


            if (p_identity == null || p_identity.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Identity is Null Associate a Name or Email</font>");
                return;
            }

            p_identity = p_identity.trim();

            Pattern p = Pattern.compile("[^a-z0-9@. ]", Pattern.CASE_INSENSITIVE);
            Matcher m = p.matcher(p_identity);
            boolean b = m.find();

            if (b) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Invalid Indentity Name No Special Chanacters</font>");
                return;
            }


            if (p_passpharse == null || p_passpharse.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Passphrase is EMpty or Null </font>");
                return;
            }


            p_passpharse = p_passpharse.trim();

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1="http://localhost/crypto/rest/pgp/pgpkeygen";
            HttpPost post = new HttpPost(url1);


            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_keysize", p_keysize));
            urlParameters.add(new BasicNameValuePair("p_identity", p_identity));
            urlParameters.add(new BasicNameValuePair("p_passpharse", p_passpharse));
            urlParameters.add(new BasicNameValuePair("p_algo", cipherparameter));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));


            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
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

            pgppojo pgp = gson.fromJson(content.toString(),pgppojo.class);
            out.println("<b><u>PGP Key Information for Identity  [" + p_identity + "] (Private Key/Public Key)  </b></u> <br>");
            out.println( "<textarea name=\"comment\" rows=\"30\" cols=\"60\" form=\"X\">" +pgp.getPrivateKey() +  "</textarea>");
            out.println( "<textarea name=\"comment\" rows=\"30\" cols=\"60\" form=\"y\">" +pgp.getPubliceKey() +  "</textarea>");

            addHorizontalLine(out);


        }
    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
