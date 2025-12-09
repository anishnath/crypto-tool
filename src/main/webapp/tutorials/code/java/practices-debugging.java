public class DebuggingExample {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        int sum = calculateSum(numbers);
        System.out.println("Sum: " + sum);
        
        // Debugging techniques:
        // 1. Print statements
        System.out.println("Debug: sum = " + sum);
        
        // 2. Check values
        if (sum == 0) {
            System.out.println("Warning: sum is zero!");
        }
        
        // 3. Stack trace for exceptions
        try {
            int result = divide(10, 0);
        } catch (ArithmeticException e) {
            e.printStackTrace();  // Prints stack trace
        }
    }
    
    public static int calculateSum(int[] numbers) {
        int sum = 0;
        // Debug: Check array length
        System.out.println("Debug: Array length = " + numbers.length);
        
        for (int i = 0; i < numbers.length; i++) {
            // Debug: Print each value
            System.out.println("Debug: numbers[" + i + "] = " + numbers[i]);
            sum += numbers[i];
        }
        
        return sum;
    }
    
    public static int divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Division by zero");
        }
        return a / b;
    }
}

/*
Debugging Tips:
1. Use IDE breakpoints to pause execution
2. Step through code line by line
3. Inspect variable values
4. Watch expressions for specific variables
5. Use conditional breakpoints
6. Check call stack to see method call sequence
7. Use System.out.println for quick debugging
8. Use logging frameworks for production debugging
*/

