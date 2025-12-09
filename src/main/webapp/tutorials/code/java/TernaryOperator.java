public class TernaryOperator {
    public static void main(String[] args) {
        int a = 20;
        int b = 15;

        // Traditional If-Else
        // int max;
        // if (a > b) max = a; else max = b;

        // Ternary Operator
        int max = (a > b) ? a : b;
        System.out.println("Maximum of " + a + " and " + b + " is: " + max);

        // String example
        int age = 18;
        String status = (age >= 18) ? "Adult" : "Minor";
        System.out.println("Age " + age + " status: " + status);

        // Nested Ternary (Positive, Negative, Zero)
        int num = -5;
        String sign = (num > 0) ? "Positive" : ((num < 0) ? "Negative" : "Zero");
        System.out.println("Number " + num + " is: " + sign);
    }
}
