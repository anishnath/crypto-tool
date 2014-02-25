package z.y.x.String;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import z.y.x.u.StringUtils;

/**
 * Servlet implementation class StringFunctionality
 */

public class StringFunctionality extends HttpServlet {
	private static final long serialVersionUID = 1L;

	final String METHOD_CALCULATELENGTH = "calculateLength";
	final String TRIM = "trim";
	final String IGNORE = "ignore";
	final String TOLOWERCASE = "toLowerCase";
	final String TOUPPERCASE = "toUpperCase";

	/**
	 * Default constructor.
	 */
	public StringFunctionality() {
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
		response.setContentType("text/html");
		final String methodName = request.getParameter("methodName");
		final String trim = request.getParameter("trim");
		final String ignoreWhiteSpace = request.getParameter("ignore");

		final String toUpperCase = request.getParameter("toUpperCase");
		final String toLowerCase = request.getParameter("toLowerCase");

		// indexOf
		final String indexOf = request.getParameter("indexOf");
		final String fromIndex = request.getParameter("indexOffromIndex");

		// LastIndexOf
		final String lastindexOf = request.getParameter("lastindexOf");
		final String lastindexOffromIndex = request
				.getParameter("lastindexOffromIndex");

		// Replace
		final String oldChar = request.getParameter("oldChar");
		final String newChar = request.getParameter("newChar");

		// Replace
		final String regex = request.getParameter("regex");
		final String replacement = request.getParameter("replacement");
		
		//SubString
		final String beginIndex = request.getParameter("beginIndex");
		final String endIndex = request.getParameter("endIndex");
		

		PrintWriter out = response.getWriter();

		if (METHOD_CALCULATELENGTH.equalsIgnoreCase(methodName)) {
			final String lengthOfString = request
					.getParameter("lengthOfString");

			if (lengthOfString == null || lengthOfString.isEmpty()) {
				out.println("<h1>" + null + "</h1>");
				return;
			}
			addHorizontalLine(out);
			out.println("<b><u>Original String Text</b></u>= <font size=\"6\" color=\"red\">"
					+ lengthOfString + "</font><br>");
			out.println("<b><u>Original String Text Length</b></u>= <font size=\"6\" color=\"red\">"
					+ lengthOfString.length() + "</font>");

			if (IGNORE.equals(ignoreWhiteSpace)) {
				addHorizontalLine(out);
				out.println(" After Removing whitespace from Strings<b> = <font size=\"4\" color=\"blue\">"
						+ StringUtils.replaceAllWhiteSpace(lengthOfString)
						+ "</font></b><br>");
				out.println("After Removing whitespace from String length<b> = <font size=\"4\" color=\"blue\">"
						+ StringUtils.replaceAllWhiteSpace(lengthOfString)
								.length() + "</font></b><br>");
			}

			if (TRIM.equalsIgnoreCase(trim)) {
				addHorizontalLine(out);
				out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>"
						+ "<b><u>.trim()</u> = <font size=\"4\" color=\"blue\">"
						+ lengthOfString.trim() + "</font></b><br>");
				out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>"
						+ "<b><u>.trim().length()</u> = <font size=\"4\" color=\"blue\">"
						+ lengthOfString.trim().length() + "</font></b><br>");

			}

