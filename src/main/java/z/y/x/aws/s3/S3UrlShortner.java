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

	/**
	 * Insert a new securebin row with expiry + view-cap metadata.
	 * Returns the generated short code.
	 *
	 * expirySeconds: absolute lifetime from now.
	 * maxViews:      0 = unlimited until expiry; N>0 = burn after N successful reads (1 = true burn).
	 */
	public String createSecret(String fileName, String email, long expirySeconds, int maxViews) {
		String shortCode = generateShortCode();
		long now = System.currentTimeMillis() / 1000L;
		long expiresAt = now + expirySeconds;

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		try {
			connection = ConnectionFactory.getConnection();
			String query = "INSERT INTO s3_transfer " +
					"(file_name, short_code, click_count, email, expires_at, max_views, view_count, status, status_updated_at) " +
					"VALUES (?, ?, 0, ?, ?, ?, 0, 'ACTIVE', ?)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, fileName);
			preparedStatement.setString(2, shortCode);
			preparedStatement.setString(3, email);
			preparedStatement.setLong(4, expiresAt);
			preparedStatement.setInt(5, maxViews);
			preparedStatement.setLong(6, now);
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (preparedStatement != null) preparedStatement.close();
				if (connection != null) ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) { e.printStackTrace(); }
		}
		return shortCode;
	}

	/**
	 * Atomically claim one view of a secret. Returns the S3 file name if the row was
	 * ACTIVE, unexpired, and had a view remaining. Otherwise returns null.
	 *
	 * Side effects on success:
	 *   - view_count += 1
	 *   - if the row hit its view cap, the row is DELETED (S3 object is left for manual cleanup).
	 *
	 * On a miss (not found / expired / already burned), opportunistically deletes any
	 * stale row matching the shortcode.
	 */
	public String resolveForView(String shortCode) {
		Connection connection = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection = ConnectionFactory.getConnection();
			long now = System.currentTimeMillis() / 1000L;

			// Atomic claim. SQLite serializes writers so the WHERE-clause check is race-free.
			String updateSql =
					"UPDATE s3_transfer " +
					"   SET view_count = view_count + 1 " +
					" WHERE short_code = ? " +
					"   AND active = 0 " +
					"   AND status = 'ACTIVE' " +
					"   AND expires_at > ? " +
					"   AND (max_views = 0 OR view_count < max_views)";
			ps = connection.prepareStatement(updateSql);
			ps.setString(1, shortCode);
			ps.setLong(2, now);
			int updated = ps.executeUpdate();
			ps.close();
			ps = null;

			if (updated == 0) {
				// Miss. Clean up any stale row for this shortcode.
				String cleanupSql =
						"DELETE FROM s3_transfer " +
						" WHERE short_code = ? " +
						"   AND (expires_at <= ? " +
						"        OR (max_views > 0 AND view_count >= max_views))";
				ps = connection.prepareStatement(cleanupSql);
				ps.setString(1, shortCode);
				ps.setLong(2, now);
				ps.executeUpdate();
				return null;
			}

			// Hit. Read back file_name and check if this view exhausted the cap.
			String selectSql = "SELECT file_name, max_views, view_count FROM s3_transfer WHERE short_code = ?";
			ps = connection.prepareStatement(selectSql);
			ps.setString(1, shortCode);
			rs = ps.executeQuery();
			String fileName = null;
			int maxViews = 0;
			int viewCount = 0;
			if (rs.next()) {
				fileName = rs.getString("file_name");
				maxViews = rs.getInt("max_views");
				viewCount = rs.getInt("view_count");
			}
			rs.close(); rs = null;
			ps.close(); ps = null;

			// If this view burned it, delete the row. S3 cleanup is manual per design.
			if (fileName != null && maxViews > 0 && viewCount >= maxViews) {
				String deleteSql = "DELETE FROM s3_transfer WHERE short_code = ?";
				ps = connection.prepareStatement(deleteSql);
				ps.setString(1, shortCode);
				ps.executeUpdate();
			}
			return fileName;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (rs != null) rs.close();
				if (ps != null) ps.close();
				if (connection != null) ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) { e.printStackTrace(); }
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
