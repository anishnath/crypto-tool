package z.y.x.blockchain;

import com.google.gson.Gson;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import z.y.x.Security.SendEmail;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

/**
 * Created by aninath on 11/05/2023. For Demo Visit https://8gwifi.org
 */
public class WalletFunctionality extends HttpServlet {
	private static final long serialVersionUID = 2L;
	private static final String WALLET_GEN = "WALLET_GEN";

	public WalletFunctionality() {

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

		if (WALLET_GEN.equals(methodName)) {

			final String words = request.getParameter("words");
			final String language = request.getParameter("language");
			final String path = request.getParameter("path");
			final String root_only = request.getParameter("root_only");
			final String raw_entrypoy = request.getParameter("raw_entrypoy");
			String no_of_address = request.getParameter("no_of_address");
			final String password = request.getParameter("password");
			final String parse_wallet_with_mnemonic = request.getParameter("parse_wallet_with_mnemonic");
			final String mnemonic = request.getParameter("mnemonic");
			final String email = request.getParameter("emailInput");


			if (null == no_of_address || no_of_address.trim().length() == 0) {
				no_of_address = "0";
			}

			try {
				if (Integer.valueOf(no_of_address) > 200) {
					no_of_address = "200";
				}
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				no_of_address = "100";
			}


			String payload = "{\n" + "    \"language\": \"" + language + "\",\n" + "    \"words\": "
					+ Integer.valueOf(words) + " ,\n" + "    \"path\": \"" + path + "\" ,\n" + "    \"password\":  \""
					+ password + "\",\n" + "    \"raw_entrypoy\":  " + Boolean.valueOf(raw_entrypoy) + " ,\n"
					+ "    \"no_of_address\":  " + Integer.valueOf(no_of_address) + " ,\n" + "    \"root_only\":  "
					+ Boolean.valueOf(root_only) + "\n" + "}";


			if ("true".equals(parse_wallet_with_mnemonic) && mnemonic != null && !mnemonic.isEmpty()) {
				int wordCount = mnemonic.trim().split("\\s+").length;
				if (wordCount == 12 || wordCount == 15 || wordCount == 18 || wordCount == 21) {
					payload = "{\n" + "    \"language\": \"" + language + "\",\n" + "    \"words\": "
							+ Integer.valueOf(words) + " ,\n" + "    \"path\": \"" + path + "\" ,\n" + "    \"password\":  \""
							+ password + "\",\n" + "    \"raw_entrypoy\":  " + Boolean.valueOf(raw_entrypoy) + " ,\n"
							+ "    \"no_of_address\":  " + Integer.valueOf(no_of_address) + " ,\n" + "    \"root_only\":  " + Boolean.valueOf(root_only) + ",\n"
							+ "    \"mnemonic\":  \"" + mnemonic + "\"\n" + "}"
							+ Boolean.valueOf(root_only) + "\n" + "}";
				} else {
					addHorizontalLine(out);
					out.println("<font size=\"2\" color=\"red\"> phrase does not have a valid word count.(12/15/18/21) </font>");
					return;
				}
			}

			String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("blockchain") + "generateWallet";
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
				BufferedReader br1 = new BufferedReader(new InputStreamReader((postResponse.getEntity().getContent())));
				StringBuilder content1 = new StringBuilder();
				String line;
				while (null != (line = br1.readLine())) {
					content1.append(line);
				}
				addHorizontalLine(out);
				out.println("<p><font size=\"4\" color=\"red\"> SYSTEM Error  " + content1 + "</font></p>");
				return;
			}
			Gson gson = new Gson();
			String responseString = EntityUtils.toString(entity);
			String result = gson.fromJson(responseString, BlockChainResponse.class).getResult();

			if (postRequest != null ){
				postRequest.releaseConnection();
			}

			String sessionId = request.getSession().getId();
			String j_session_id = request.getParameter("j_csrf");

			if(email!=null && email.length()>3)
			{
				if(!sessionId.equalsIgnoreCase(j_session_id))
				{
					addHorizontalLine(out);
					out.println("<font size=\"2\" color=\"red\"> Invalid CSRF token can't send email. Please refresh the page and Try again....</font>");
					return;
				}
				SendEmail sendEmail = new SendEmail();
				if(sendEmail.isValidEmail(email))
				{

					WalletPojo walletpojo = gson.fromJson(result, WalletPojo.class);
					new Thread(new Runnable() {
						public void run() {
							SendEmail sendEmail = new SendEmail();
							try {

								String result = gson.fromJson(responseString, BlockChainResponse.class).getResult();
//								Addresses addresses = gson.fromJson(result, Addresses.class);



								StringBuilder builder = new StringBuilder();
								builder.append("<h2>Wallet RootKeys Details</h2>");

								if (walletpojo.getDerivationPath() !=null) {
									String walletTable = "<table>" +
											"<tr><td width=10%>RootKey</td><td><code>"
											+walletpojo.getRootKey()
											+"</code></td></tr>"
											+"<tr><td>Seed</td><td><code>"
											+walletpojo.getSeed()
											+ "</code></td></tr>"
											+"<tr><td>Mnemonic</td><td><code>"
											+walletpojo.getMnemonic()
											+ "</code></td></tr>"
											+ "<tr><td width=10%>DerivationPath</td><td><code>"
											+ walletpojo.getDerivationPath()
											+ "</code></td></tr>"
											+ "<tr><td width=10%>AccountPublicKey</td><td><code>"
											+ walletpojo.getAccountPublicKey()
											+ "</code></td></tr>"
											+ "<tr><td width=10%>AccountPrivateKey</td><td><code>"
											+ walletpojo.getAccountPrivateKey()
											+ "</code></td></tr>"
											+ "<tr><td width=10%>BIP32PublicKey</td><td><code>"
											+ walletpojo.getBIP32PublicKey()
											+ "</code></td></tr>"
                                            + "<tr><td width=10%>BIP32PrivateKey</td><td><code>"
											+ walletpojo.getBIP32PrivateKey()
											+ "</code></td></tr>"
											+ "</table>";

									builder.append(walletTable);
								}

								if (walletpojo.getAddresses() !=null) {
									List<Addresses> addresses = walletpojo.getAddresses();
									if (addresses != null && addresses.size() > 0) {
										builder.append("<table>");
										builder.append("<thead><tr><td>Path</td><td>Hex Public Key</td><td>Hex Private Key</td><td>ETH Address</td><td>BTC Address</td><td>WIF</td></tr></thead>");
										for (Iterator iterator = addresses.iterator(); iterator.hasNext(); ) {
											Addresses address = (Addresses) iterator.next();
											builder.append("<tbody><tr><td><code>" + address.getPath() + "</code></td>"
													+ "<td><code>" + address.getHexPublicKey() + "</code></td>"
													+ "<td><code>" + address.getHexPrivateKey() + "</code></td>"
													+ "<td><code>" + address.getETHAddress() + "</code></td>"
													+ "<td><code>" + address.getBTCAddress() + "</code></td>"
													+ "<td><code>" + address.getWIF() + "</code></td></tr></tbody>");
										}
										builder.append("</table>");
									}
								}

								if (walletpojo.getHexPrivateKey() !=null) {
									builder.append("<table>"
											+ "<tr><td>RootKey</td><td><code>"
											+ walletpojo.getRootKey()
											+ "</code></td></tr>"
											+ "<tr><td>Seed</td><td><code>"
											+ walletpojo.getSeed()
											+ "</code></td></tr>"
											+ "<tr><td>BTCAddress</td><td><code>"
											+ walletpojo.getBTCAddress()
											+ "</code></td></tr>"
											+ "<tr><td>ETHAddress</td><td><code>"
											+ walletpojo.getETHAddress()
											+ "</code></td></tr>"
											+ "<tr><td>Ed25519Address</td><td><code>"
											+ walletpojo.getEd25519Address()
											+ "</code></td></tr>"
											+ "<tr><td>Sr25519Address</td><td><code>"
											+ walletpojo.getSr25519Address()
											+ "</code></td></tr>"
											+ "<tr><td>Sr25519AddressSS58</td><td><code>"
											+ walletpojo.getSr25519AddressSS58()
											+ "</code></td></tr>"
											+ "<tr><td>Sr25519AddressSS58</td><td><code>"
											+ walletpojo.getSr25519AddressSS58()
											+ "</code></td></tr>"
											+ "<tr><td>WIF</td><td><code>"
											+ walletpojo.getWIF()
											+ "</code></td></tr>"
											+ "<tr><td>HexPrivateKey</td><td><code>"
											+ walletpojo.getHexPrivateKey()
											+ "</code></td></tr>"
											+ "<tr><td>HexPublicKey</td><td><code>"
											+ walletpojo.getHexPublicKey()
											+ "</code></td></tr>"
											+ "</table>");
								}

								//String subject , String body , String email_to, String url

								sendEmail.sendRawHtml("HD Wallet", builder.toString(), email, "hdwallet.jsp");


							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					}).start();
					walletpojo.setExtraMessage("Email Send Successfully");
					out.print(walletpojo.toString());
//					out.println("<font size=\"2\" color=\"green\"> Email Send Successfully.</font>");
					return;
				}
				else {
					addHorizontalLine(out);
					out.println("<font size=\"2\" color=\"red\"> Invalid Email ...</font>");
					return;
				}
			}

			out.print(result);

		}
	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}

	public static class BlockChainResponse {
		private String result;

		public String getResult() {
			return result;
		}

		public void setResult(String result) {
			this.result = result;
		}
	}

}