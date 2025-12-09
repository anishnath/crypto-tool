import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {
        // 1. Create a TreeSet
        TreeSet<Integer> numbers = new TreeSet<Integer>();

        // 2. Add numbers in random order
        numbers.add(50);
        numbers.add(10);
        numbers.add(30);
        numbers.add(50); // Duplicate ignored
        numbers.add(20);

        // 3. Print
        // Notice it prints nicely sorted: [10, 20, 30, 50]
        System.out.println("TreeSet: " + numbers);

        // 4. Navigation Methods
        System.out.println("First (Lowest): " + numbers.first());
        System.out.println("Last (Highest): " + numbers.last());

        // 5. Higher/Lower
        System.out.println("Higher than 25: " + numbers.higher(25));
        System.out.println("Lower than 25: " + numbers.lower(25));

        // 6. Subsets
        System.out.println("HeadSet (limit 30): " + numbers.headSet(30));
    }
}
