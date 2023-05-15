package z.y.x.blockchain;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.google.gson.Gson;

import z.y.x.r.LoadPropertyFileFunctionality;

/**
 * Created by aninath on 11/05/2023. For Demo Visit https://8gwifi.org
 */
public class ETHFunctionality extends HttpServlet {
	private static final long serialVersionUID = 2L;
	private static final String ETH_NODEKEY = "ETH_NODEKEY";

	public ETHFunctionality() {

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession(true);
		response.sendRedirect("eth-keygen.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		final String methodName = request.getParameter("methodName");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession(true);

		if (ETH_NODEKEY.equals(methodName)) {

			final String keytype = request.getParameter("key-type");
			final String ip = request.getParameter("ip");
			String signEnabled = request.getParameter("sign");
			final String tcpPort = request.getParameter("tcp");
			final String udpPort = request.getParameter("udp");
			final String keyTypeP2P = request.getParameter("keyType");
			String seed = request.getParameter("seed");
			String seedValue = request.getParameter("seedValue");
			String marshal_protobuf = request.getParameter("marshal_protobuf");

			// System.out.println("encryptdecryptparameter " +encryptdecryptparameter);

			if (null == keytype || keytype.trim().length() == 0) {
				addHorizontalLine(out);
				out.println("<font size=\"2\" color=\"red\"> Key Type is Null or EMpty....</font>");
				return;
			}

			// This is Sign Message
			if ("devp2p".equals(keytype)) {
				if (ip != null && ip.trim().length() > 0) {
					try {

						if (signEnabled != null && signEnabled.trim().length() > 0) {
							if ("enabled".equals(signEnabled)) {
								signEnabled = "true";
							} else {
								signEnabled = "false";
							}
						} else {
							signEnabled = "false";
						}

						String payload = "{\n" + "    \"ip\": \"" + ip + "\",\n" + "    \"sign\": "
								+ Boolean.valueOf(signEnabled) + " ,\n" + "    \"tcp\": " + Integer.valueOf(tcpPort)
								+ " ,\n" + "    \"udp\":  " + Integer.valueOf(udpPort) + "\n" + "}";

						String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("blockchain")
								+ "generateDevp2pNodeKey";
						// Create the HTTP POST request
						HttpPost postRequest = new HttpPost(url1);
						postRequest.setHeader("Content-type", "application/json");
						postRequest.setEntity(new StringEntity(payload));

						// Create the HTTP client and execute the request
						HttpClient client = HttpClients.createDefault();
						HttpResponse postResponse = client.execute(postRequest);

						// Extract the response entity as a string
						HttpEntity entity = postResponse.getEntity();

						if (postResponse.getStatusLine().getStatusCode() != 200) {
							if (postResponse.getStatusLine().getStatusCode() == 400) {
								BufferedReader br1 = new BufferedReader(
										new InputStreamReader((postResponse.getEntity().getContent())));
								StringBuilder content1 = new StringBuilder();
								String line;
								while (null != (line = br1.readLine())) {
									content1.append(line);
								}
								addHorizontalLine(out);
								out.println(
										"<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
								return;
							} else {
								addHorizontalLine(out);
								out.println(
										"<p><font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font></p>");
								return;
							}

						}

						Gson gson = new Gson();
						String responseString = EntityUtils.toString(entity);
//						System.out.println(responseString);
//
						String result = gson.fromJson(responseString, BlockChainResponse.class).getResult();
//
						addHorizontalLine(out);
						out.println(
								"<p><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"10\" cols=\"90\">"
										+ result + "</textarea></p>");

						if (postRequest != null ){
							postRequest.releaseConnection();
						}

					} catch (Exception e) {
						addHorizontalLine(out);
						out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
					}

				} else {
					addHorizontalLine(out);
					out.println("<p><font size=\"2\" color=\"red\"> Something went Wrong </font></p>");
				}
			}

			if ("libp2p".equals(keytype)) {



				if ("enabled".equals(marshal_protobuf)) {
					marshal_protobuf = "true";
				} else {
					marshal_protobuf = "false";
				}

				if ("enabled".equals(seed)) {
					seed = "true";
				} else {
					seed = "false";
				}

				if (null == seedValue || seedValue.trim().length() == 0) {
					seedValue="0";

				}


				try {
					String payload = "{\n" + "    \"seed\": " + Boolean.valueOf(seed) + ",\n" + "    \"seed_value\": "
							+ Integer.valueOf(seedValue) + ",\n" + "    \"marshal_protobuf\": "
							+ Boolean.valueOf(marshal_protobuf) + ",\n" + "    \"keyType\": " + Integer.valueOf(keyTypeP2P) + "\n"
							+ "}";

//					System.out.println(payload);

					String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("blockchain")
							+ "generateLibp2pNodeKey";
					// Create the HTTP POST request
					HttpPost postRequest = new HttpPost(url1);
					postRequest.setHeader("Content-type", "application/json");
					postRequest.setEntity(new StringEntity(payload));

					// Create the HTTP client and execute the request
					HttpClient client = HttpClients.createDefault();
					HttpResponse postResponse = client.execute(postRequest);

					// Extract the response entity as a string
					HttpEntity entity = postResponse.getEntity();

					if (postResponse.getStatusLine().getStatusCode() != 200) {
						if (postResponse.getStatusLine().getStatusCode() == 400) {
							BufferedReader br1 = new BufferedReader(
									new InputStreamReader((postResponse.getEntity().getContent())));
							StringBuilder content1 = new StringBuilder();
							String line;
							while (null != (line = br1.readLine())) {
								content1.append(line);
							}
							addHorizontalLine(out);
							out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
							return;
						} else {
							addHorizontalLine(out);
							out.println(
									"<p><font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font></p>");
							return;
						}

					}

					Gson gson = new Gson();
					String responseString = EntityUtils.toString(entity);
//						System.out.println(responseString);
//
					String result = gson.fromJson(responseString, BlockChainResponse.class).getResult();
//
					addHorizontalLine(out);
					out.println(
							"<p><textarea name=\"encrypedmessagetextarea\" class=\"form-control\" readonly=\"true\"  id=\"encrypedmessagetextarea\" rows=\"20\" cols=\"70\">"
									+ result + "</textarea></p>");

				} catch (Exception e) {
					addHorizontalLine(out);
					out.println("<font size=\"2\" color=\"red\"> " + e + "</font>");
				}

			} // END Main If Condition

		}
	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	private static class BlockChainResponse {
		private String result;

		public String getResult() {
			return result;
		}

		public void setResult(String result) {
			this.result = result;
		}
	}

}