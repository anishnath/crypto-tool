public class MethodsBasics {

    // 1. Define the method
    static void printGreeting() {
        System.out.println("Hello from a Method!");
    }

    static void printPattern() {
        System.out.println("* * * * *");
        System.out.println(" * * * * ");
        System.out.println("* * * * *");
    }

    // Main execution starts here
    public static void main(String[] args) {
        System.out.println("Main method started.");

        // 2. Call the method
        printGreeting();

        System.out.println("Back in main.");

        // Call another method multiple times
        printGreeting();

        System.out.println("\nPrinting a pattern:");
        printPattern();
    }
}
