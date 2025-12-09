// Singleton Pattern - ensures only one instance exists
public class DatabaseConnection {
    // Private static instance
    private static DatabaseConnection instance;
    
    // Private constructor prevents instantiation from outside
    private DatabaseConnection() {
        System.out.println("Database connection created");
    }
    
    // Public static method to get the instance
    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }
    
    public void connect() {
        System.out.println("Connected to database");
    }
    
    public void disconnect() {
        System.out.println("Disconnected from database");
    }
}

// Usage
public class SingletonDemo {
    public static void main(String[] args) {
        // Both references point to the same instance
        DatabaseConnection conn1 = DatabaseConnection.getInstance();
        DatabaseConnection conn2 = DatabaseConnection.getInstance();
        
        System.out.println("Same instance? " + (conn1 == conn2));  // true
        
        conn1.connect();
        conn2.disconnect();
    }
}

