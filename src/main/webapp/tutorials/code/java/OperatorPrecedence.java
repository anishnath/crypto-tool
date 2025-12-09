public class OperatorPrecedence {
    public static void main(String[] args) {
        // Multiplication before Addition
        int result1 = 5 + 2 * 3;
        System.out.println("5 + 2 * 3 = " + result1); // 11

        // Using Parentheses
        int result2 = (5 + 2) * 3;
        System.out.println("(5 + 2) * 3 = " + result2); // 21

        // Division/Multiplication (Left to Right)
        // 10 / 2 = 5, then 5 * 5 = 25
        int result3 = 10 / 2 * 5;
        System.out.println("10 / 2 * 5 = " + result3); // 25

        // NOT (10 / (2*5)) = 1

        // Complex example
        // 1. (3+1) = 4
        // 2. 4*4 = 16
        // 3. 50-16 = 34
        int complex = 50 - 4 * (3 + 1);
        System.out.println("50 - 4 * (3 + 1) = " + complex);

        // Pre-increment vs Post-increment precedence
        int a = 5;
        int b = 10;
        // ++a happens first (makes a=6)
        // Then * happens (6 * 10 = 60)
        int res4 = ++a * b;
        System.out.println("++a * b = " + res4);
    }
}
