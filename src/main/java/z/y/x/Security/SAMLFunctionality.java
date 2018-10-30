package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.XMLConstants;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.*;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by aninath on 03/23/18.
 * For Demo Visit https://8gwifi.org
 */
public class SAMLFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_SIGN_XML = "SIGN_XML";
    private static final String METHOD_VERIFY_SIGNATURE_OR_DECODE = "VERIFY_SIGNATURE_OR_DECODE";




    public SAMLFunctionality() {

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


        if(Utils.vaildate())
        {
            addHorizontalLine(out);
            out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License </font>");
            return;
        }

        if (METHOD_SIGN_XML.equals(methodName)) {
            String algo = request.getParameter("sshalgo");
            String p_relaystate = request.getParameter("p_relaystate");
            String p_xml = request.getParameter("p_xml");
            String p_privkey = request.getParameter("p_privkey");
            String p_key = request.getParameter("p_key");
            String passphrase = request.getParameter("passphrase");
            String xmlsignaturealgo = request.getParameter("xmlsignaturealgo");


            if (p_xml == null || p_xml.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\">XML is EMpty or Null </font>");
                return;
            }

            if (p_privkey == null || p_privkey.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\">Private Key is EMpty or Null it's required for generating XML Signature </font>");
                return;
            }

            if (p_key == null || p_key.trim().length() == 0) {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\">x.509 Certifiate is EMpty or Null  </font>");
                return;
            }


            if(passphrase!=null && passphrase.trim().length()>20)
            {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\">password length should be less than 20 </font>");
                return;
            }


            try {
                SAXParserFactory spf = SAXParserFactory.newInstance();
                spf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
                SAXParser saxParser =spf.newSAXParser();

                InputStream stream = new ByteArrayInputStream(p_xml.getBytes("UTF-8"));
                saxParser.parse(stream,new DefaultHandler());
            } catch (Exception e) {
                addHorizontalLine(out);
                out.println("<font size=\"2\" color=\"red\">Invalid XML  " + e + "</font>");
                return;
            }



            try {

                Gson gson = new Gson();
                DefaultHttpClient httpClient = new DefaultHttpClient();
                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/sign";

                //System.out.println(url1);

                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                post.addHeader("accept", "application/json");


                urlParameters.add(new BasicNameValuePair("p_xml", p_xml));
                urlParameters.add(new BasicNameValuePair("p_key", p_key));
                urlParameters.add(new BasicNameValuePair("p_privkey", p_privkey));
                urlParameters.add(new BasicNameValuePair("p_relaystate", p_relaystate));
                urlParameters.add(new BasicNameValuePair("p_algo", xmlsignaturealgo));
                urlParameters.add(new BasicNameValuePair("p_passphrase", passphrase));


                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(post);

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
                        out.println("<font size=\"4\" color=\"red\"> " + content1 + "  </font>");
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

                samlpojo sshpojo = gson.fromJson(content.toString(), samlpojo.class);
                if(sshpojo!=null) {
                    out.println("<font size=\"4\" color=\"green\"> <b><u> Output Signed XML </b></u> <br>");
                    out.println("<textarea name=\"comment\" rows=\"10\" cols=\"60\" form=\"X\">" + sshpojo.getNode() + "</textarea>");
                    if(sshpojo.getSignature()!=null) {
                        out.println("<br/>Signature<br/><textarea name=\"comment\" rows=\"8\" cols=\"60\" form=\"X\">" + sshpojo.getSignature() + "</textarea>");
                        out.println("<br/>");
                        if (p_relaystate != null) {
                            String type = "SAMLRequest";
                            if (p_xml.contains("samlp:Response")) {
                                type = "SAMLResponse";
                            }

                            String msg = type + "=" + "URLEncode(XMLMessage)&RelayState=URLEncode("+p_relaystate+")&SigAlg=URLEncode("+xmlsignaturealgo+")";
                            String signature = "Base64Encode{sign["+msg+"]}";
                            out.println("<br/><font size=\"4\" color=\"purple\"> <b><u> Signature Calculation Logic </b></u> <br>");
                            out.println("<br/><textarea name=\"comment\" rows=\"5\" cols=\"60\" form=\"X\">" + signature+ "</textarea>");
                            out.println();
                            return;
                        }



                    }
                }

            }catch (Exception ex)
            {
                out.println("<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request" + ex +" </font>");
            }


        }

        if (METHOD_VERIFY_SIGNATURE_OR_DECODE.equals(methodName)) {

            String verifysignatureparameter = request.getParameter("verifysignatureparameter");
            String samlmessage = request.getParameter("samlmessage");
            String x509 = request.getParameter("x509");
            String cipherparameter = request.getParameter("cipherparameter");

            boolean isValidparam=false;

            if("verifysignature".equals(verifysignatureparameter))
            {

                isValidparam=true;

                if(null==samlmessage || samlmessage.trim().length()==0 )
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\">Please Input a SAML Message for Verification </font>");
                    return;
                }

                if(null==x509 || x509.trim().length()==0 )
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\">x509 certificate required for Verification of SAML Message </font>");
                    return;
                }


            }

            if("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter) || "samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter))
            {
                isValidparam=true;
                if(null==samlmessage || samlmessage.trim().length()==0 )
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"red\">Please Input a SAML Message for Verification </font>");
                    return;
                }
            }

            if(!isValidparam)
            {
                addHorizontalLine(out);
                out.println("<font size=\"4\" color=\"red\">Please Input a required opertaion to perform (samlmessagedecoder or verifysignature )  </font>");
                return;
            }


            try {
                Gson gson = new Gson();
                DefaultHttpClient httpClient = new DefaultHttpClient();



                String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/validatesign";

                if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter)) {
                    url1 =  LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "saml/encode";

                }

                if ("samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter)) {
                    url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "saml/base64decodedInflated";

                }


                HttpPost post = new HttpPost(url1);
                List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                post.addHeader("accept", "application/json");

                if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter) || "samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter)) {
                    urlParameters.add(new BasicNameValuePair("p_xml", samlmessage));

                }else{
                    urlParameters.add(new BasicNameValuePair("p_xml", samlmessage));
                    urlParameters.add(new BasicNameValuePair("p_key", x509));
                    urlParameters.add(new BasicNameValuePair("p_xpath", cipherparameter));
                }

                post.setEntity(new UrlEncodedFormEntity(urlParameters));
                post.addHeader("accept", "application/json");

                HttpResponse response1 = httpClient.execute(post);

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
                        out.println("<font size=\"4\" color=\"red\"> " + content1 + "  </font>");
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
                if("verifysignature".equals(verifysignatureparameter)) {
                    if (content != null) {
                        if (content.toString().contains("Failed")) {
                            out.println("<font size=\"4\" color=\"red\"> <b><u>  " + content + " </b></u> <br>");
                        } else {
                            out.println("<font size=\"4\" color=\"green\"> <b><u>  " + content + " </b></u> <br>");
                        }
                    }
                }
                else {
                    if ("samlmessagedecoder".equalsIgnoreCase(verifysignatureparameter))
                    {
                        out.println("<br/><font size=\"4\" color=\"purple\"> <b><u> SAML ENcoded   </b></u> <br>");
                    }

                    if ("samlmessagedeflate".equalsIgnoreCase(verifysignatureparameter))
                    {
                        out.println("<br/><font size=\"4\" color=\"purple\"> <b><u> base64decodedInflated  </b></u> <br>");
                    }

                    out.println("<br/><textarea name=\"comment\" rows=\"20\" cols=\"50\" form=\"X\">" + content.toString()+ "</textarea>");
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
