import java.util.Scanner;

public class BestPracticesExample {
    public static void main(String[] args) {

        System.out.println("--- 1. Swallowing Exceptions (Bad) ---");
        try {
            int x = 10 / 0;
        } catch (Exception e) {
            // Empty catch block = Evil
            // Developer has no idea an error happened!
        }
        System.out.println("Program continues silently (Dangerous)...");

        System.out.println("\n--- 2. Proper Handling (Good) ---");
        try {
            int x = 10 / 0;
        } catch (ArithmeticException e) {
            System.out.println("Error: Cannot divide by zero.");
            // e.printStackTrace(); // Good for debugging
        }

        System.out.println("\n--- 3. Try-with-Resources (Best) ---");
        // This syntax automatically closes the resource (Scanner)
        // even if an exception occurs. No 'finally' needed!
        try (Scanner scanner = new Scanner("Hello World")) {
            while (scanner.hasNext()) {
                System.out.println(scanner.nextLine());
            }
        } catch (Exception e) {
            System.out.println("Scanner Error: " + e.getMessage());
        }
    }
}
