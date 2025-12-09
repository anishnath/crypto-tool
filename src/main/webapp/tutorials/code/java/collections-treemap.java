import java.util.TreeMap;

public class TreeMapExample {
    public static void main(String[] args) {
        // 1. Create a TreeMap
        // Map Name (String) to Score (Integer)
        TreeMap<String, Integer> scores = new TreeMap<String, Integer>();

        // 2. Add scores
        scores.put("Zach", 95);
        scores.put("Alice", 88);
        scores.put("Mike", 92);

        // 3. Print
        // Notice it sorts by Name (Key) automatically: Alice, Mike, Zach
        System.out.println("Sorted Scores: " + scores);

        // 4. Navigation
        System.out.println("First Person: " + scores.firstKey());
        System.out.println("Last Person: " + scores.lastKey());

        // 5. Higher/Lower Key
        System.out.println("Person after Alice: " + scores.higherKey("Alice"));
    }
}
