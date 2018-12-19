package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.crypto.*;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.security.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

/**
 * @author  Anish Nath
 * Demo at 8gwifi.org
 */

public class NaclFunctionality extends HttpServlet {

    private static final String METHOD_CIPHERBLOCK_NEW = "NACL_crypto_stream_xsalsa20_xor";




    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("naclencdec.jsp");
        dispatcher.forward(request, response);


        return;

    }


    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        final String methodName = request.getParameter("methodName");
        PrintWriter out = response.getWriter();

        if (METHOD_CIPHERBLOCK_NEW.equalsIgnoreCase(methodName)) {

            String secretkey = request.getParameter("secretkey");
            final String encryptorDecrypt = request.getParameter("encryptorDecrypt");
            final String plaintext = request.getParameter("plaintext");
            //plaintext
            //cipherparameter
            final String nonce = request.getParameter("nonce");


            if (null == secretkey || secretkey.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Secret Key is null or empty </font>");
                return;
            }

            if(secretkey!=null && secretkey.length() !=32 )
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Secret Key Must be length of 32 </font>");
                return;
            }

            if (null == plaintext || plaintext.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Text is null or empty </font>");
                return;
            }

            if (null == nonce || nonce.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Noce is EMpty or Null</font>");
                return;
            }

            if(nonce!=null && nonce.trim().length()<48)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Nonce is Invalid It must be 24 bit in Hex</font>");
                return;
            }


            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "nacl/encrypt";

            if ("decrypt".equalsIgnoreCase(encryptorDecrypt)) {
                url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "nacl/decrypt";

            }

            HttpPost post = new HttpPost(url1);

            List<NameValuePair> urlParameters = new ArrayList<>();
            urlParameters.add(new BasicNameValuePair("p_msg", plaintext));
            urlParameters.add(new BasicNameValuePair("p_nonce", nonce));
            urlParameters.add(new BasicNameValuePair("p_key", secretkey));


            try {
//
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


                addHorizontalLine(out);


                String msg = "Encrypted Message in Hex";

                if("decrypt".equalsIgnoreCase(encryptorDecrypt))
                {
                    msg = "Decrypted Message";
                }

                out.println( "<font size=\"4\" color=\"blue\">  " +msg + "  </font><br/><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=true id=\"encrypedmessagetextarea\" rows=\"5\" cols=\"5\">" + content.toString() + "</textarea></br>");

                return;


            } catch (Exception e) {
                out.println("<font size=\"4\" color=\"red\"> " + e + " </font>");
            }


            return;

        }
    }




    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }




}
