package z.y.x.t;

import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class TutorialFunctionality extends HttpServlet {

	Map<String, String> scalafileNameMap = new TreeMap<String, String>();

	public void init(ServletConfig config) throws ServletException {
		String path = config.getServletContext().getRealPath("/tutorial/scala");
		String[] directories = new File(path).list();
		if (directories != null) {
			for (int i = 0; i < directories.length; i++) {
				if (directories[i] != null && directories[i].endsWith(".scala")) {
					scalafileNameMap.put(directories[i], directories[i]);
				}

			}
		}
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		HttpSession httpSession = request.getSession(true);

		httpSession.setAttribute("scalafileNameMap", scalafileNameMap);

		String fileName = (String) request.getParameter("fileName");

		if (fileName != null && !fileName.isEmpty()) {
			String filePath = httpSession.getServletContext().getRealPath(
					"/tutorial/scala/")
					+ "/"+ fileName;
			File file = new File(filePath);
			if (file != null && file.exists()) {
				httpSession.setAttribute("fName", fileName);
				httpSession.setAttribute("fileContent",
						readFile(filePath, Charset.forName("UTF-8")));
			}
		}// end if

		response.sendRedirect(request.getContextPath()+"/tutorial/scala/scala.jsp");
	}

	static String readFile(String path, Charset encoding) throws IOException {
		RandomAccessFile raf = null;
		try {
			raf = new RandomAccessFile(path, "r");
			byte[] buffer = new byte[(int) raf.length()];
			raf.readFully(buffer);
			return new String(buffer, encoding);
		} finally {
			closeStream(raf);
		}
	}

	private static void closeStream(Closeable c) {
		if (c != null) {
			try {
				c.close();
			} catch (IOException ex) {
				// do nothing
			}
		}
	}
}
