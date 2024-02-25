package z.y.x.aws.s3;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class S3EncryptedDownloadFunctionality extends HttpServlet {
	private static final long serialVersionUID = 2L;
	private static final String BUCKET_NAME = "f81821f2";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		final String PAGE_NAME= "/share-file-download.jsp";

		if (null == request.getPathInfo() || request.getPathInfo().length() == 0) {
			response.sendRedirect("share-file.jsp");
			return;
		}

		HttpSession session = request.getSession(true);

		String shortCode = request.getPathInfo().substring(1); // Extract short code from the URL

		S3UrlShortner s3UrlShortner = new S3UrlShortner();
		String fileName = s3UrlShortner.getfileName(shortCode);

		if (fileName != null) {
			S3PresignedUrlGenerator presignedUrlGenerator = new S3PresignedUrlGenerator();
			boolean isFileExist = presignedUrlGenerator.isObjectExist(BUCKET_NAME, fileName);
			if (isFileExist) {
				s3UrlShortner.updateClickCount(shortCode);
				String myURL = presignedUrlGenerator.getPresignedUrl(BUCKET_NAME, fileName);

				if (session != null) {
					session.setAttribute("presignedUrl", myURL);
					session.setAttribute("file_name", fileName);
				}

				response.sendRedirect(request.getContextPath() + PAGE_NAME);
//				session.setAttribute("helloWorld", "Hello world");
////				String jsonResponse = "{\"presignedUrl\":\"" + myURL.toString() + "\"}";
//				request.setAttribute("presignedUrl", myURL);
//				request.setAttribute("file_name", fileName);
//				request.getRequestDispatcher("/pgp-download.jsp").forward(request, response);
			} else {
				session.setAttribute("presignedUrl", null);
				session.setAttribute("file_name", fileName);
				response.sendRedirect(request.getContextPath() + PAGE_NAME);

			}

		} else {
			session.setAttribute("presignedUrl", null);
			session.setAttribute("file_name", fileName);
			response.sendRedirect(request.getContextPath() + PAGE_NAME);

		}

	}
}
