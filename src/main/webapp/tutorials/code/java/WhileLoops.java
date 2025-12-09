public class WhileLoops {
    public static void main(String[] args) {
        // While Loop Demo
        System.out.println("--- While Loop (Guessing Game Logic) ---");
        int target = 5;
        int current = 0;

        // Simulating finding a number (0 to 10)
        while (current != target) {
            System.out.println("Guessed: " + current);
            current++;
        }
        System.out.println("Found target: " + current);

        // Do-While Loop Demo
        System.out.println("\n--- Do-While Loop (Menu Logic) ---");
        int count = 1;
        do {
            System.out.println("Processing item " + count);
            count++;
        } while (count <= 3); // Condition checked at end

        // While vs Do-While difference
        System.out.println("\n--- Difference Demo ---");
        boolean condition = false;

        while (condition) {
            System.out.println("This (While) will NOT print.");
        }

        do {
            System.out.println("This (Do-While) WILL print once.");
        } while (condition);
    }
}
