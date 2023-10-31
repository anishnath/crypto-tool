package z.y.x.urlshortner;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.google.gson.Gson;

import z.y.x.r.LoadPropertyFileFunctionality;

public class URLShortnerFunctionality extends HttpServlet {
	private static final long serialVersionUID = 2L;

	private static final String DB_URL = "jdbc:sqlite:"
			+ LoadPropertyFileFunctionality.getConfigProperty().get("sqlite");

	private static final String METHOD_CREATE_SHORTNER_URL = "CREATE_SHORTNER_URL";
	private static final String METHOD_GET_SHORTNER_URL = "GET_SHORTNER_UR";

	private static final String CREATE_TABLE_SQL = "CREATE TABLE url_shortener (\n"
			+ "    id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
			+ "    original_url TEXT NOT NULL,\n"
			+ "    short_code TEXT NOT NULL,\n"
			+ "    group_name TEXT NOT NULL,\n"
			+ "    click_count INTEGER DEFAULT, 0\n"
			+ "    active INTEGER DEFAULT, 0\n"
			+ "    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP"
			+ ");";

	public URLShortnerFunctionality() {

	}


	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		

		if (null == request.getPathInfo() || request.getPathInfo().length() == 0) {
			response.sendRedirect("short.jsp");
			return;
		}

		String shortCode = request.getPathInfo().substring(1); // Extract short code from the URL

		System.out.println("shortCode--" + shortCode);
		String originalUrl = getOriginalUrl(shortCode);

		if (originalUrl != null) {
			updateClickCount(shortCode);
			response.sendRedirect(originalUrl);
		} else {
			RequestDispatcher dispatcher = request.getRequestDispatcher("short.jsp");
		    dispatcher.forward(request, response);

		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		final String methodName = request.getParameter("methodName");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		String originalUrl = request.getParameter("url");
		
		String group = request.getParameter("group");

        // If no group is specified, create a default group
        if (group == null || group.isEmpty()) {
            group =  generateShortCode();
        }
        
        String sessionId = request.getSession().getId();
		String j_session_id = request.getParameter("j_csrf");
		
		if(!sessionId.equalsIgnoreCase(j_session_id))
		{
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("short.jsp");
		    dispatcher.forward(request, response);
			return;
		}

		System.out.println(originalUrl);

		String shortCode = getShortCode(originalUrl,group);
		

		String shortenedUrl = "s/" + shortCode;

		int clickCount = getClickCountFromDatabase(shortCode);

		JSONObject jsonResponse = new JSONObject();
		jsonResponse.put("shortUrl", shortenedUrl);
		jsonResponse.put("clickCount", clickCount);
		jsonResponse.put("group", group);
		
		List<UrlData> liDatas = getUrlsByGroupFromDatabase(group);
		
		
		Gson gson = new Gson();
	    String urlDataJson = gson.toJson(liDatas);
	    
	    jsonResponse.put("lurls", liDatas);
	    
	    

//		// Set content type and write JSON response
//		response.setContentType("application/json");
//		response.getWriter().write(jsonResponse.toString());
//		response.getWriter().write(urlDataJson.toString());
	    


	    // Write both JSON responses to the response writer
	    out.print(jsonResponse.toString());
	    //out.print(urlDataJson);

	    // Close the response writer
	    out.flush();
	    out.close();

	}

	private String getShortCode(String originalUrl, String group_name) {
		String shortCode = null;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			// Check if the URL is already in the database
			connection = ConnectionFactory.getConnection();
			String query = "SELECT short_code FROM url_shortener WHERE original_url = ? and group_name = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, originalUrl);
			preparedStatement.setString(2, group_name);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				// If the URL is already in the database, return the existing short code
				shortCode = resultSet.getString("short_code");
			} else {
				// If the URL is not in the database, generate a new short code
				shortCode = generateShortCode();

				// Save the new URL and short code to the database
				query = "INSERT INTO url_shortener (original_url, short_code, click_count, group_name) VALUES (?, ?, 0, ?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, originalUrl);
				preparedStatement.setString(2, shortCode);
				preparedStatement.setString(3, group_name);
				preparedStatement.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace(); // Handle the exception properly in a real application
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}

		return shortCode;
	}

	private String getOriginalUrl(String shortCode) {
		String originalUrl = null;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "SELECT original_url FROM url_shortener WHERE short_code = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, shortCode);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				originalUrl = resultSet.getString("original_url");
			}
		} catch (SQLException e) {
			e.printStackTrace(); // Handle the exception properly in a real application
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}

		return originalUrl;
	}

	private String generateShortCode() {
		// Implement your short code generation logic (e.g., Base64 encoding)
		byte[] bytes = new byte[5]; // Generate a 5-byte array for short code
		new java.security.SecureRandom().nextBytes(bytes);
		return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}

	private List<UrlData> getUrlsByGroupFromDatabase(String group) {
		List<UrlData> urls = new ArrayList();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		try {

			connection = ConnectionFactory.getConnection();
			preparedStatement = connection.prepareStatement("SELECT * FROM url_shortener WHERE group_name = ?");
			preparedStatement.setString(1, group);
			ResultSet resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				UrlData urlData = new UrlData();
				urlData.setId(resultSet.getInt("id"));
				urlData.setOriginalUrl(resultSet.getString("original_url"));
				urlData.setShortCode(resultSet.getString("short_code"));
				urlData.setClickCount(resultSet.getInt("click_count"));
				urls.add(urlData);
			}
		} catch (SQLException e) {
			e.printStackTrace(); // Handle the exception properly in a real application
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}
		return urls;
	}

	private void updateClickCount(String shortCode) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "UPDATE url_shortener SET click_count = click_count + 1 WHERE short_code = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, shortCode);
			preparedStatement.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace(); // Handle the exception properly in a real application
		} finally {
			try {
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}
	}

	private int getClickCountFromDatabase(String shortCode) {
		int clickCount = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "SELECT click_count FROM url_shortener WHERE short_code = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, shortCode);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				clickCount = resultSet.getInt("click_count");
			}
		} catch (SQLException e) {
			e.printStackTrace(); // Handle the exception properly in a real application
		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
				;
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}

		return clickCount;
	}

}
