package z.y.x.urlshortner;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import z.y.x.r.LoadPropertyFileFunctionality;

public class ConnectionFactory {

    private static final String DB_URL = "jdbc:sqlite:"
            +  LoadPropertyFileFunctionality.getConfigProperty().get("sqlite");

    // Private constructor to prevent instantiation
    private ConnectionFactory() {
    }

    // Method to get a connection to the database
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.sqlite.JDBC");
            return DriverManager.getConnection(DB_URL);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQLite JDBC Driver not found", e);
        }
    }

    // Method to close a connection
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Handle the exception properly in a real application
            }
        }
    }
}
