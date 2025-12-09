public class RecursionExample {

    // Recursive method to calculate Factorial
    static int factorial(int n) {
        if (n == 1) {
            return 1; // Base case
        } else {
            return n * factorial(n - 1); // Recursive call
        }
    }

    // Recursive method to sum numbers up to k
    static int sum(int k) {
        if (k > 0) {
            return k + sum(k - 1);
        } else {
            return 0;
        }
    }

    public static void main(String[] args) {
        int number = 5;
        int result = factorial(number);
        System.out.println("Factorial of " + number + " is: " + result);

        int k = 10;
        int total = sum(k);
        System.out.println("Sum of numbers from 1 to " + k + " is: " + total);
    }
}
