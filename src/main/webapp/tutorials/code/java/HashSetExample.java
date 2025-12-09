import java.util.HashSet;

public class HashSetExample {
    public static void main(String[] args) {
        // 1. Create a HashSet
        HashSet<String> cars = new HashSet<String>();

        // 2. Add items
        cars.add("Volvo");
        cars.add("BMW");
        cars.add("Ford");
        cars.add("BMW"); // Duplicate! Will be ignored
        cars.add("Mazda");

        // 3. View the HashSet
        // Notice the order might be random
        System.out.println("HashSet: " + cars);

        // 4. Check if item exists
        boolean hasMazda = cars.contains("Mazda");
        System.out.println("Contains Mazda? " + hasMazda);

        // 5. Remove an item
        cars.remove("Volvo");
        System.out.println("After removal: " + cars);

        // 6. Look at Size
        System.out.println("Size: " + cars.size());

        // 7. Loop through
        System.out.println("Items in Set:");
        for (String i : cars) {
            System.out.println(i);
        }
    }
}
