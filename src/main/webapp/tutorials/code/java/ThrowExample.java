public class ThrowExample {

    // Method using 'throw' to validation logic
    static void checkAge(int age) {
        if (age < 18) {
            throw new ArithmeticException("Access denied - Age must be at least 18.");
        } else {
            System.out.println("Access granted - You are old enough!");
        }
    }

    // Method using 'throws' to declare a checked exception
    static void riskyMethod() throws Exception {
        System.out.println("Inside risky method...");
        throw new Exception("This is a generic Checked Exception!");
    }

    public static void main(String[] args) {
        // 1. Unchecked Exception (Runtime)
        try {
            checkAge(15);
        } catch (ArithmeticException e) {
            System.out.println("Caught Runtime Error: " + e.getMessage());
        }

        // 2. Checked Exception (Compile-time enforcement)
        try {
            riskyMethod();
        } catch (Exception e) {
            System.out.println("Caught Checked Error: " + e.getMessage());
        }
    }
}
