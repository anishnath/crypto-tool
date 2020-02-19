package z.y.x.String;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;




import javax.json.stream.JsonParser;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class JSONFunctionality
 */

public class JSONFunctionality extends HttpServlet {
	private static final long serialVersionUID = 1L;

	final String METHOD_FORMATJSON = "formatjson";

	/**
	 * Default constructor.
	 */
	public JSONFunctionality() {
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
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");

		final String methodName = request.getParameter("methodName");
		PrintWriter out = response.getWriter();


		if (METHOD_FORMATJSON.equalsIgnoreCase(methodName)) {

			final String jsonString = request.getParameter("input");


			JSONParser parser = new JSONParser();

			JSONObject json = null;
			try {
				json = (JSONObject) parser.parse(jsonString);
			} catch (ParseException e) {
				addHorizontalLine(out);
				out.println("<font size=\"3\" color=\"red\"><b> Problem "
						+ e

						+ "</font></b><br>");
				return;
			}


			Gson gson = new GsonBuilder().setPrettyPrinting().create();
			String prettyJson = gson.toJson(json);

			addHorizontalLine(out);
			out.println("<h4 class=\"mt-4\">JSON</h4>");
			out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"15\" cols=\"40\">" + prettyJson + "</textarea>");


			out.println("<h4 class=\"mt-4\">Equivalent YAML</h4>");
			out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=15  form=\"X\">" + asYaml(prettyJson) + "</textarea>");

			return;

			// Actual logic goes here.

		}

	}



	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	public String asYaml(String jsonString) throws JsonProcessingException, IOException {
		// parse JSON
		JsonNode jsonNodeTree = new ObjectMapper().readTree(jsonString);
		// save it as YAML
		String jsonAsYaml = new YAMLMapper().writeValueAsString(jsonNodeTree);
		return jsonAsYaml;
	}

}
