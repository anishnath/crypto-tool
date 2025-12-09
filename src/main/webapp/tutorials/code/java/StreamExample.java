import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class StreamExample {
    public static void main(String[] args) {

        List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David", "Edward");

        // 1. FILTERING: Get names starting with 'A' or 'B'
        System.out.println("--- Filtered Names ---");
        names.stream()
                .filter(name -> name.startsWith("A") || name.startsWith("B"))
                .forEach(System.out::println);

        // 2. MAPPING: Convert all to Uppercase
        System.out.println("\n--- Uppercase Names ---");
        List<String> uppercaseNames = names.stream()
                .map(String::toUpperCase)
                .collect(Collectors.toList());
        System.out.println(uppercaseNames);

        // 3. REDUCING (Counting)
        long count = names.stream()
                .filter(name -> name.length() > 4)
                .count();
        System.out.println("\nNumber of names with > 4 letters: " + count);

        // 4. SORTING
        System.out.println("\n--- Sorted (Reverse) ---");
        names.stream()
                .sorted((a, b) -> b.compareTo(a)) // Custom Lambda Comparator
                .forEach(System.out::println);
    }
}
