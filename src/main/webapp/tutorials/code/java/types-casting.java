public class Main {
    public static void main(String[] args) {
        System.out.println("--- Widening (Automatic) ---");
        int myInt = 9;
        double myDouble = myInt; // Automatic casting: int to double

        System.out.println("int value: " + myInt);
        System.out.println("double value: " + myDouble);

        System.out.println("\n--- Narrowing (Manual) ---");
        double pi = 3.14159;
        int piInt = (int) pi; // Manual casting: double to int

        System.out.println("double value: " + pi);
        System.out.println("int value (truncated): " + piInt);

        System.out.println("\n--- Data Loss Warning ---");
        int bigNum = 130;
        byte smallNum = (byte) bigNum; // -128 to 127

        System.out.println("Original int: " + bigNum);
        System.out.println("Casted byte: " + smallNum);
        // 130 in binary is 10000010.
        // byte is signed 8-bit, so 10000010 represents -126
    }
}
