package z.y.x.Network;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingEnumeration;
import javax.naming.directory.Attributes;
import javax.naming.directory.InitialDirContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class NetworkFunctionality extends HttpServlet {
	
	private final String os = System.getProperty("os.name");
	private final NetworkDiagnostics networkDiagnostics = new NetworkDiagnostics();

	/**
	 * 
	 */
	private static final long serialVersionUID = -2727554819975126562L;

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		// Set response content type
		response.setContentType("text/html");

		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE TRY AGAIN " + "</h1>");
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		final String isgetClientIpAddrRequested = request.getParameter("getClientIpAddr");
		
		if(isgetClientIpAddrRequested!=null && !isgetClientIpAddrRequested.isEmpty())
		{
			addHorizontalLine(out);
			out.println("<b><u>Get Client Ip Address </b></u>= <font size=\"3\" color=\"blue\">"
					+ getClientIpAddr(request) + "</font><br>");
			out.println("<b><u>Get Client Ip Address </b></u>= <font size=\"3\" color=\"cyan\">"
					+ InetAddress.getLocalHost().toString()+ "</font><br>");
		}
		
		
		
		//PING
		final String hiddenPingipaddress = request.getParameter("hiddenPingipaddress");
		if(hiddenPingipaddress!=null && !hiddenPingipaddress.isEmpty())
		{
			final String ipaddress = request.getParameter("ipaddress");
			if(ipaddress!=null )
			{
				//if()
				//InetAddressValid
				try {
					InetAddress address = InetAddress.getByName(ipaddress);
					if(address!=null)
					{
						addHorizontalLine(out);
						List<String> commands = new ArrayList<String>();
					    commands.add("ping");
					    if (os.contains("win"))
					    {
					    	commands.add("-n"); // Nott TESTED
					    }else{
					    	 commands.add("-c"); // On Windows it's Different
					    }
					   
					    commands.add("5");
					    commands.add(address.getHostAddress());
					    out.println("<b><u>ping address </b></u>= <font size=\"3\" color=\"red\">"
								+ networkDiagnostics.doCommand(commands) + "</font><br>");
					    
					    // show the Internet Address as name/address
			            System.out.println(address.getHostName() + "/" + address.getHostAddress());
			            // get the default initial Directory Context
			            InitialDirContext iDirC = new InitialDirContext();
			            // get the DNS records for inetAddress
			            Attributes attributes = iDirC.getAttributes("dns:/" + address.getHostName());
			            // get an enumeration of the attributes and print them out
			            NamingEnumeration attributeEnumeration = attributes.getAll();
			            System.out.println("-- DNS INFORMATION --");
			            StringBuilder builder = new StringBuilder();
			            while (attributeEnumeration.hasMore())
			            {
			               // System.out.println("" + attributeEnumeration.next());
			            	builder.append(attributeEnumeration.next() + "<br>");
			            	builder.append(System.getProperty("line.separator"));
			            }
			            attributeEnumeration.close();
			            
			            addHorizontalLine(out);
			            out.println("<b><u>DNS Information </b></u>= <font size=\"3\" color=\"blue\">"
								+ builder.toString() + "</font><br>");
			            
			            addHorizontalLine(out);
			            out.println("<b><u>DNS Information </b></u>= <font size=\"3\" color=\"blue\">"
								+ networkDiagnostics.traceRoute(address)+ "</font><br>");
			            ;
					}
					else
					{
						 out.println("<b><u> Host Not Reachable </font><br>" + ipaddress);
					}
					
				    
				} catch (Exception e) {
					//IGNORE
					out.println("<b><u> "+e+" </font><br>" + ipaddress);
				}
				
			}
		}
		
		

	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	public static String getClientIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
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
		return ip;
	}
	


	
	
	public static void main(String[] args) {
		System.out.println("10.10.10.10".length());
	}

}
