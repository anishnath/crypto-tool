public class MethodOverloading {

    // Method to add two integers
    static int add(int x, int y) {
        System.out.println("Running int version");
        return x + y;
    }

    // Method to add two doubles
    static double add(double x, double y) {
        System.out.println("Running double version");
        return x + y;
    }

    // Method to add three integers
    static int add(int x, int y, int z) {
        System.out.println("Running 3-int version");
        return x + y + z;
    }

    public static void main(String[] args) {
        // Java automatically picks the correct method based on arguments

        int sum1 = add(5, 10);
        System.out.println("Sum 1: " + sum1);
        System.out.println();

        double sum2 = add(5.5, 2.3);
        System.out.println("Sum 2: " + sum2);
        System.out.println();

        int sum3 = add(1, 2, 3);
        System.out.println("Sum 3: " + sum3);
    }
}
