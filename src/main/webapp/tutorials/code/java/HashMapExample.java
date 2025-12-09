import java.util.HashMap;

public class HashMapExample {
    public static void main(String[] args) {
        // 1. Create a HashMap
        // Map Student Name (String) to Age (Integer)
        HashMap<String, Integer> students = new HashMap<String, Integer>();

        // 2. Add Key/Value pairs
        students.put("Alice", 22);
        students.put("Bob", 19);
        students.put("Charlie", 25);
        students.put("Alice", 23); // Updates Alice's age

        // 3. Access a value
        System.out.println("Alice's Age: " + students.get("Alice"));

        // 4. Check if key exists
        if (students.containsKey("Bob")) {
            System.out.println("Bob is in the system.");
        }

        // 5. Remove an item
        students.remove("Charlie");

        // 6. Print all Keys and Values
        System.out.println("\n--- Class Roster ---");
        for (String name : students.keySet()) {
            System.out.println("Name: " + name + ", Age: " + students.get(name));
        }
    }
}
