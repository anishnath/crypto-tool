package z.y.x.aws.s3;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import z.y.x.Security.SendEmail;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.stream.Collectors;

public class S3Functionality2 extends HttpServlet {
	private static final long serialVersionUID = 2L;
	private static final String BUCKET_NAME = "f81821f2";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String fileName = request.getParameter("fileName");
		String contentType = request.getParameter("contentType");
		String type = request.getParameter("type");


		if (null == type || type.length() == 0) {
			return;
		}

		if ("upload".equalsIgnoreCase(type)) {


			long fileSize = Long.parseLong(request.getParameter("file_size"));
			// Set maximum file size to 100MB
			long maxFileSize = 100 * 1024 * 1024; // 100MB

			// Validate file size
	        if (fileSize > maxFileSize) {
	            response.getWriter().write("File size exceeds the maximum allowed size of 100MB.");
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            return;
	        }


			S3PresignedUrlGenerator s3PresignedUrlGenerator = new S3PresignedUrlGenerator();
			URL presignedRequest = s3PresignedUrlGenerator.createPresignedUrl(BUCKET_NAME, fileName, contentType,
					new HashMap<>());
			String myURL = presignedRequest.toString();
			String jsonResponse = "{\"presignedUrl\":\"" + myURL.toString() + "\"}";
			response.getWriter().write(jsonResponse);
		}

//		if ("download".equalsIgnoreCase(type)) {
//			S3PresignedUrlGenerator s3PresignedUrlGenerator = new S3PresignedUrlGenerator();
//			String myURL = s3PresignedUrlGenerator.getPresignedUrl(BUCKET_NAME, fileName);
//			String jsonResponse = "{\"presignedUrl\":\"" + myURL.toString() + "\"}";
//			request.setAttribute("presignedUrl", myURL);
//			request.getRequestDispatcher("/pgp-download.jsp").forward(request, response);
//
//		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set the response content type
		response.setContentType("application/json");

		// Read the request body
		String requestBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

		// Use Jackson to parse JSON
		ObjectMapper objectMapper = new ObjectMapper();
		JsonNode jsonNode = objectMapper.readTree(requestBody);

		// Extract email and fileName from JSON
		String email = jsonNode.get("email").asText();
		String fileName = jsonNode.get("fileName").asText();
		String cameFrom = jsonNode.get("cameFrom").asText();

		// Print or process the extracted data

		S3UrlShortner s3UrlShortner = new S3UrlShortner();
		String code = s3UrlShortner.getShortCode(fileName, email);

		SendEmail sendEmail = new SendEmail();

//    	String path = request.getContextPath() + "d/" + code;
		String path = request.getRequestURL().toString().replace("presign", "/e/" + code);

		String msg = "" + "        <table>" + "            <thead>" + "                <tr>"
				+ "                    <th scope=\"col\">File Name</th>"
				+ "                    <th scope=\"col\">Download Link</th>" + "                </tr>"
				+ "            </thead>" + "            <tbody>" + "                <tr>" + "                    <td>"
				+ fileName + "</td>" + "                    <td><a href=" + path + " target=\"_blank\">" + path
				+ "</a></td>" + "                </tr>" + "            </tbody>" + "        </table><p> All files will be deleted after 24 hours</p>";

		String headerMessage = "Your Encrypted file "+fileName+ "";
		String pageName = "share-file.jsp";

		if (sendEmail.isValidEmail(email)) {

			if (cameFrom != null && cameFrom.trim().length() > 0) {

				headerMessage = "Your Encrypted file "+fileName+ "";
				pageName = "share-file.jsp";
			}

			String finalHeaderMessage = headerMessage;
			String finalPageName = pageName;
			new Thread(new Runnable() {
				public void run() {
					SendEmail sendEmail = new SendEmail();
					try {
						sendEmail.sendEmail(finalHeaderMessage, msg, email, finalPageName);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}).start();
		}

		response.getWriter().write("{\"status\":\"" + code + "\"}");

	}
}
