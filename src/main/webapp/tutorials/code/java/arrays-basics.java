public class Main {
    public static void main(String[] args) {
        // 1. Declaration & Instantiation
        // Creates an array of 5 integers, initialized to 0
        int[] numbers = new int[5];

        // 2. Assigning values
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[2] = 30;
        numbers[3] = 40;
        numbers[4] = 50;

        System.out.println("First element: " + numbers[0]);
        System.out.println("Last element: " + numbers[4]);

        // 3. Array Length Property
        System.out.println("Array Size: " + numbers.length);

        // 4. Looping through array
        System.out.print("All elements: ");
        for (int i = 0; i < numbers.length; i++) {
            System.out.print(numbers[i] + " ");
        }
        System.out.println();

        // 5. Index Out of Bounds Error
        // numbers[5] = 60; // Throws ArrayIndexOutOfBoundsException!
    }
}
