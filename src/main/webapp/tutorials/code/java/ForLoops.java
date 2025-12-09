public class ForLoops {
    public static void main(String[] args) {
        // Standard For Loop
        System.out.println("Counting up:");
        for (int i = 0; i < 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println(); // New line

        // Counting Down
        System.out.println("\nCounting down (Blastoff!):");
        for (int i = 5; i > 0; i--) {
            System.out.println(i + "...");
        }
        System.out.println("Blastoff!");

        // Enhanced For-Each Loop
        System.out.println("\nIterating Array:");
        String[] fruits = { "Apple", "Banana", "Cherry" };
        for (String fruit : fruits) {
            System.out.println("I like " + fruit);
        }

        // Summing numbers
        int sum = 0;
        for (int i = 1; i <= 10; i++) {
            sum += i;
        }
        System.out.println("\nSum of 1 to 10: " + sum);
    }
}
