package z.y.x.aws.s3;

import z.y.x.urlshortner.ConnectionFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Repository class that persists PDF cracking submissions into SQLite.
 */
public class PdfPasswordCrackRepository {

    private static final String TABLE_NAME = "pdf_crack_requests";
    private static final String CREATE_TABLE_SQL =
            "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                    "email TEXT NOT NULL," +
                    "file_name TEXT NOT NULL," +
                    "original_file_name TEXT," +
                    "hints TEXT," +
                    "bucket TEXT NOT NULL," +
                    "status TEXT DEFAULT 'QUEUED'," +
                    "file_size INTEGER," +
                    "created_at DATETIME DEFAULT CURRENT_TIMESTAMP" +
                    ")";

    private static final String INSERT_SQL =
            "INSERT INTO " + TABLE_NAME + " (email, file_name, original_file_name, hints, bucket, status, file_size) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

    public PdfPasswordCrackRepository() {
        ensureTable();
    }

    private void ensureTable() {
        Connection connection = null;
        Statement statement = null;
        try {
            connection = ConnectionFactory.getConnection();
            statement = connection.createStatement();
            statement.executeUpdate(CREATE_TABLE_SQL);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            ConnectionFactory.closeConnection(connection);
        }
    }

    /**
     * Persists a new PDF cracking submission and returns the generated numeric identifier.
     */
    public long saveSubmission(String email,
                               String s3ObjectKey,
                               String originalFileName,
                               String hints,
                               String bucket,
                               long fileSizeBytes) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;
        long generatedId = 0L;

        try {
            connection = ConnectionFactory.getConnection();
            preparedStatement = connection.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, s3ObjectKey);
            preparedStatement.setString(3, originalFileName);
            preparedStatement.setString(4, hints);
            preparedStatement.setString(5, bucket);
            preparedStatement.setString(6, "QUEUED");
            preparedStatement.setLong(7, fileSizeBytes);
            preparedStatement.executeUpdate();

            generatedKeys = preparedStatement.getGeneratedKeys();
            if (generatedKeys != null && generatedKeys.next()) {
                generatedId = generatedKeys.getLong(1);
            }
        } finally {
            if (generatedKeys != null) {
                try {
                    generatedKeys.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            ConnectionFactory.closeConnection(connection);
        }

        return generatedId;
    }
}

