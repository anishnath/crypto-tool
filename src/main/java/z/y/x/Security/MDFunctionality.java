package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import z.y.x.r.ColorCodeOnStartupFunctionality;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.Security;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

/**
 * Servlet implementation class MD5Calculator and HMAC Generator Anish Nath
 */
public class MDFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String METHOD_CALCULATEMD5 = "CALCULATE_MD";
    private static final String METHOD_GENERATE_HMAC = "GENERATE_HMAC";



    ;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MDFunctionality() {
        super();
        // TODO Auto-generated constructor stub
    }

    public static String CalcualateMD5(final String algo, final String inputText, final String provider) {
        final StringBuffer sb = new StringBuffer();
        if (algo != null && !algo.isEmpty()) {
            if (METHOD_CALCULATEMD5.equals(algo))
                return "";
            if (inputText != null && !inputText.isEmpty()) {
                MessageDigest md = null;
                try {
                    if (provider != null) {
                        md = MessageDigest.getInstance(algo, provider);
                    } else {
                        md = MessageDigest.getInstance(algo);
                    }

                } catch (Exception e) {
                    //System.out.println(e);
                    return e.getMessage();
                }
                md.update(inputText.getBytes());
                byte[] mdbytes = md.digest();
                // convert the byte to hex format method 1

                for (int i = 0; i < mdbytes.length; i++) {
                    sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16)
                            .substring(1));
                }


                String getColor = ColorCodeOnStartupFunctionality.getRandomColor();
                String color = "<font color=" + getColor + ">";
                sb.append(color);
                sb.append("<br>Digest Length=");
                sb.append(md.getDigestLength());
                sb.append("</font>");
                getColor = ColorCodeOnStartupFunctionality.getRandomColor();
                color = "<font color=" + getColor + ">";
                sb.append(color);
                sb.append(System.getProperty("line.separator"));
                sb.append("Digest Algo=");
                sb.append(md.getAlgorithm());
                sb.append("</font>");
                getColor = ColorCodeOnStartupFunctionality.getRandomColor();
                color = "<font color=" + getColor + ">";
                sb.append(color);
                sb.append(System.getProperty("line.separator"));
                sb.append("Provider Algo=");
                sb.append(md.getProvider());
                sb.append("</font>");


            }

        }

        return sb.toString();

    }

    public static String CalcualateMD5(final String algo, final byte[] inputText, final String provider) {
        final StringBuffer sb = new StringBuffer();
        if (algo != null && !algo.isEmpty()) {
            if (METHOD_CALCULATEMD5.equals(algo))
                return "";
            if (inputText != null) {
                MessageDigest md = null;
                try {
                    if (provider != null) {
                        md = MessageDigest.getInstance(algo, provider);
                    } else {
                        md = MessageDigest.getInstance(algo);
                    }

                } catch (Exception e) {
                    //System.out.println(e);
                    return "";
                }
                md.update(inputText);
                byte[] mdbytes = md.digest();
                // convert the byte to hex format method 1

                for (int i = 0; i < mdbytes.length; i++) {
                    sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16)
                            .substring(1));
                }
            }
        }
        return sb.toString();

    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");


        request.getRequestDispatcher("index.jsp").forward(request,
                response);
        ;
        return;
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        final String methodName = request.getParameter("methodName");


        //System.out.println("algo" + algo);
        PrintWriter out = response.getWriter();
        if (METHOD_CALCULATEMD5.equalsIgnoreCase(methodName)) {
            // Set response type to JSON
            response.setContentType("application/json");

            final String inputText = request.getParameter("text");
            final String algo = request.getParameter("SHA");

            if(null==inputText || inputText.trim().length()==0)
            {
                Gson gson = new Gson();
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("CALCULATE_MD");
                errorResponse.setErrorMessage("Message is null or empty");
                out.println(gson.toJson(errorResponse));
                return;
            }

            final String[] cipherparameter = request.getParameterValues("cipherparameternew");
            
            if (cipherparameter == null || cipherparameter.length == 0) {
                Gson gson = new Gson();
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("CALCULATE_MD");
                errorResponse.setErrorMessage("Please select at least one hash algorithm");
                out.println(gson.toJson(errorResponse));
                return;
            }

            Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "md/generate";
            
            // Create a list to hold all results
            java.util.List<java.util.Map<String, Object>> results = new ArrayList<>();
            String errorMessage = null;

            for(int i=0; i<cipherparameter.length; i++)
            {
                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                urlParameters.add(new BasicNameValuePair("p_msg", inputText));
                urlParameters.add(new BasicNameValuePair("p_cipher", cipherparameter[i]));

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                try {
                    HttpResponse response1 = client.execute(post);

                    if (response1.getStatusLine().getStatusCode() != 200) {
                        errorMessage = "System error for algorithm " + cipherparameter[i] + ". Please try again later.";
                        continue;
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
                    
                    // Create result map for this algorithm
                    java.util.Map<String, Object> result = new java.util.HashMap<>();
                    result.put("algorithm", cipherparameter[i]);
                    result.put("message", encodedMessage.getMessage());
                    result.put("base64Encoded", encodedMessage.getBase64Encoded());
                    result.put("hexEncoded", encodedMessage.getHexEncoded());
                    results.add(result);
                } catch (Exception e) {
                    errorMessage = "Error processing algorithm " + cipherparameter[i] + ": " + e.getMessage();
                }
            }

            // Create final response
            java.util.Map<String, Object> responseMap = new java.util.HashMap<>();
            responseMap.put("success", results.size() > 0);
            responseMap.put("operation", "CALCULATE_MD");
            responseMap.put("inputText", inputText);
            responseMap.put("results", results);
            if (errorMessage != null) {
                responseMap.put("errorMessage", errorMessage);
            }

            out.println(gson.toJson(responseMap));
            return;




            // MD2
            // MD5
            // SHA-1
            // SHA-256
            // SHA-384
            // SHA-512
        }

        if (METHOD_GENERATE_HMAC.equalsIgnoreCase(methodName)) {

            final String inputText = request.getParameter("text");
            final String key = request.getParameter("passphrase");


            if (null == inputText || inputText.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Message is null or empty " +
                        "</font>" +
                        "  <br>");
                return;
            }

            if (key == inputText || key.length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\"> Key is null or empty " +
                        "</font>" +
                        "  <br>");
                return;
            }


            Enumeration en = request.getParameterNames();

            while (en.hasMoreElements()) {
                Object objOri = en.nextElement();
                String param = (String) objOri;
                String value = request.getParameter(param);

                try {
                    macchoices macchoic;
                    macchoic = macchoices.valueOf(value);

                    if (!param.equals(METHOD_GENERATE_HMAC) || !param.equals("text") || !param.equals("key")) //Pass only the Algo
                    {


                        Gson gson = new Gson();
                        HttpClient client = HttpClientBuilder.create().build();
                        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "hmac/generatehmac";
                        HttpPost post = new HttpPost(url1);


                        List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                        urlParameters.add(new BasicNameValuePair("p_msg", inputText));
                        urlParameters.add(new BasicNameValuePair("p_key", key));
                        urlParameters.add(new BasicNameValuePair("p_algo", value));


                        post.setEntity(new UrlEncodedFormEntity(urlParameters));


                        post.addHeader("accept", "application/json");

                        HttpResponse response1 = client.execute(post);

                        if (response1.getStatusLine().getStatusCode() != 200) {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request if Problem Persists </font>");
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

                        addHorizontalLine(out);
                        out.println("<h4 class=\"mt-4\">Base64 Encoded HMAC Value using algo [" + value + "]</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + encodedMessage.getBase64Encoded() + "</textarea>");

                        out.println("<h4 class=\"mt-4\">Hex Encoded HMAC Value using algo [" + value + "]</h4>");
                        out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=2  form=\"X\">" + encodedMessage.getHexEncoded() + "</textarea>");



//					final String MD = CalcualateMD5(value, inputText,provider);
//					if(MD!=null && !MD.isEmpty())
//					{
//						addHorizontalLine(out);
//						out.println("<font size=\"2\" color=\"green\"> Message Digest "
//								+ value + "</font>"
//								+ "<b> = <font size=\"4\" color=\"blue\">"
//								+ MD + "</font></b><br>");
//					}
                    }
                    // yes
                } catch (IllegalArgumentException ex) {

                }


            }

        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

    enum macchoices {
        PBEWithHmacSHA1, PBEWithHmacSHA384, PBEWithHmacSHA256,
        PBEWithHmacSHA512,
        HmacSHA1, HmacSHA384, HmacSHA224,
        HmacSHA256, HmacSHA512, HmacMD5, HMACRIPEMD128, RC2MAC, RC5MAC, IDEAMAC, HMACRIPEMD160, SKIPJACKMAC, HMACTIGER,DES,DESEDEMAC,HMACMD5,HMACMD4,HMACMD2,SKIPJACKMACCFB8,IDEAMACCFB8;
    };

}
