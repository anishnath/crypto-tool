public class Main {
    public static void main(String[] args) {
        // 1. Literal Creation (Uses String Pool)
        String s1 = "Hello";
        String s2 = "Hello";

        System.out.println("--- String Comparison ---");
        // '==' checks reference equality (memory address)
        System.out.println("s1 == s2: " + (s1 == s2)); // true (Same object in pool)

        // 2. New Keyword (Forces new object on Heap)
        String s3 = new String("Hello");

        System.out.println("s1 == s3: " + (s1 == s3)); // false (Different objects)

        // 3. Comparisons using .equals() (Checks content)
        System.out.println("s1.equals(s3): " + s1.equals(s3)); // true (Content is same)

        // 4. Immutability Demo
        System.out.println("\n--- Immutability ---");
        s1.concat(" World"); // This creates a NEW string, doesn't change s1
        System.out.println("s1 after concat: " + s1); // Still "Hello"

        s1 = s1.concat(" World"); // Reassigning the variable
        System.out.println("s1 after reassignment: " + s1); // "Hello World"
    }
}
