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


        response.setContentType("text/html");
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

            if (p_dns_name == null || p_dns_name.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> CN name is Empty </font>");
                return;
            }

            p_dns_name = p_dns_name.trim();

            Pattern p = Pattern.compile("[^a-z0-9. ]", Pattern.CASE_INSENSITIVE);
            Matcher m = p.matcher(p_dns_name);
            boolean b = m.find();

            if (b) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> CN name is Empty </font>");
                return;
            }

            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "cacerts/" + p_dns_name;

            //System.out.println(url1);

            HttpGet getRequest = new HttpGet(url1);
            getRequest.addHeader("accept", "application/json");

            HttpResponse response1 = httpClient.execute(getRequest);

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

            CAAuthorityPOJO caAuthorityPOJO = gson.fromJson(content.toString(), CAAuthorityPOJO.class);


            out.println("<h4 class=\"mt-4\">Certificate Information for " + p_dns_name + " </h4>");

            out.println("<hr>");


            out.println("<table class=\"table\">");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th scope=\"col\">Private key</th>");
            out.println("<th scope=\"col\">Public key</th>");
            out.println("<th scope=\"col\">Certificate(X.509)</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            out.println("<tr>");
            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + caAuthorityPOJO.getDnsPrivateKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment2\" rows=10 form=\"y\">" + caAuthorityPOJO.getDnsPubliceKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment3\" rows=10 form=\"y\">" + caAuthorityPOJO.getDnsCerts() + "</textarea>");
            out.println("</td>");

            out.println("</tr>");
            out.println("</tbody>");
            out.println("</table>");





            out.println("<hr>");

            out.println("<h4 class=\"mt-4\">Intermediate CA Information</h4>");

            out.println("<table class=\"table\">");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th scope=\"col\">Private key</th>");
            out.println("<th scope=\"col\">Public key</th>");
            out.println("<th scope=\"col\">Certificate(X.509)</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            out.println("<tr>");
            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment\" rows=10 form=\"X\">" + caAuthorityPOJO.getInterCAPrivateKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment\" rows=10 form=\"y\">" + caAuthorityPOJO.getInterCAPubliceKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment\" rows=10 form=\"y\">" + caAuthorityPOJO.getInterCACerts() + "</textarea>");
            out.println("</td>");

            out.println("</tr>");
            out.println("</tbody>");
            out.println("</table>");



            out.println("<hr>");

            out.println("<h4 class=\"mt-4\">rootCA Information</h4>");




            out.println("<table class=\"table\">");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th scope=\"col\">Private key</th>");
            out.println("<th scope=\"col\">Public key</th>");
            out.println("<th scope=\"col\">Certificate(X.509)</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            out.println("<tr>");
            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment\"  rows=10 form=\"X\">" + caAuthorityPOJO.getRootCAPrivateKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment\" rows=10 form=\"y\">" + caAuthorityPOJO.getRootCAPubliceKey() + "</textarea>");
            out.println("</td>");

            out.println("<td>");
            out.println("<textarea nclass=\"form-control animated\" readonly=\"true\" ame=\"comments\"  rows=10 form=\"y\">" + caAuthorityPOJO.getRootCACerts() + "</textarea>");
            out.println("</td>");

            out.println("</tr>");
            out.println("</tbody>");
            out.println("</table>");







        }

        if (METHOD_CSR_SIGNER.equals(methodName)) {

            String p_pem = request.getParameter("p_pem");
            String p_crl = request.getParameter("crl");
            String p_ocsp = request.getParameter("ocsp");


            if (p_pem == null || p_pem.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> CSR is EMpty </font>");
                return;
            }

            p_pem = p_pem.trim();
            if (p_pem.contains("BEGIN CERTIFICATE REQUEST")) {
                if (p_pem.contains("END CERTIFICATE REQUEST")) {
                    String privateKey = null;
                    String encryptdecrypt = request.getParameter("encryptdecrypt");

                    String p_privateKey = request.getParameter("p_privatekey");

                    Gson gson = new Gson();
                    HttpClient client = HttpClientBuilder.create().build();
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "certs/signcsrprivkey";
                    HttpPost post = new HttpPost(url1);
                    List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();


                    if ("useprivatekey".equalsIgnoreCase(encryptdecrypt)) {
                        if (null == p_privateKey || p_privateKey.trim().length() == 0) {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\">  RSA Private Key is Empty or NULL   </font>");
                            return;
                        }
                        p_privateKey = p_privateKey.trim();
                        if (p_privateKey.contains("BEGIN RSA PRIVATE KEY") && p_privateKey.contains("END RSA PRIVATE KEY")) {
                            urlParameters.add(new BasicNameValuePair("p_privatekey", p_privateKey.trim()));
                        } else {
                            addHorizontalLine(out);
                            out.println("<font size=\"2\" color=\"red\"> Not a Valid RSA Private   </font>");
                            return;
                        }

                    } else {
                        urlParameters.add(new BasicNameValuePair("p_privatekey", null));
                    }

                    urlParameters.add(new BasicNameValuePair("p_pem", p_pem));
                    urlParameters.add(new BasicNameValuePair("p_crl", p_crl));
                    urlParameters.add(new BasicNameValuePair("p_ocsp", p_ocsp));

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

                    EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);
                    addHorizontalLine(out);
                    out.println("<p><b><u> Your Certificate in PEM format </b></u> <p>");
                    out.println("<textarea class=\"form-control animated\" name=\"comment\" readonly=true rows=\"10\" cols=\"20\" form=\"X\">" + encodedMessage.getMessage() + "</textarea><hr>");
                    out.println("<p>Parse X.509 PEM file<a href=\"https://8gwifi.org/PemParserFunctions.jsp\" target=\"_blank\"> here</a></p>");
                   // out.println("<textarea class=\"form-control animated\" name=\"comment\" readonly=true rows=\"20\" cols=\"50\" form=\"X\">" + encodedMessage.getBase64Decoded() + "</textarea>");
                    return;

                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Not a Valid CSR Missing -----END CERTIFICATE REQUEST----- </font>");
                    return;
                }
            } else {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\"> Not a Valid CSR Missing -----BEGIN CERTIFICATE REQUEST----- </font>");
                return;
            }

        }
    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
