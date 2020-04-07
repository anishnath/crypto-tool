package z.y.x.String;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.XML;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;


import javax.json.stream.JsonParser;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

/**
 * Servlet implementation class JSONFunctionality
 */

public class JSONFunctionality extends HttpServlet {
	private static final long serialVersionUID = 1L;

	final String METHOD_FORMATJSON = "formatjson";
	final String METHOD_YAML_TO_JSON = "yaml_to_json";
	final String METHOD_XML_TO_JSON = "xml_to_json";

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

		if (METHOD_XML_TO_JSON.equalsIgnoreCase(methodName)) {

			final String xmlString = request.getParameter("input");
			final String style = request.getParameter("style");

			if(null == xmlString || xmlString.trim().length()==0)
			{

				out.println("<font size=\"3\" color=\"red\"><b> Please Input XML Data </font></b><br>");
				return;
			}

			try {
				org.json.JSONObject soapDatainJsonObject = XML.toJSONObject(xmlString);
				//System.out.println(soapDatainJsonObject);

				JSONParser parser = new JSONParser();
				JSONObject json = (JSONObject) parser.parse(soapDatainJsonObject.toString());

				Gson gson = new GsonBuilder().setPrettyPrinting().create();
				String prettyJson = gson.toJson(json);

				addHorizontalLine(out);
				out.println("<h4 class=\"mt-4\">JSON</h4>");
				out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"15\" cols=\"40\">" + prettyJson + "</textarea>");


				out.println("<h4 class=\"mt-4\">Equivalent YAML</h4>");
				out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=15  form=\"X\">" + asYaml(prettyJson) + "</textarea>");

				return;

			}
				catch (Exception e) {
					addHorizontalLine(out);
					out.println("<font size=\"3\" color=\"red\"><b> Problem "
							+ e

							+ "</font></b><br>");
					return;
				}



		}

		if (METHOD_YAML_TO_JSON.equalsIgnoreCase(methodName)) {

			final String yamlString = request.getParameter("input");
			final String style = request.getParameter("style");

			if(null == yamlString || yamlString.trim().length()==0)
			{

				out.println("<font size=\"3\" color=\"red\"><b> Please Input YAML Data </font></b><br>");
				return;
			}


			//DumperOptions options = new DumperOptions();
			//options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
			//options.set
			//options.setPrettyFlow(true);

			try {

				Yaml yaml = new Yaml();
				Map<String,Object> map= (Map<String, Object>) yaml.load(yamlString);
				JSONObject jsonObject=new JSONObject(map);


				String jsonString=jsonObject.toString();

				JSONParser parser = new JSONParser();
				JSONObject json = null;
				try {
					json = (JSONObject) parser.parse(jsonString);



					//System.out.println(xml);

					Gson gson = new GsonBuilder().setPrettyPrinting().create();
					String prettyJson = gson.toJson(json);

					addHorizontalLine(out);
					out.println("<h4 class=\"mt-4\">JSON</h4>");
					out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + prettyJson + "</textarea>");

					String xml = getXMLString(jsonString);

					addHorizontalLine(out);
					out.println("<h4 class=\"mt-4\">XML</h4>");
					out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + xml + "</textarea>");



				} catch (ParseException e) {
					addHorizontalLine(out);
					out.println("<font size=\"3\" color=\"red\"><b> Problem "
							+ e

							+ "</font></b><br>");
					return;
				}



				return;

			}catch (Exception ex) {
				addHorizontalLine(out);
				out.println("<font size=\"3\" color=\"red\"><b> Problem "
						+ ex

						+ "</font></b><br>");
				return;
			}




		}


		if (METHOD_FORMATJSON.equalsIgnoreCase(methodName)) {

			final String jsonString = request.getParameter("input");

			if(null == jsonString || jsonString.trim().length()==0)
			{
				out.println("<font size=\"3\" color=\"red\"><b> Please Input json String </font></b><br>");
				return;
			}


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
				out.println("<h4 class=\"mt-4\">JSON(Beautify)</h4>");
				out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + prettyJson + "</textarea>");


				addHorizontalLine(out);

				out.println("<h4 class=\"mt-4\">Equivalent YAML</h4>");
				out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=10  form=\"X\">" + asYaml(prettyJson) + "</textarea>");

				addHorizontalLine(out);

				String xml = getXMLString(jsonString);

				addHorizontalLine(out);
				out.println("<h4 class=\"mt-4\">Equivalent XML</h4>");
				out.println("<textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"40\">" + xml + "</textarea>");

				return;







			// Actual logic goes here.

		}

	}

	private String getXMLString(String jsonString) {
		org.json.JSONObject jsonObj = new org.json.JSONObject(jsonString);
		return XML.toString(jsonObj);
	}


	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	String convertYamlToJson(String yaml) throws  Exception {
		ObjectMapper yamlReader = new ObjectMapper(new YAMLFactory());
		Object obj = yamlReader.readValue(yaml, Object.class);

		ObjectMapper jsonWriter = new ObjectMapper();
		return jsonWriter.writeValueAsString(obj);
	}

	public String asYaml(String jsonString) throws JsonProcessingException, IOException {
		// parse JSON
		JsonNode jsonNodeTree = new ObjectMapper().readTree(jsonString);
		// save it as YAML
		String jsonAsYaml = new YAMLMapper().writeValueAsString(jsonNodeTree);
		return jsonAsYaml;
	}

}
