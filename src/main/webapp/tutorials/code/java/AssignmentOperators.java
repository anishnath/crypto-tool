public class AssignmentOperators {
    public static void main(String[] args) {
        int x = 10;
        System.out.println("Initial x: " + x);

        // Add and assign
        x += 5; // x = x + 5
        System.out.println("x += 5: " + x); // 15

        // Multiply and assign
        x *= 2; // x = x * 2
        System.out.println("x *= 2: " + x); // 30

        // Subtract and assign
        x -= 10; // x = x - 10
        System.out.println("x -= 10: " + x); // 20

        // Modulo and assign
        x %= 3; // x = x % 3
        System.out.println("x %= 3: " + x); // 2

        System.out.println("\n--- Hidden Casting Demo ---");
        byte b = 127;
        System.out.println("Initial Byte: " + b);

        // b = b + 1; // This would fail to compile

        b += 1; // Implicitly does: b = (byte)(b + 1)
        System.out.println("b += 1: " + b); // -128 (Overflow!)
    }
}
