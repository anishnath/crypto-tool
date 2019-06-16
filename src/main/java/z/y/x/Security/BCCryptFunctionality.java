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

/**
 * Created by aninath on 11/16/17.
 */
public class BCCryptFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_HASH_BCCRYPT = "CALCULATE_BCCRYPT";
    private static final String METHOD_HASH_SCRYPT = "CALCULATE_SCRYPT";
    private static final String METHOD_CHECK_PASSWORD = "METHOD_CHECK_PASSWORD";



    public BCCryptFunctionality() {

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




        PrintWriter out = response.getWriter();


        if(Utils.vaildate())
        {
            addHorizontalLine(out);
            out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License <p>\n" +
                    "<a href=\"mailto:zarigatongy@gmail.com?Subject=Crypto License Required\" target=\"_top\">zarigatongy@gmail.com</a>\n" +
                    "</p>\n </font>");
            return;
        }

        if (METHOD_HASH_BCCRYPT.equals(methodName)) {
            final String password = request.getParameter("password");
            final String workload = request.getParameter("workload");

            if (password == null || password.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Password is Empty </font>");
                return;
            }


            int rs = 5;
            try {
                rs = Integer.parseInt(workload);
                if (rs > 13) {
                    out.println("<font size=\"2\" color=\"red\"> The System support only 13 round </font>");
                    return;
                }
            } catch (NumberFormatException nfe) {
                rs = 5;
            }
            String hashpassword = JBCryptUtil.hashPassword(password, rs);
            out.println("<font size=\"4\" color=\"green\"> Hash Password ["
                    + hashpassword + "]</font><br/>");
            addHorizontalLine(out);

            StringBuilder builder = new StringBuilder();
            builder.append("<font size=\"2\" color=\"green\">Bcrypt="
                    + hashpassword.substring(0, 4) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Round="
                    + hashpassword.substring(4, 6) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Salt="
                    + hashpassword.substring(7, 29) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Hash="
                    + hashpassword.substring(29, hashpassword.length()) + "</font><br/>");

            out.println(builder.toString());


            //Validate Password
            String passwordhash = request.getParameter("hash");

            if (null == passwordhash || passwordhash.trim().length() == 0) {

                return;
            }

            if (null == password || password.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Password is Empty </font>");
                return;
            }

            if (passwordhash.length() < 5) {
                out.println("<br/><font size=\"2\" color=\"red\"> Invalid BCCrypt Hash </font>");
                return;
            }

            if ("$2a$".equals(passwordhash.substring(0, 4)) || "$2y$".equals(passwordhash.substring(0, 4)) || "$2b$".equals(passwordhash.substring(0, 4))) {
                boolean x = JBCryptUtil.checkPassword(password, passwordhash);

                if (x) {


                    addHorizontalLine(out);

                    builder.append("<font size=\"5\" color=\"green\"> Hash Verification Passed [" + passwordhash +
                            "]</font>");
                    builder.append("<hr>");

                    out.println(builder.toString());
                    return;
                } else {
                    out.println("<font size=\"4\" color=\"red\"> Hash Verification failed </font>");
                    return;
                }

            } else {
                out.println("<br/><font size=\"4\" color=\"red\"> Invalid BCCrypt Hash </font>");
                return;
            }

        }


        if (METHOD_HASH_SCRYPT.equals(methodName)) {

            final String password = request.getParameter("password");
            final String workparam = request.getParameter("workparam");
            final String memoryparam = request.getParameter("memoryparam");
            final String parallelizationparam = request.getParameter("parallelizationparam");
            final String length = request.getParameter("length");
            final String salt = request.getParameter("salt");
            final String hash = request.getParameter("hash");

            if (password == null || password.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Password is Empty </font>");
                return;
            }

            if (salt == null || salt.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> (S) salt is Empty or Null </font>");
                return;
            }

            if (workparam == null || workparam.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> N Empty </font>");
                return;
            }

            if (memoryparam == null || memoryparam.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> R is Empty or Null </font>");
                return;
            }

            if (parallelizationparam == null || parallelizationparam.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> P is Empty or Null </font>");
                return;
            }

            if (length == null || length.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Output Length is Empty or Null </font>");
                return;
            }



//            if (rawPassphrase == null || rawPassphrase.trim().length() == 0) {
//                return Response.status(Response.Status.NOT_FOUND)
//                        .entity(String.format("p_n %s rawPassphrase EMpty or Null ", paralleliZation)).build();
//            }

            final int cpuCost;
            final int memoryCost;
            final int parallelization;
            final int keylength;

            try {
                cpuCost = Integer.parseInt(workparam);
            } catch (NumberFormatException e) {
                out.println("<font size=\"2\" color=\"red\"> N must be Integer </font>");
                return;

            }

            try {
                memoryCost = Integer.parseInt(memoryparam);
            } catch (NumberFormatException e) {
                out.println("<font size=\"2\" color=\"red\"> R must be Integer </font>");
                return;

            }

            try {
                parallelization = Integer.parseInt(parallelizationparam);
            } catch (NumberFormatException e) {
                out.println("<font size=\"2\" color=\"red\"> P must be Integer </font>");
                return;

            }

            try {
                keylength = Integer.parseInt(length);

                if(keylength>3000)
                {
                    out.println("<font size=\"2\" color=\"red\"> Max Supported keyLength 3000 </font>");
                    return;

                }
            } catch (NumberFormatException e) {
                out.println("<font size=\"2\" color=\"red\"> Key Length Must be Integer </font>");
                return;

            }

            if (cpuCost <= 1) {
                out.println("<font size=\"2\" color=\"red\"> N must be >1  </font>");
                return;

            }

            if (!isPowerOf2(cpuCost)) {
                out.println("<font size=\"2\" color=\"red\"> Cost parameter N must be > 1 and a power of 2 "+ cpuCost + " </font>");
                return;
            }

            if (memoryCost == 1 && cpuCost > 65536) {
                out.println("<font size=\"2\" color=\"red\"> N Cpu cost parameter N must be > 1 and < 65536  </font>");
                return;


            }
            if (memoryCost < 1) {
                out.println("<font size=\"2\" color=\"red\"> R must must be >= 1 </font>");
                return;


            }
            int maxParallel = Integer.MAX_VALUE / (128 * memoryCost * 8);
            if (parallelization < 1 || parallelization > maxParallel) {
                out.println("<font size=\"2\" color=\"red\"> Parallelisation parameter p must be >= 1 and <= \"\n" +
                        "                       " + maxParallel + "\" (based on block size r of \" "+ memoryCost + "\")\" </font>");
                return;


            }
            if (keylength < 1 || keylength > Integer.MAX_VALUE) {
                out.println("<font size=\"2\" color=\"red\"> Key length must be >= 1 and <= \" "+ Integer.MAX_VALUE  +"</font>");

                return;

            }

            final int saltLength = salt.length();

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();


            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "scrypt/generatehash";



            List<NameValuePair> urlParameters = new ArrayList<>();

            if(hash!=null && hash.trim().length()>0) {
                urlParameters.add(new BasicNameValuePair("p_rawpassphrase", hash));
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "scrypt/verifyhash";
            }
            urlParameters.add(new BasicNameValuePair("p_passphrase", password));
            urlParameters.add(new BasicNameValuePair("p_salt", salt));

            urlParameters.add(new BasicNameValuePair("p_n", workparam));
            urlParameters.add(new BasicNameValuePair("p_r", memoryparam));
            urlParameters.add(new BasicNameValuePair("p_p", parallelizationparam));
            urlParameters.add(new BasicNameValuePair("p_outputlength", length));

            try {

                HttpPost post = new HttpPost(url1);
                post.setEntity(new UrlEncodedFormEntity(urlParameters));
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
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.append(content);
                        out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + stringBuilder + "</font>");
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

                EncodedMessage certpojo1 = gson.fromJson(content.toString(), EncodedMessage.class);
                addHorizontalLine(out);
                if(hash==null || hash.trim().length()==0)
                {

                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"green\">  Hash Password </font>   <br/>");
                    out.println("<textarea name=\"encrypedmessagetextarea\" readonly=true id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + certpojo1.getBase64Encoded() + "</textarea>");


                }
                else
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"green\"> RAW Hash Password</font>   <br/> <textarea name=\"encrypedmessagetextarea\" readonly=true id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + certpojo1.getBase64Encoded() + "</textarea>");
                    out.println("<font size=\"4\" color=\"green\">  [" + certpojo1.getMessage() +   "]<br/>");
                }





            }catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " +e +" </font>");
            }







        }

    }

    private static boolean isPowerOf2(int x) {
        return ((x & (x - 1)) == 0);
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
