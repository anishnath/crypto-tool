import java.util.ArrayList;

interface MathOperation {
    int operation(int a, int b);
}

public class LambdaExample {
    public static void main(String[] args) {

        // 1. Implementing an interface using Lambda
        // Defines addition
        MathOperation addition = (int a, int b) -> a + b;

        // Defines subtraction
        MathOperation subtraction = (a, b) -> a - b;

        System.out.println("10 + 5 = " + operate(10, 5, addition));
        System.out.println("10 - 5 = " + operate(10, 5, subtraction));

        // 2. Using Lambda with Collections (ForEach)
        System.out.println("\n--- List Iteration ---");
        ArrayList<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        names.add("Charlie");

        // Old way: for(String n : names) ...
        // Lambda way:
        names.forEach((n) -> System.out.println(n));
    }

    // Helper method
    private static int operate(int a, int b, MathOperation mathOp) {
        return mathOp.operation(a, b);
    }
}
