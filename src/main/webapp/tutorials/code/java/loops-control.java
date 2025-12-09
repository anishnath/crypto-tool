public class LoopControl {
    public static void main(String[] args) {
        // BREAK Example
        System.out.println("--- Break Example ---");
        System.out.println("Searching for 7...");
        for (int i = 1; i <= 10; i++) {
            if (i == 7) {
                System.out.println("Found 7! Stopping loop.");
                break;
            }
            System.out.println("Checking " + i);
        }

        // CONTINUE Example
        System.out.println("\n--- Continue Example ---");
        System.out.println("Printing odd numbers only:");
        for (int i = 1; i <= 5; i++) {
            if (i % 2 == 0) {
                continue; // Skip even numbers
            }
            System.out.println(i);
        }

        // NESTED LOOP with LABEL Example
        System.out.println("\n--- Labeled Break Example ---");
        outerLoop: // Label
        for (int i = 1; i <= 3; i++) {
            for (int j = 1; j <= 3; j++) {
                if (i == 2 && j == 2) {
                    System.out.println("Breaking out of BOTH loops at i=" + i + ", j=" + j);
                    break outerLoop;
                }
                System.out.println("i=" + i + ", j=" + j);
            }
        }
        System.out.println("Done.");
    }
}
