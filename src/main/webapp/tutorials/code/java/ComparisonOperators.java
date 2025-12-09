public class ComparisonOperators {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;

        System.out.println("a = " + a + ", b = " + b);

        // Basic Comparisons
        System.out.println("a == b: " + (a == b)); // false
        System.out.println("a != b: " + (a != b)); // true
        System.out.println("a > b:  " + (a > b)); // false
        System.out.println("a < b:  " + (a < b)); // true
        System.out.println("b >= a: " + (b >= a)); // true

        // Comparing Types
        System.out.println("\n--- Mixed Types ---");
        double d = 10.0;
        // Int 10 and Double 10.0 are equal in value
        System.out.println("10 == 10.0: " + (a == d));

        char c1 = 'A'; // ASCII 65
        char c2 = 65;
        System.out.println("'A' == 65: " + (c1 == c2));
    }
}