			if (TOLOWERCASE.equalsIgnoreCase(toLowerCase)) {
				addHorizontalLine(out);
				out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>"
						+ "<b><u>.toLowerCase()</u> = <font size=\"4\" color=\"blue\">"
						+ lengthOfString.toLowerCase() + "</font></b><br>");
			}
			
			if (TOUPPERCASE.equalsIgnoreCase(toUpperCase)) {
				addHorizontalLine(out);
				out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>"
						+ "<b><u>.toUpperCase()</u> = <font size=\"4\" color=\"blue\">"
						+ lengthOfString.toUpperCase() + "</font></b><br>");
			}

			// Index Off Processing
			processIndexOff(indexOf, fromIndex, out, lengthOfString, false);
			processIndexOff(lastindexOf, lastindexOffromIndex, out,
					lengthOfString, true);

			// LastIndexOf Processing

			// Replace
			try {
				if (oldChar != null && !oldChar.isEmpty()) {
					if (newChar != null && !newChar.isEmpty()) {
						addHorizontalLine(out);
						out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.replace("
								+ oldChar + "," + newChar
								+ ")</u>= <font size=\"4\" color=\"blue\">"
								+ lengthOfString.replace(oldChar, newChar)
								+ "</font></b><br>");
					}
				}
			} catch (RuntimeException e1) {
				// IGNORE

			}

			try {
				// ReplaceAll
				if (regex != null && !regex.isEmpty()) {
					if (replacement != null) {
						addHorizontalLine(out);
						out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.replaceAll("
								+ regex + "," + replacement
								+ ")</u>= <font size=\"4\" color=\"blue\">"
								+ lengthOfString.replaceAll(regex, replacement)
								+ "</font></b><br>");
					}
				}
			} catch (RuntimeException e) {
				// IGNORE
			}
			
			//Substring
			try {
				if (beginIndex != null && !beginIndex.isEmpty()) {
					addHorizontalLine(out);
					int intbeginIndex = Integer.valueOf(beginIndex);
					out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.substring("
							+ beginIndex
							+ ")</u>= <font size=\"4\" color=\"blue\">"
							+ lengthOfString.substring(intbeginIndex)
							+ "</font></b><br>");
					if (endIndex != null && !endIndex.isEmpty()) {
						int intendIndex = Integer.valueOf(endIndex);
						out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.substring("
								+ beginIndex + "," + endIndex
								+ ")</u>= <font size=\"4\" color=\"blue\">"
								+ lengthOfString.substring(intbeginIndex, intendIndex)
								+ "</font></b><br>");
					}
				}
			} catch (RuntimeException e1) {
				// IGNORE

			}

			//trimWhitespace
			final String trimWhitespace = request.getParameter("trimWhitespace");
			if(trimWhitespace!=null && !trimWhitespace.isEmpty())
			{
				addHorizontalLine(out);
				out.println("<b><u>.trimWhitespace("
						+ lengthOfString 
						+ ")</u>= <font size=\"4\" color=\"blue\">"
						+ org.springframework.util.StringUtils.trimWhitespace(lengthOfString)
						+ "</font></b><br>");
			}
			
			//trimLeadingWhitespace
			final String trimLeadingWhitespace = request.getParameter("trimLeadingWhitespace");
			if(trimLeadingWhitespace!=null && !trimLeadingWhitespace.isEmpty())
			{
				addHorizontalLine(out);
				out.println("<b><u>.trimLeadingWhitespace("
						+ lengthOfString 
						+ ")</u>= <font size=\"4\" color=\"blue\">"
						+ org.springframework.util.StringUtils.trimLeadingWhitespace(lengthOfString)
						+ "</font></b><br>");
			}
			
			//
			
			//trimTrailingWhitespace
			final String trimTrailingWhitespace = request.getParameter("trimTrailingWhitespace");
			if(trimTrailingWhitespace!=null && !trimTrailingWhitespace.isEmpty())
			{
				addHorizontalLine(out);
				out.println("<b><u>.trimTrailingWhitespace("
						+ lengthOfString 
						+ ")</u>= <font size=\"4\" color=\"blue\">"
						+ org.springframework.util.StringUtils.trimTrailingWhitespace(lengthOfString)
						+ "</font></b><br>");
			}
			
			return;

		}

		// Actual logic goes here.

	}

	private void processIndexOff(final String indexOf, final String fromIndex,
			PrintWriter out, final String lengthOfString, boolean isLastIndexOf) {
		// Index Off Processing
		if (indexOf != null && !indexOf.isEmpty()) {
			try {

				addHorizontalLine(out);
				if (!isLastIndexOf) {
					out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.indexOf(" + indexOf
							+ ")</u> = <font size=\"4\" color=\"blue\">"
							+ lengthOfString.indexOf(indexOf)
							+ "</font></b><br>");
				} else {
					out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.lastIndexOf("
							+ indexOf
							+ ")</u> =<font size=\"4\" color=\"blue\"> "
							+ lengthOfString.lastIndexOf(indexOf)
							+ "</font></b><br>");
				}

				if (fromIndex != null && !fromIndex.isEmpty()) {
					int fromIn = Integer.valueOf(fromIndex);
					if (!isLastIndexOf) {
						out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.indexOf("
								+ indexOf + "," + fromIndex
								+ ")</u> =<font size=\"4\" color=\"blue\"> "
								+ lengthOfString.indexOf(indexOf, fromIn)
								+ "</font></b><br>");
					} else {
						out.println("<font size=\"6\" color=\"green\">" + lengthOfString + "</font>" + "<b><u>.lastIndexOf("
								+ indexOf + "," + fromIndex
								+ ")<u> = <font size=\"4\" color=\"blue\">"
								+ lengthOfString.lastIndexOf(indexOf, fromIn)
								+ "</font></b><br>");
					}

				}

			} catch (RuntimeException e) {

			}

		}
	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	


}
