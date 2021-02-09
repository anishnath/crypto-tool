package z.y.x.Network;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.xbill.DNS.*;
import org.xbill.DNS.DNSSEC.DNSSECException;

import com.google.common.net.InetAddresses;
import z.y.x.Security.VerifyRecaptcha;
import z.y.x.u.HexUtils;
import z.y.x.u.IPLocation;

/**
 * 
 * @author anishnath
 *
 */
public class NetworkFunctionality extends HttpServlet {

    private static final String METHOD_EXECUTENETWORKPINGCOMMAND = "NETWORKPINGCOMMAND";
    private static final String METHOD_EXECUTENETWORKCURLCOMMAND = "NETWORKCURLCOMMAND";
    private static final String METHOD_EXECUTENETWORKDNSCOMMAND = "NETWORKDNSCOMMAND";
    private static final String METHOD_EXECUTENETWORKDNSCOMMAND_DMARC = "NETWORKDNSCOMMANDDMARC";
    /**
     *
     */
    private static final long serialVersionUID = -2727554819975126562L;
    private final String os = System.getProperty("os.name");
    private final NetworkDiagnostics networkDiagnostics = new NetworkDiagnostics();

    public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        InetAddress localip = null;
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip.equals("0:0:0:0:0:0:0:1")) {

            try {
                localip = InetAddress.getLocalHost();
            } catch (UnknownHostException e) {
                return  ip;
            }

        }
        if(localip!=null)
        {

            return localip.getHostAddress();
        }
        else
        {
            return  ip;
        }
    }

    public static void main(String[] args) {
        System.out.println("10.10.10.10".length());
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");



        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE TRY AGAIN " + "</h1>");
        out.println("<b><u>Get Client Ip Address </b></u>= <font size=\"3\" color=\"cyan\">"
                + InetAddress.getLocalHost().toString() + "</font><br>");
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        final String isgetClientIpAddrRequested = request.getParameter("getClientIpAddr");
        final String queryV6 = request.getParameter("queryV6DOmain");
        String gRecaptchaResponse = request
                .getParameter("g-recaptcha-response");
        
        final String methodName = request.getParameter("methodName");

       
        
        if (METHOD_EXECUTENETWORKDNSCOMMAND_DMARC.equalsIgnoreCase(methodName)) {
        	
        	String ipaddress = request.getParameter("ipaddress");
        	if (null == ipaddress || ipaddress.trim().length()==0) {
        		out.println("<b><u> Invalid DNS Name or hostname Please Check and try Again  </font><br>" + ipaddress);
        		return;
        	}
        	 ipaddress = ipaddress.trim();
        	 ipaddress = "_dmarc."+ipaddress;
        	 StringBuilder builder = new StringBuilder();
        	 Record []  record = new Lookup(ipaddress, Type.A).run();
        	 
        	 record = new Lookup(ipaddress, Type.TXT).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 out.println("<br><h3>DNS Record\n" + 
                  		"</h3>");
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
            	 List<String> dmarccList = new ArrayList<>();
                 for (int i = 0; i < record.length; i++) {
                	 TXTRecord aaaaRecorda = (TXTRecord) record[i];
                     if (aaaaRecorda != null) {
                        
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">TXT</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td><code>"+StringUtils.join(aaaaRecorda.getStrings(),",")+"</code></td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                    	 dmarccList.addAll(aaaaRecorda.getStrings());
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
                 
                 out.println("<hr>");
                 out.println("<h3>Declared tags\n" + 
                 		"</h3>");
                 
                 builder = new StringBuilder();
            	 builder.append( "<div class=\"table-responsive\"><table class=\"table table-striped\"> "+
                   	  "<thead class=\"thead-dark\"> "+
                   	   " <tr> "+
                   	   "   <th style=\"width: 2%\">Tag</th>"+
                   	   "   <th style=\"width: 20%\">Value</th>"+
                   	   "   <th style=\"width: 70%\">Explanation</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 
                 for (Iterator iterator = dmarccList.iterator(); iterator.hasNext();) {
					String string = (String) iterator.next();
					String[] arrOfStr = string.split(";"); 
					for (int i = 0; i < arrOfStr.length; i++) {
						String tmp = arrOfStr[i];
						//System.out.println("i " + i + " " +tmp);
						String[] tmpArr = tmp.split("=");
						if(tmpArr.length==2)
						{
							
							 builder.append( " <tr> ");
							 builder.append( " <td style=\"width: 2%\" ><p>"+tmpArr[0]+"</p></td> ");
							 builder.append( " <td style=\"width: 20%\"><code>"+tmpArr[1]+"</code></td> ");
							 
							 
							 if("v".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( " <td style=\"width: 70%\" >DMARC protocol version.</td> ");	 
							 }
							 else if("p".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Requested Mail Receiver policy. Indicates the policy to be enacted by the Receiver at the request of the Domain Owner. This policy be set to 'none', 'quarantine', or 'reject'. 'none' is used to collect the DMARC report and gain insight into the current emailflows and their status</p></td> ");	 
							 }
							 else if("rua".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Addresses to which aggregate feedback is to be sen. DMARC requires a list of URIs of the form 'mailto:test@example.com'</p></td> ");	 
							 }
							 else if("ruf".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Addresses to which message-specific failure information is to be reported . DMARC requires a list of URIs of the form 'mailto:test@example.com'</p></td> ");	 
							 }
							 else if("ri".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Interval requested between aggregate reports </p></td> ");	 
							 }
							 else if("sp".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Requested Mail Receiver policy for all subdomains. It applies only to subdomains of the domain queried and not to the domain itself </p></td> ");	 
							 }
							 else if("rf".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Format to be used for message-specific failure reports</p></td> ");	 
							 }
							 else if("pct".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Percentage of messages from the Domain Owner's mail stream to which the DMARC policy is to be applied</p></td> ");	 
							 }
							 else if("aspf".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Indicates whether strict or relaxed SPF Identifier Alignment mode is required by the Domain Owner Valid values <br>"
								 		+ "<b>r:</b> relaxed mode "
								 		+ "<br><b>s:</b> strict mode</p></td> ");	 
							 }
							 else if("fo".equalsIgnoreCase(tmpArr[0].trim()))
							 {
								 builder.append( "<td style=\"width: 70%\"><p>Failure reporting options  \n"
								 		+ "\n <br>  <b>0:</b> Generate a DMARC failure report if all underlying authentication mechanisms fail to produce an aligned \"pass\" result \n"
								 		+ " <br><b>1:</b> Generate a DMARC failure report if any underlying authentication mechanism produced something other than an aligned \"pass\" result. \n"
								 		+ " <br><b>d:</b> Generate a DKIM failure report if the message had a signature that failed evaluation, regardless of its alignment \n"
								 		+ " <br><b>s:</b> Generate an SPF failure report if the message failed SPF evaluation, regardless of its alignment </p></td> ");	 
							 }
							 else {
								 builder.append( "<td style=\"width: 70%\"><p></p></td> ");	 
							 }
							 builder.append( "</tr>");
						}
					}

				}
                 builder.append( "</tbody></table></div>");
                 out.println(builder.toString());
             }
             else {
            	 out.println("<h4>No DMARC Record found for  " + ipaddress + "</h4>");
             }
        	 return;
        }
        
        //System.out.println(gRecaptchaResponse);
        boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse);

       // System.out.println(verify);

        if(!verify && !METHOD_EXECUTENETWORKDNSCOMMAND.equalsIgnoreCase(methodName))
        {
        	
            addHorizontalLine(out);
            out.println("<b><u> Captcha Error Client Ip Address </b></u>= <font size=\"3\" color=\"blue\">"
                    + getClientIpAddr(request) + " Please refresh the page and re-submit the cpatcha </font><br>");
            return;
        }

        

        if (isgetClientIpAddrRequested != null && !isgetClientIpAddrRequested.isEmpty()) {
            addHorizontalLine(out);
            out.println("<b><u> Client Ip Address </b></u>= <font size=\"3\" color=\"blue\">"
                    + getClientIpAddr(request) + "</font><br>");
        }
        

        if (METHOD_EXECUTENETWORKDNSCOMMAND.equalsIgnoreCase(methodName)) {
        	
        	String ipaddress = request.getParameter("ipaddress");
        	
        	if (null == ipaddress || ipaddress.trim().length()==0) {
        		out.println("<b><u> Invalid DNS Name or hostname Please Check and try Again  </font><br>" + ipaddress);
        		return;
        	}
        	 ipaddress = ipaddress.trim();
        	 
        	 StringBuilder builder = new StringBuilder();
        	 
        	 Record []  record = new Lookup(ipaddress, Type.A).run();
             if(record!=null) {
            	 
            	 
            	 
            	 builder.append( "<table class=\"table table-striped\"> "+
            	  "<thead> "+
            	   " <tr> "+
            	   "   <th scope=\"col\">Type</th>"+
            	   "   <th scope=\"col\">Domain Name</th>"+
            	   "   <th scope=\"col\">IP Address</th>"+
            	   "   <th scope=\"col\">	TTL</th>"+
            	   "  </tr> "+
            	  "  </thead>  <tbody> ");
            	 
                 for (int i = 0; i < record.length; i++) {
                     ARecord aaaaRecorda = (ARecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 //System.out.println(aaaaRecorda.toString());
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">A</th> ");
                    	 builder.append( " <td>"+ipaddress+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getAddress().getHostAddress()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL() +" </td>");
                    	 builder.append( " </tr>");
                        
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
                 //addHorizontalLine(out);
             }
             
             record = new Lookup(ipaddress, Type.AAAA).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Domain Name</th>"+
                   	   "   <th scope=\"col\">IP Address</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 AAAARecord aaaaRecorda = (AAAARecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	// System.out.println(aaaaRecorda.toString());
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">AAAA</th> ");
                    	 builder.append( " <td>"+ipaddress+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getAddress().getHostAddress()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                         //addHorizontalLine(out);
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.MX).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Target</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 MXRecord aaaaRecorda = (MXRecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">MX</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTarget()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             
             
            
             
             record = new Lookup(ipaddress, Type.CERT).run(); 
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Algorithm</th>"+
                       "   <th scope=\"col\">CertType</th>"+
                       "   <th scope=\"col\">DClass</th>"+
                       "   <th scope=\"col\">Cert</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 CERTRecord aaaaRecorda = (CERTRecord) record[i];
                     if (aaaaRecorda != null) {
                    	// System.out.println(aaaaRecorda);
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">CERT</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getAlgorithm()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getCertType()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getDClass()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getCert()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
                 
             }
             
             record = new Lookup(ipaddress, Type.CNAME).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Target</th>"+
                       "   <th scope=\"col\">DClass</th>"+
                   	   "   <th scope=\"col\">TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 CNAMERecord aaaaRecorda = (CNAMERecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">CNAME</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTarget()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getDClass()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.NS).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 NSRecord aaaaRecorda = (NSRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">NS</th> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
            
             

             record = new Lookup(ipaddress, Type.TXT).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 TXTRecord aaaaRecorda = (TXTRecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">TXT</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+StringUtils.join(aaaaRecorda.getStrings(),",")+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             

             
             
             record = new Lookup(ipaddress, Type.DS).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Algorithm</th>"+
                       "   <th scope=\"col\">DigestID</th>"+
                       "   <th scope=\"col\">Footprint</th>"+
                       "   <th scope=\"col\">Digest</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 DSRecord aaaaRecorda = (DSRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">DS</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getAlgorithm()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getDigestID()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getFootprint()+"</td>");
                    	 builder.append( " <td><code>"+HexUtils.encodeHex(aaaaRecorda.getDigest(), ":")+"</code></td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.DNSKEY).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Algorithm</th>"+
                       "   <th scope=\"col\">PublicKey</th>"+
                       "   <th scope=\"col\">Flags</th>"+
                       "   <th scope=\"col\">Footprint</th>"+
                       "   <th scope=\"col\">Protocol</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 DNSKEYRecord aaaaRecorda = (DNSKEYRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">DNSKEY</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getAlgorithm()+"</td>");
                    	 try {
 							builder.append( " <td><code>"+HexUtils.encodeHex(aaaaRecorda.getPublicKey().getEncoded(), ":")+"</code></td>");
 						} catch (DNSSECException e) {
 							// TODO Auto-generated catch block
 							e.printStackTrace();
 						}
                    	 builder.append( " <td>"+aaaaRecorda.getFlags()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getFootprint()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getProtocol()+"</td>");
                    	
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.LOC).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 LOCRecord aaaaRecorda = (LOCRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">LOC</th> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             

             record = new Lookup(ipaddress, Type.NAPTR).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 NAPTRRecord aaaaRecorda = (NAPTRRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">NAPTR</th> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
     
             
             record = new Lookup(ipaddress, Type.PTR).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 PTRRecord aaaaRecorda = (PTRRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">PTR</th> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.CAA).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 CAARecord aaaaRecorda = (CAARecord) record[i];
                     if (aaaaRecorda != null) {
                        // out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">CAA</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda.getValue()+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             

             
             record = new Lookup(ipaddress, Type.SPF).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 SPFRecord aaaaRecorda = (SPFRecord) record[i];
                     if (aaaaRecorda != null) {
                    	// out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">SPF</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+StringUtils.join(aaaaRecorda.getStrings(),",")+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.SRV).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 SRVRecord aaaaRecorda = (SRVRecord) record[i];
                     if (aaaaRecorda != null) {
                    	// out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">SRV</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.SMIMEA).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 SMIMEARecord aaaaRecorda = (SMIMEARecord) record[i];
                     if (aaaaRecorda != null) {
                    	// out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">SMIMEA</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.SSHFP).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 SSHFPRecord aaaaRecorda = (SSHFPRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">SSHFP</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             record = new Lookup(ipaddress, Type.TLSA).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 TLSARecord aaaaRecorda = (TLSARecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">TLSA</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             
             
             record = new Lookup(ipaddress, Type.URI).run();
             if(record!=null) {
            	 builder = new StringBuilder();
            	 builder.append( "<table class=\"table table-striped\"> "+
                   	  "<thead> "+
                   	   " <tr> "+
                   	   "   <th scope=\"col\">Type</th>"+
                   	   "   <th scope=\"col\">Name</th>"+
                   	   "   <th scope=\"col\">Value</th>"+
                   	   "   <th scope=\"col\">	TTL</th>"+
                   	   "  </tr> "+
                   	  "  </thead>  <tbody> ");
                 for (int i = 0; i < record.length; i++) {
                	 URIRecord aaaaRecorda = (URIRecord) record[i];
                     if (aaaaRecorda != null) {
                    	 builder.append( " <tr> ");
                    	 builder.append( " <th scope=\"row\">URI</th> ");
                    	 builder.append( " <td>"+aaaaRecorda.getName()+"</td> ");
                    	 builder.append( " <td>"+aaaaRecorda+"</td>");
                    	 builder.append( " <td>"+aaaaRecorda.getTTL()  +" </td>");
                    	 builder.append( " </tr>");
                     }
                 }
                 builder.append( "</tbody></table>");
                 out.println(builder.toString());
             }
             
             
             
        	 
        	
        }
        
        if (METHOD_EXECUTENETWORKPINGCOMMAND.equalsIgnoreCase(methodName)) {


            //PING
            String ipaddress = request.getParameter("ipaddress");


            if (ipaddress != null && !ipaddress.isEmpty()) {
                ipaddress = ipaddress.trim();
                String pingommand = "ping";
                try {

                    InetAddress addr = InetAddress.getByName(ipaddress);
                    boolean status = addr.isReachable(5000);
                    if (addr != null) {
                        final String s1 = addr.getHostAddress();
                        // if(InetAddresses)


                        if (InetAddresses.forString(s1) instanceof Inet4Address) {
                            pingommand = "ping";
                        } else if (InetAddresses.forString(s1) instanceof Inet6Address) {
                            pingommand = "ping6";
                        } else {
                            pingommand = "ping";
                        }
                        addHorizontalLine(out);
                        final List<String> commands = new ArrayList<String>();
                        commands.add(pingommand);
                        if (os.contains("win")) {
                            commands.add("-n"); // Nott TESTED
                        } else {
                            commands.add("-c"); // On Windows it's Different
                        }
                        commands.add("3");
                        commands.add(s1);
                        //final String output =networkDiagnostics.doCommand(command);
                        addHorizontalLine(out);

                        Callable<Object> callable = new Callable<Object>() {
                            public Object call() throws Exception {
                                return networkDiagnostics.doCommand(commands);
                            }
                        };

                        ExecutorService executorService = Executors.newCachedThreadPool();
                        Object result = null;
                        Future<Object> task = executorService.submit(callable);
                        try {
                            // ok, wait for 15 seconds max
                            result = task.get(8, TimeUnit.SECONDS);
                            //System.out.println("Finished with result: " + result);
                            out.println("<b><u>ICMP Echo Reply </b></u>= "  +  pingommand + " -c5 " +ipaddress + "<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                            getIpLocation(out, addr);
                        } catch (ExecutionException e) {
                            throw new RuntimeException(e);

                        } catch (TimeoutException e) {
                            out.println("<b><u>Command </b></u>= Cant Ping" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                        } catch (InterruptedException e) {
                            out.println("<b><u>Command </b></u>= Cant Ping" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                        }

                    }
                } catch (Exception e) {
                    //IGNORE
                    out.println("<b><u> Unknown Host </font><br>" + ipaddress);
                }
            } else {
                out.println("<b><u> Invalid IP Address/DNS Name Please Check and try Again  </font><br>" + ipaddress);
            }

        }

        if (METHOD_EXECUTENETWORKCURLCOMMAND.equalsIgnoreCase(methodName)) {


            //PING
            String ipaddress = request.getParameter("ipaddress");
            String scheme = request.getParameter("scheme");
            String port = request.getParameter("port");

            if(scheme==null || scheme.isEmpty())
            {
                scheme="http";
            }

            if(port!=null)
            {
                try
                {
                    int result = Integer.parseInt(port);
                }catch (NumberFormatException ex )
                {
                    port="80";
                }

            }

            if (ipaddress != null && !ipaddress.isEmpty()) {
                ipaddress = ipaddress.trim();
                String curloption = "--ipv4";
                try {

                    InetAddress addr = InetAddress.getByName(ipaddress);


                    final List<String> commands = new ArrayList<String>();
                        if (addr != null) {
                            commands.add("curl");
                            commands.add("-I");

                            String s1 = addr.getHostAddress();
                            // if(InetAddresses)


                            if (InetAddresses.forString(s1) instanceof Inet4Address) {
                                curloption = "--ipv4";
                            } else if (InetAddresses.forString(s1) instanceof Inet6Address) {
                                curloption = "--ipv6";
                                s1 = "[" + ipaddress + "]";

                               // System.out.println(s1);
                            } else {
                                curloption = "--ipv4";
                            }
                            addHorizontalLine(out);
                            commands.add("-g");
                            commands.add("-k");
                            commands.add(curloption);
                            if (ipaddress.contains(":")) {
                                commands.add(scheme+"://[" + ipaddress + "]:"+port);
                            } else {
                                commands.add(scheme+"://"+ipaddress+":"+port);
                            }

                            //final String output =networkDiagnostics.doCommand(command);
                            addHorizontalLine(out);

                            Callable<Object> callable = new Callable<Object>() {
                                public Object call() throws Exception {
                                    return networkDiagnostics.doCommand(commands);
                                }
                            };

                            ExecutorService executorService = Executors.newCachedThreadPool();
                            Object result = null;
                            Future<Object> task = executorService.submit(callable);
                            try {
                                // ok, wait for 15 seconds max
                                result = task.get(8, TimeUnit.SECONDS);
                                //System.out.println("Finished with result: " + result);
                                out.println("<b><u>SCHEME</b>["+scheme+"] <b>IPAddress </b> </u>[" + addr.getHostAddress() + "] port[" + port + "]<br><font size=\"3\" color=\"blue\">"+
                                       "</font><br>");
                                addHorizontalLine(out);
                                out.println("<b><u>HTTP Header Response </b></u>=  <br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                                addHorizontalLine(out);
                                Record [] aaaaRecord = new Lookup(ipaddress, Type.AAAA).run();
                                if(aaaaRecord!=null)
                                {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        AAAARecord aaaaRecorda = (AAAARecord) aaaaRecord[i];
                                        if(aaaaRecorda!=null)
                                        {
                                            out.println("<b><u>AAAA Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() +"</font><br>");
                                            addHorizontalLine(out);
                                        }

                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.A).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        ARecord aaaaRecorda = (ARecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.MX).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        MXRecord aaaaRecorda = (MXRecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>MX Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.NSAP).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        NSAPRecord aaaaRecorda = (NSAPRecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>MX Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }
                                getIpLocation(out, addr);

                            } catch (ExecutionException e) {
                                throw new RuntimeException(e);

                            } catch (TimeoutException e) {
                                out.println("<b><u>Command </b></u>= Cant Fetch Header" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                            } catch (InterruptedException e) {
                                out.println("<b><u>Command </b></u>= Cant Header" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                            }

                        }
                    else {
                        out.println("<b><u> Host Not Reachable  </font><br>" + ipaddress);
                    }

                } catch (Exception e) {
                    //IGNORE
                    //e.printStackTrace();
                    out.println("<b><u> Unknown Host </font>" + ipaddress);
                }
            } else {
                out.println("<b><u> Invalid IP Address/DNS Name Please Check and try Again  </font><br>" + ipaddress);
            }

        }
    }

    private void getIpLocation(PrintWriter out, InetAddress addr) {
        IPLocation ipLocation = IpLocationDetector.getLocation(addr.getHostAddress());
        {
            if (ipLocation != null) {
                out.println("<b><u>Country</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getCountry() + "</font><br>");
                out.println("<b><u>City</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getCity() + "</font><br>");
                out.println("<b><u>Location</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getLoc() + "</font><br>");
                out.println("<b><u>Region</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getRegion() + "</font><br>");
                out.println("<b><u>Organization</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getOrg() + "</font><br>");
                addHorizontalLine(out);

            }

        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}
