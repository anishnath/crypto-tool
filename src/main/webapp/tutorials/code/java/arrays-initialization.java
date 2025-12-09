public class Main {
    public static void main(String[] args) {
        System.out.println("--- Array Initialization Ways ---");

        // Way 1: With 'new' keyword (Fixed size, default values)
        int[] arr1 = new int[3];
        System.out.println("arr1[0] (Default int): " + arr1[0]); // 0

        // Way 2: Array Literal (Values known upfront)
        String[] fruits = { "Apple", "Banana", "Cherry" };
        System.out.println("Fruit 1: " + fruits[0]);
        System.out.println("Fruit 2: " + fruits[1]);

        // Way 3: Anonymous Array (Common in method arguments)
        printArray(new int[] { 1, 2, 3, 4, 5 });

        System.out.println("\n--- Default Values ---");
        boolean[] bools = new boolean[2];
        System.out.println("boolean default: " + bools[0]); // false

        String[] texts = new String[2];
        System.out.println("String default: " + texts[0]); // null
    }

    public static void printArray(int[] arr) {
        System.out.print("Printed Array: ");
        for (int x : arr) {
            System.out.print(x + " ");
        }
        System.out.println();
    }
}
