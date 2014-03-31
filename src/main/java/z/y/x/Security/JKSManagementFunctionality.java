package z.y.x.Security;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.security.Key;
import java.security.cert.Certificate;
import java.security.interfaces.RSAPrivateCrtKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import security.JKS;
import security.JKSViewer;
import security.javaConversion;

/**
 * 24 March 204
 * 
 * @author Anish Nath
 * 
 */
public class JKSManagementFunctionality extends HttpServlet {

	static Map<String, byte[]> map = new HashMap<String, byte[]>();
	/**
	 * 
	 */
	private static final long serialVersionUID = 2920672111839687204L;

	private final String GET_ALL_ALIAS = "GET_ALL_ALIAS";

	private long maxFileSize = 10485760l;

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		if ("yes".equals(request.getParameter("invalidate"))) {

			if (request.getSession() != null) {
				request.getSession().invalidate();
				request.getRequestDispatcher("jks.jsp").forward(request,
						response);
				;
				return;
			}
		}

		doPost(request, response); // PUSH

	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// System.out.println("doPost Called");
		HttpSession session = request.getSession(true);
		session.setAttribute("Error", "");

		Map<String, Object> requestParameter = new HashMap<String, Object>();
		String md = "";
		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(
				getDiskFileFactory(request));

		try {
			List<FileItem> items = upload.parseRequest(request);
			// Process the uploaded items
			Iterator<FileItem> iter = items.iterator();
			while (iter.hasNext()) {
				FileItem item = iter.next();

				// Process a file upload
				if (!item.isFormField()) {
					String fieldName = item.getFieldName();
					String fileName = item.getName();
					String contentType = item.getContentType();
					boolean isInMemory = item.isInMemory();
					long sizeInBytes = item.getSize();

					if (sizeInBytes < maxFileSize) {
						requestParameter.put(fieldName, item);
					} else {
						throw new Exception("File Size is greater then 10MB");
					}

					if (sizeInBytes > 0) {
						// check it's diffrent file or the Same file
						final String md5 = MDFunctionality.CalcualateMD5("MD5",
								item.get(), "BC");
						if (map.get(md5) == null) {
							// File Doesn't Exists In Map
							map.put(md5, item.get());

							session.setAttribute("aliasName", null);
							session.setAttribute("displayAliasesDetails", null);
						}
					}

					// System.out.println(sizeInBytes);

				} else {
					String name = item.getFieldName();
					String value = item.getString();
					requestParameter.put(name, value);
					// System.out.println("name =" + name + " value =" + value);
				}
			} // end while

			final String getDetails = (String) requestParameter
					.get("GetDetails");
			final String alias = (String) requestParameter.get("aliasname");
			md = (String) requestParameter.get("md5");
			final FileItem item = (FileItem) requestParameter.get("upfile");
			final String keyStorePassword = (String) requestParameter
					.get("storepassword");

			byte[] b = null;
			final String export = (String) requestParameter.get("export");
			// Initial Request
			if (getDetails == null && export == null) {
				b = item.get();
				final String md5 = MDFunctionality
						.CalcualateMD5("MD5", b, "BC");
				map.put(md5, item.get());
				session.setAttribute("md5", md5);

			}
			// Cruel Logic
			if (getDetails != null || export != null) {
				b = map.get(md);
			}

			// session.setAttribute("aliasName", alias);

			List<String> aliasName = new ArrayList<String>();
			if (alias != null) {
				aliasName.add(alias);
			}

			session.setAttribute("storepassword", keyStorePassword);
			session.setAttribute("displayAliases",
					hitKeyStore(b, null, keyStorePassword));
			// session.setAttribute("displayAliasesDetails",null);
			if (aliasName.size() > 0) {
				
				session.setAttribute("aliasName", alias);
				session.setAttribute("displayAliasesDetails",
						hitKeyStore(b, aliasName, keyStorePassword));
			}

			if (export != null) {
				// Check if Password is Present
				if (keyStorePassword == null) {
					throw new Exception("Please Provive KeyStore Password");
				}

				Map<String, Object> m = aliasExport(b, alias, keyStorePassword);
				System.out.println(m);
				Certificate certificate = (Certificate) m.get(alias);
				StringBuilder builder = new StringBuilder();
				if (certificate != null) {
					builder.append("-----BEGIN CERTIFICATE-----\n");
					String encoded = new sun.misc.BASE64Encoder()
							.encode(certificate.getEncoded());
					builder.append(encoded);
					builder.append( "\n-----END CERTIFICATE-----\n");
				}
				Key key  = (Key) m.get("key");
				
				if(key!=null)
				{
					builder.append("-----BEGIN PRIVATE KEY-----\n" );
					String encoded = new sun.misc.BASE64Encoder()
					.encode(key.getEncoded());
					builder.append(encoded);
					builder.append("\n-----END PRIVATE KEY-----\n");
				}
				
				response.setContentType("text/html");
				final String filenameToExport = alias + "export.txt";
				response.addHeader("Content-Disposition", "attachment; filename="+filenameToExport+"");
				byte[] buffer = new byte[8192];
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ServletOutputStream os       = response.getOutputStream();
				os.write(builder.toString().getBytes("UTF-8"));
				
				return; 

			}

		} catch (Exception e) {
			session.setAttribute("Error", e.getMessage());
			// e.printStackTrace();
			//map.remove(md);
		}

		// request.setAttribute("theKeyStore", uu);
		response.sendRedirect("jks.jsp");

		return;

	}

	/**
	 * @param request
	 * @return
	 */
	private DiskFileItemFactory getDiskFileFactory(HttpServletRequest request) {
		// Check that we have a file upload request
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);

		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Configure a repository (to ensure a secure temp location is used)
		ServletContext servletContext = this.getServletConfig()
				.getServletContext();
		File repository = (File) servletContext
				.getAttribute("javax.servlet.context.tempdir");
		factory.setRepository(repository);
		return factory;
	}

	/**
	 * @param request
	 * @param response
	 * @param item
	 * @return
	 * @throws Exception
	 */
	private Map<String, Object> hitKeyStore(byte[] item, List<String> alias,
			final String password) throws Exception {

		return processJKS(item, alias, password);

	}

	/**
	 * 
	 */
	private static Map<String, Object> processJKS(byte[] b,
			final List<String> aliases, final String password) throws Exception {

		if (b == null) {
			throw new Exception("Please provide the KeyStore");
		}
		// byte[] b = new byte;
		JKSViewer jks = new JKS(b, password);

		Map<String, Object> map = new HashMap<String, Object>();
		if (aliases == null) {
			List<String> str = javaConversion.listAsJavaString(jks
					.listAllAliases());
			map.put("aliases", str);
		} else {
			map = javaConversion.mapAsJavaObject(jks
					.listByAliases(javaConversion.listAsScalaObject(aliases)));
		}

		// System.out.println(map);
		return map;

	}

	private static Map<String, Object> aliasExport(byte[] b,
			final String aliasName, final String password) throws Exception {

		if (b == null) {
			throw new Exception("Please provide the KeyStore");
		}
		// byte[] b = new byte;
		JKSViewer jks = new JKS(b, password);

		Map<String, Object> map = new HashMap<String, Object>();

		map = javaConversion.mapAsJavaObject(jks.aliasExport(aliasName));

		// System.out.println(map);
		return map;

	}

	public static void main(String[] args) throws ServletException, IOException {
		new JKSManagementFunctionality().doPost(null, null);
	}

}
