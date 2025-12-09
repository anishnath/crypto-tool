// Class name: PascalCase
public class NamingConventions {
    
    // Constants: UPPER_SNAKE_CASE
    private static final int MAX_SIZE = 100;
    private static final String DEFAULT_NAME = "Unknown";
    
    // Variables: camelCase
    private String userName;
    private int totalAmount;
    
    // Method name: camelCase (verb)
    public void setUserName(String name) {
        this.userName = name;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void calculateTotal() {
        totalAmount = 50;
    }
    
    public static void main(String[] args) {
        // Local variables: camelCase
        NamingConventions example = new NamingConventions();
        example.setUserName("John Doe");
        System.out.println("User: " + example.getUserName());
        System.out.println("Max size: " + MAX_SIZE);
    }
}

