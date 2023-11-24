package z.y.x.aws.s3;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import z.y.x.urlshortner.ConnectionFactory;
import z.y.x.urlshortner.UrlData;

public class S3UrlShortner {
	
	public String getShortCode(String file_name, String email) {
		String shortCode = null;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			// Check if the URL is already in the database
			connection = ConnectionFactory.getConnection();
			String query = "SELECT short_code FROM s3_transfer WHERE file_name = ? and active=0 ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, file_name);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				// If the URL is already in the database, return the existing short code
				shortCode = resultSet.getString("short_code");
			} else {
				// If the URL is not in the database, generate a new short code
				shortCode = generateShortCode();

				// Save the new URL and short code to the database
				query = "INSERT INTO s3_transfer (file_name, short_code, click_count, email ) VALUES (?, ?, 0 , ?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, file_name);
				preparedStatement.setString(2, shortCode);
				preparedStatement.setString(3, email);
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
	
	

	public String getfileName(String shortCode) {
		String file_name = null;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "SELECT file_name FROM s3_transfer WHERE short_code = ? and active=0";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, shortCode);
			resultSet = preparedStatement.executeQuery();

			if (resultSet.next()) {
				file_name = resultSet.getString("file_name");
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

		return file_name;
	}

	public String generateShortCode() {
		// Implement your short code generation logic (e.g., Base64 encoding)
		byte[] bytes = new byte[5]; // Generate a 5-byte array for short code
		new java.security.SecureRandom().nextBytes(bytes);
		return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}


	public void updateClickCount(String shortCode) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "UPDATE s3_transfer SET click_count = click_count + 1 WHERE short_code = ?";
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

	public int getClickCountFromDatabase(String shortCode) {
		int clickCount = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			connection = ConnectionFactory.getConnection();
			String query = "SELECT click_count FROM s3_transfer WHERE short_code = ? and active=0";
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
