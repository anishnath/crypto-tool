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
import java.net.URL;
import java.security.Security;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */
public class GenCAFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_GENERATE_TEST_CA = "GENERATE_TEST_CA";
    private static final String METHOD_CSR_SIGNER = "CSR_SIGNER";
    private static final String METHOD_CERTS_COMMAND= "CERTS_COMMAND";


    public GenCAFunctionality() {

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

        // Set JSON response for GENERATE_TEST_CA and CSR_SIGNER
        if (METHOD_GENERATE_TEST_CA.equals(methodName) || METHOD_CSR_SIGNER.equals(methodName)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        } else {
            response.setContentType("text/html");
        }
        PrintWriter out = response.getWriter();

        if (METHOD_CERTS_COMMAND.equals(methodName)) {
        	String port = request.getParameter("port");
        	String ipaddress = request.getParameter("ipaddress");

        	if (ipaddress == null || ipaddress.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Please provide the URL to connect</font>");
                return;
            }

        	ipaddress = ipaddress.trim();

        	if(ipaddress.indexOf("http://")==0)
        	{
        		 addHorizontalLine(out);
                 out.println("<font size=\"2\" color=\"red\"> Only https URL </font>");
                 return;
        	}

        	if(ipaddress.indexOf("https://")==0)
        	{
        		System.out.println(ipaddress.substring("https://".length()));
        		ipaddress = ipaddress.substring("https://".length());
        	}

//        	URL url = new URL("https://"+ipaddress);
//        	System.out.println(url.getHost());

        	System.out.println(ipaddress);

        	Gson gson = new Gson();
            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "certs/webcerts";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
            urlParameters.add(new BasicNameValuePair("p_url", ipaddress));
            urlParameters.add(new BasicNameValuePair("p_port", port));
            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            post.addHeader("accept", "application/json");

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
                    out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + content + "</font>");
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

            List<String> listMessage = gson.fromJson(content.toString(), List.class);

            //System.out.println(listMessage);
            int i = 1;
            for (Iterator iterator = listMessage.iterator(); iterator.hasNext();) {
				String string = (String) iterator.next();
				out.println("<br><p>Certificate#"+i+"<br><textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=13  form=\"X\">" + string + "</textarea></p><br/>");
				i++;
			}
            out.println("<a href=\"PemParserFunctions.jsp\" target=\"_blank\">Use PEM Parser to Parse for Extra Information</a>");
        	return;


        }

        if (METHOD_GENERATE_TEST_CA.equals(methodName)) {
            String p_dns_name = request.getParameter("p_dns_name");
            Gson gson = new Gson();

            if (p_dns_name == null || p_dns_name.trim().length() == 0) {
                CACertificateResponse errorResponse = new CACertificateResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate_ca");
                errorResponse.setErrorMessage("CN name is empty. Please provide a valid hostname.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            p_dns_name = p_dns_name.trim();

            Pattern p = Pattern.compile("[^a-z0-9. ]", Pattern.CASE_INSENSITIVE);
            Matcher m = p.matcher(p_dns_name);
            boolean b = m.find();

            if (b) {
                CACertificateResponse errorResponse = new CACertificateResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate_ca");
                errorResponse.setErrorMessage("Invalid CN name. Only alphanumeric characters, dots, and spaces are allowed.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            try {
                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "cacerts/" + p_dns_name;

                HttpGet getRequest = new HttpGet(url1);
                getRequest.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(getRequest);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    CACertificateResponse errorResponse = new CACertificateResponse();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("generate_ca");
                    errorResponse.setErrorMessage("System Error: Please try later. If problem persists, raise a feature request.");
                    out.println(gson.toJson(errorResponse));
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

                CAAuthorityPOJO caAuthorityPOJO = gson.fromJson(content.toString(), CAAuthorityPOJO.class);

                // Create JSON response with all certificate data
                CACertificateResponse caResponse = new CACertificateResponse();
                caResponse.setSuccess(true);
                caResponse.setOperation("generate_ca");
                caResponse.setHostname(p_dns_name);

                // Server certificate info
                caResponse.setServerPrivateKey(caAuthorityPOJO.getDnsPrivateKey());
                caResponse.setServerPublicKey(caAuthorityPOJO.getDnsPubliceKey());
                caResponse.setServerCertificate(caAuthorityPOJO.getDnsCerts());

                // Intermediate CA info
                caResponse.setIntermediatePrivateKey(caAuthorityPOJO.getInterCAPrivateKey());
                caResponse.setIntermediatePublicKey(caAuthorityPOJO.getInterCAPubliceKey());
                caResponse.setIntermediateCertificate(caAuthorityPOJO.getInterCACerts());

                // Root CA info
                caResponse.setRootPrivateKey(caAuthorityPOJO.getRootCAPrivateKey());
                caResponse.setRootPublicKey(caAuthorityPOJO.getRootCAPubliceKey());
                caResponse.setRootCertificate(caAuthorityPOJO.getRootCACerts());

                out.println(gson.toJson(caResponse));

            } catch (Exception e) {
                CACertificateResponse errorResponse = new CACertificateResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("generate_ca");
                errorResponse.setErrorMessage("Error generating CA: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            }
        }

        if (METHOD_CSR_SIGNER.equals(methodName)) {
            Gson gson = new Gson();

            String p_pem = request.getParameter("p_pem");
            String p_crl = request.getParameter("crl");
            String p_ocsp = request.getParameter("ocsp");

            if (p_pem == null || p_pem.trim().length() == 0) {
                SignCSRResponse errorResponse = new SignCSRResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_csr");
                errorResponse.setErrorMessage("CSR is empty. Please provide a valid Certificate Signing Request.");
                out.println(gson.toJson(errorResponse));
                return;
            }

            p_pem = p_pem.trim();
            if (!p_pem.contains("BEGIN CERTIFICATE REQUEST")) {
                SignCSRResponse errorResponse = new SignCSRResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_csr");
                errorResponse.setErrorMessage("Not a valid CSR. Missing -----BEGIN CERTIFICATE REQUEST-----");
                out.println(gson.toJson(errorResponse));
                return;
            }

            if (!p_pem.contains("END CERTIFICATE REQUEST")) {
                SignCSRResponse errorResponse = new SignCSRResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_csr");
                errorResponse.setErrorMessage("Not a valid CSR. Missing -----END CERTIFICATE REQUEST-----");
                out.println(gson.toJson(errorResponse));
                return;
            }

            String encryptdecrypt = request.getParameter("encryptdecrypt");
            String p_privateKey = request.getParameter("p_privatekey");
            boolean useProvidedKey = false;

            HttpClient client = HttpClientBuilder.create().build();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "certs/signcsrprivkey";
            HttpPost post = new HttpPost(url1);
            List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();

            if ("useprivatekey".equalsIgnoreCase(encryptdecrypt)) {
                if (null == p_privateKey || p_privateKey.trim().length() == 0) {
                    SignCSRResponse errorResponse = new SignCSRResponse();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_csr");
                    errorResponse.setErrorMessage("RSA Private Key is required when using your own CA key.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
                p_privateKey = p_privateKey.trim();
                if (p_privateKey.contains("BEGIN RSA PRIVATE KEY") && p_privateKey.contains("END RSA PRIVATE KEY")) {
                    urlParameters.add(new BasicNameValuePair("p_privatekey", p_privateKey.trim()));
                    useProvidedKey = true;
                } else {
                    SignCSRResponse errorResponse = new SignCSRResponse();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_csr");
                    errorResponse.setErrorMessage("Not a valid RSA Private Key. Must contain BEGIN/END RSA PRIVATE KEY headers.");
                    out.println(gson.toJson(errorResponse));
                    return;
                }
            } else {
                urlParameters.add(new BasicNameValuePair("p_privatekey", null));
            }

            urlParameters.add(new BasicNameValuePair("p_pem", p_pem));
            urlParameters.add(new BasicNameValuePair("p_crl", p_crl));
            urlParameters.add(new BasicNameValuePair("p_ocsp", p_ocsp));

            try {
                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = client.execute(post);

                if (response1.getStatusLine().getStatusCode() != 200) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(response1.getEntity().getContent()));
                    StringBuilder content = new StringBuilder();
                    String line;
                    while (null != (line = br.readLine())) {
                        content.append(line);
                    }
                    SignCSRResponse errorResponse = new SignCSRResponse();
                    errorResponse.setSuccess(false);
                    errorResponse.setOperation("sign_csr");
                    errorResponse.setErrorMessage("System Error: " + content.toString());
                    out.println(gson.toJson(errorResponse));
                    return;
                }

                BufferedReader br = new BufferedReader(new InputStreamReader(response1.getEntity().getContent()));
                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);

                SignCSRResponse csrResponse = new SignCSRResponse();
                csrResponse.setSuccess(true);
                csrResponse.setOperation("sign_csr");
                csrResponse.setCertificatePem(encodedMessage.getMessage());
                csrResponse.setUsedProvidedKey(useProvidedKey);
                if (p_crl != null && !p_crl.trim().isEmpty()) {
                    csrResponse.setCrlDistributionPoint(p_crl.trim());
                }
                if (p_ocsp != null && !p_ocsp.trim().isEmpty()) {
                    csrResponse.setOcspUrl(p_ocsp.trim());
                }
                out.println(gson.toJson(csrResponse));

            } catch (Exception e) {
                SignCSRResponse errorResponse = new SignCSRResponse();
                errorResponse.setSuccess(false);
                errorResponse.setOperation("sign_csr");
                errorResponse.setErrorMessage("Error signing CSR: " + e.getMessage());
                out.println(gson.toJson(errorResponse));
            } finally {
                if (post != null) {
                    post.releaseConnection();
                }
            }
        }
    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
