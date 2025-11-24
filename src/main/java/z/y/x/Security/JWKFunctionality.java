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

        // Set response content type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        String publiKeyParam = request.getParameter("param");
        final String methodName = request.getParameter("methodName");



        if (METHOD_CALCULATEJWK.equalsIgnoreCase(methodName)) {

            if (publiKeyParam == null || publiKeyParam.length() == 0) {
                publiKeyParam = "0";
            }

            publiKeyParam = publiKeyParam.trim();

                    try {

                        gson = new Gson();
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
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("calculate_jwk");
                        errorResponse.setErrorMessage("System Error: " + content1.toString());
                        out.println(gson.toJson(errorResponse));
                        return;
                    } else {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("calculate_jwk");
                        errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                        out.println(gson.toJson(errorResponse));
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

                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("calculate_jwk");
                successResponse.setMessage(content1.toString());  // Generated JWK
                
                out.println(gson.toJson(successResponse));
                return;


                    } catch (Exception e) {
                        EncodedMessage errorResponse = new EncodedMessage();
                        errorResponse.setSuccess(false);
                        errorResponse.setOperation("calculate_jwk");
                        errorResponse.setErrorMessage("Error generating JWK: " + e.getMessage());
                        out.println(gson.toJson(errorResponse));
                    }


                }

        if (METHOD_CONVERT_JWK.equalsIgnoreCase(methodName)) {

            String param = request.getParameter("param");
            String input = request.getParameter("input");


            if(null==input || input.trim().length()==0)
            {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("convert_jwk");
                errorResponse.setErrorMessage("Input is null or empty. Please provide JWK or PEM format input.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            if("JWK-to-PEM".equalsIgnoreCase(param))
            {
                // Check if input is PEM format (wrong format for JWK-to-PEM conversion)
                if(input.contains("BEGIN") && input.contains("END") && (input.contains("RSA") || input.contains("PRIVATE KEY") || input.contains("PUBLIC KEY")))
                {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("convert_jwk");
                    errorResponse.setErrorMessage("You selected 'JWK to PEM' but provided PEM format input. Please select 'PEM to JWK' option instead, or provide a JWK (JSON format) input.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                // Check if input is JWK format (correct format for JWK-to-PEM conversion)
                if (input.contains("kty") && input.contains("{") && input.contains("}"))
                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "jwk/convertjwktopem";
                    generateToPem(out, input, url1);
                    return;
                }

                // Input format not recognized
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("convert_jwk");
                errorResponse.setErrorMessage("Not a valid JWK key. Please input a valid JWK key in JSON format (should contain 'kty' field).");
                out.println(gson.toJson(errorResponse));
                return;
            }

            if("PEM-to-JWK".equalsIgnoreCase(param))
            {
                // Check if input is JWK format (wrong format for PEM-to-JWK conversion)
                if (input.contains("kty") && input.contains("{") && input.contains("}"))
                {
                    EncodedMessage errorResponse = new EncodedMessage();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("convert_jwk");
                    errorResponse.setErrorMessage("You selected 'PEM to JWK' but provided JWK format input. Please select 'JWK to PEM' option instead, or provide a PEM format key.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                // Check if input is PEM format (correct format for PEM-to-JWK conversion)
                if(input.contains("BEGIN") && input.contains("END") && (input.contains("---") || input.contains("RSA") || input.contains("PRIVATE KEY") || input.contains("PUBLIC KEY")))
                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "jwk/convertpemtojwk";
                    generateToPem(out, input, url1);
                    return;
                }

                // Input format not recognized
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("convert_jwk");
                errorResponse.setErrorMessage("Not a valid PEM format. Please input a valid PEM key (should contain '-----BEGIN' and '-----END' markers).");
                out.println(gson.toJson(errorResponse));
                return;
            }


        }

        }

    private void generateToPem(PrintWriter out, String input,String url1) {
        Gson gson = new Gson();
        try {

            HttpClient client = HttpClientBuilder.create().build();
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_param", input));

            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                EncodedMessage errorResponse = new EncodedMessage();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("convert_jwk");
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
                    errorResponse.setErrorMessage("System Error: " + content1.toString());
                } else {
                    errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                }
                out.println(gson.toJson(errorResponse));
                return;
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

            if(url1.contains("convertjwktopem")) {
                // JWK to PEM conversion
                jwkpojo jwkpojo = gson.fromJson(content1.toString(), jwkpojo.class);
                
                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("convert_jwk");
                successResponse.setAlgorithm("JWK-to-PEM");
                successResponse.setMessage(jwkpojo.getPublicKey());  // Public key in PEM format
                successResponse.setBase64Encoded(jwkpojo.getPrivateKey());  // Private key in PEM format
                
                out.println(gson.toJson(successResponse));
            } else {
                // PEM to JWK conversion
                EncodedMessage successResponse = new EncodedMessage();
                successResponse.setSuccess(true);
                successResponse.setOperation("convert_jwk");
                successResponse.setAlgorithm("PEM-to-JWK");
                successResponse.setMessage(content1.toString());  // JWK in JSON format
                
                out.println(gson.toJson(successResponse));
            }

            return;

        } catch (Exception e) {
            EncodedMessage errorResponse = new EncodedMessage();
            errorResponse.setSuccess(false);
            errorResponse.setOperation("convert_jwk");
            errorResponse.setErrorMessage("Error during conversion: " + e.getMessage());
            out.println(gson.toJson(errorResponse));
        }
    }



}
