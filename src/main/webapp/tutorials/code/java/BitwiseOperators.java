public class BitwiseOperators {
    public static void main(String[] args) {
        int a = 5; // Binary: 0000 0101
        int b = 3; // Binary: 0000 0011

        System.out.println("a = 5 (" + Integer.toBinaryString(a) + ")");
        System.out.println("b = 3 (" + Integer.toBinaryString(b) + ")");

        // Bitwise AND (&)
        // 0101 & 0011 = 0001 (1)
        int andResult = a & b;
        System.out.println("a & b = " + andResult);

        // Bitwise OR (|)
        // 0101 | 0011 = 0111 (7)
        int orResult = a | b;
        System.out.println("a | b = " + orResult);

        // Bitwise XOR (^)
        // 0101 ^ 0011 = 0110 (6)
        int xorResult = a ^ b;
        System.out.println("a ^ b = " + xorResult);

        // Left Shift (<<)
        // 0101 << 1 = 1010 (10)
        int leftShift = a << 1;
        System.out.println("a << 1 = " + leftShift);

        // Right Shift (>>)
        // 0101 >> 1 = 0010 (2)
        int rightShift = a >> 1;
        System.out.println("a >> 1 = " + rightShift);
    }
}
