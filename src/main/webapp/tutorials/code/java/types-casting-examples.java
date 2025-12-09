public class Main {
    public static void main(String[] args) {
        System.out.println("--- Type Promotion in Expressions ---");

        byte a = 40;
        byte b = 50;
        byte c = 100;

        // byte d = a * b / c; // Error!
        // Result of (a * b) is promoted to INT intermediate value (2000)

        int d = a * b / c; // Correct
        System.out.println("Result: " + d);

        System.out.println("\n--- Mixed Type Expressions ---");
        int i = 50000;
        float f = 5.67f;
        double db = .1234;

        // The entire expression is promoted to the largest type (double)
        double result = (f * a) + (i / c) - (db * b);

        System.out.println("f * a = " + (f * a) + " (float)");
        System.out.println("i / c = " + (i / c) + " (int)");
        System.out.println("db * b = " + (db * b) + " (double)");
        System.out.println("Final Result: " + result + " (double)");
    }
}
