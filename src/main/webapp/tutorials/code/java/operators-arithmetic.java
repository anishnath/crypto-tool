public class ArithmeticOperators {
    public static void main(String[] args) {
        // Basic arithmetic
        int result = 10 + 5;
        System.out.println("10 + 5 = " + result);

        result = 10 - 5;
        System.out.println("10 - 5 = " + result);

        result = 10 * 5;
        System.out.println("10 * 5 = " + result);

        // Integer Division vs Double Division
        System.out.println("\n--- Division ---");
        int intDiv = 10 / 3;
        System.out.println("10 / 3 (int) = " + intDiv); // Truncated!

        double doubleDiv = 10.0 / 3.0;
        System.out.println("10.0 / 3.0 (double) = " + doubleDiv); // Precise

        // Modulo
        System.out.println("\n--- Modulo ---");
        int remainder = 10 % 3;
        System.out.println("10 % 3 = " + remainder);

        // Increment/Decrement
        System.out.println("\n--- Increment ---");
        int x = 5;
        System.out.println("Original x: " + x);
        int y = x++; // Post-increment: use x, then increment
        System.out.println("After y = x++: y is " + y + ", x is " + x);

        x = 5; // Reset x
        int z = ++x; // Pre-increment: increment x, then use
        System.out.println("After z = ++x: z is " + z + ", x is " + x);
    }
}
