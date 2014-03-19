package z.y.x.Security;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;
import java.security.Provider.Service;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import z.y.x.r.ColorCodeOnStartupFunctionality;

/**
 * Servlet implementation class MD5Calculator Anish Nath
 */
public class MDFunctionality extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	static{
		Security.addProvider(new BouncyCastleProvider());	
	}
	private static final String METHOD_CALCULATEMD5 = "CALCULATE_MD";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MDFunctionality() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// TODO Auto-generated method stub

		// Set response content type
		response.setContentType("text/html");

		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		final String inputText = request.getParameter("text");
		final String algo = request.getParameter("SHA");
		final String methodName = request.getParameter("methodName");
		String provider = request.getParameter("provider");
		if(!"BC".equalsIgnoreCase(provider))
		{
			provider=null;
		}
		
		//System.out.println("algo" + algo);
		PrintWriter out = response.getWriter();
		if (METHOD_CALCULATEMD5.equalsIgnoreCase(methodName)) {
			

			Enumeration en = request.getParameterNames();

			while (en.hasMoreElements()) {
				Object objOri = en.nextElement();
				String param = (String) objOri;
				String value = request.getParameter(param);
				if(!param.equals(METHOD_CALCULATEMD5) || !param.equals("text")) //Pass only the Algo
				{
					final String MD = CalcualateMD5(value, inputText,provider);
					if(MD!=null && !MD.isEmpty())
					{
						addHorizontalLine(out);
						out.println("<font size=\"2\" color=\"green\"> Message Digest "
								+ value + "</font>"
								+ "<b> = <font size=\"4\" color=\"blue\">"
								+ MD + "</font></b><br>");
					}
				}
				
			}

			// MD2
			// MD5
			// SHA-1
			// SHA-256
			// SHA-384
			// SHA-512
		}
	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	public static String CalcualateMD5(final String algo, final String inputText,final String provider) {
		final StringBuffer sb = new StringBuffer();
		if (algo != null && !algo.isEmpty()) {
			if(METHOD_CALCULATEMD5.equals(algo))
				return "";
			if (inputText != null && !inputText.isEmpty()) {
				MessageDigest md = null;
				try {
					if(provider!=null)
					{
						md = MessageDigest.getInstance(algo,provider);
					}
					else{
						md = MessageDigest.getInstance(algo);
					}
					
				} catch (Exception e) {
					//System.out.println(e);
					return "";
				}
				md.update(inputText.getBytes());
				byte[] mdbytes = md.digest();
				// convert the byte to hex format method 1

				for (int i = 0; i < mdbytes.length; i++) {
					sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16)
							.substring(1));
				}
				
				 
				 
				String getColor = ColorCodeOnStartupFunctionality.getRandomColor();
        			String color = "<font color="+getColor+">";
				sb.append( color);
				sb.append("<br>Digest Length=");
				sb.append(md.getDigestLength());
				sb.append("</font>"); 
				getColor = ColorCodeOnStartupFunctionality.getRandomColor();
    			    color = "<font color="+getColor+">";
    			    sb.append( color);
				sb.append(System.getProperty("line.separator"));
				sb.append("Digest Algo=");
				sb.append(md.getAlgorithm());
				sb.append("</font>"); 
				getColor = ColorCodeOnStartupFunctionality.getRandomColor();
			    color = "<font color="+getColor+">";
			    sb.append( color);
				sb.append(System.getProperty("line.separator"));
				sb.append("Provider Algo=");
				sb.append(md.getProvider());
				sb.append("</font>"); 
				
				
				
				
			}

		}

		return sb.toString();

	}

}
