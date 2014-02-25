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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class NetworkFunctionality extends HttpServlet {

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
		out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");
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
					    commands.add("-c"); // On Windows it's Different
					    commands.add("5");
					    commands.add(address.getHostAddress());
					    out.println("<b><u>ping address </b></u>= <font size=\"3\" color=\"red\">"
								+ doCommand(commands) + "</font><br>");
					}
					
				    
				} catch (Exception e) {
					//IGNORE
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
	


	public static String doCommand(List<String> command) 
			  throws IOException
			  {
			    String s = null;

			    StringBuilder builder = new StringBuilder();
			    ProcessBuilder pb = new ProcessBuilder(command);
			    Process process = pb.start();

			    BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
			    BufferedReader stdError = new BufferedReader(new InputStreamReader(process.getErrorStream()));

			    // read the output from the command
			    System.out.println("Here is the standard output of the command:\n");
			    while ((s = stdInput.readLine()) != null)
			    {
			     builder.append(s);
			     builder.append("\n");
			    }

			    // read any errors from the attempted command
			    System.out.println("Here is the standard error of the command (if any):\n");
			    while ((s = stdError.readLine()) != null)
			    {
			    	builder.append(s);
			    	 builder.append("\n");
			    }
			  return  builder.toString();
			  }
	
	public static void main(String[] args) {
		System.out.println("10.10.10.10".length());
	}

}
