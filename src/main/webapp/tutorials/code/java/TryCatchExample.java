public class TryCatchExample {
    public static void main(String[] args) {

        System.out.println("--- Start of Program ---");

        try {
            // 1. Array Index Out of Bounds
            int[] myNumbers = { 1, 2, 3 };
            System.out.println(myNumbers[10]);

            // This line will NOT be executed because error happened above
            System.out.println("This will not print");

        } catch (Exception e) {
            // 2. Handling the error
            System.out.println("Something went wrong!");
            System.out.println("Error Details: " + e.getMessage());
        }

        // 3. Program continues
        System.out.println("--- End of Program (Graceful Exit) ---");

        // --- Another Example with Division ---

        System.out.println("\n--- Division Example ---");
        try {
            int result = 10 / 0;
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Math Error: You cannot divide by zero.");
        }
    }
}
