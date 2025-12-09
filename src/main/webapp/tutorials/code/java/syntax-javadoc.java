/**
 * This is a JavaDoc comment for the class
 * JavaDoc generates HTML documentation from these comments
 * 
 * @author Your Name
 * @version 1.0
 */
public class JavaDocExample {
    
    /**
     * Calculates the sum of two integers
     * 
     * @param a The first number
     * @param b The second number
     * @return The sum of a and b
     */
    public static int add(int a, int b) {
        return a + b;
    }
    
    /**
     * Main method - entry point of the program
     * 
     * @param args Command-line arguments (not used in this example)
     */
    public static void main(String[] args) {
        int result = add(5, 3);
        System.out.println("Sum: " + result);
    }
}

