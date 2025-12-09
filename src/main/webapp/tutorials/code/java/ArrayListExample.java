import java.util.ArrayList;
import java.util.Collections; // Import the Collections class

public class ArrayListExample {
    public static void main(String[] args) {
        // 1. Create an ArrayList
        ArrayList<String> cars = new ArrayList<String>();

        // 2. Add items
        cars.add("Volvo");
        cars.add("BMW");
        cars.add("Ford");
        cars.add("Mazda");

        System.out.println("Original List: " + cars);

        // 3. Access an item
        System.out.println("Element at index 0: " + cars.get(0));

        // 4. Modify an item
        cars.set(0, "Opel");
        System.out.println("Modified List: " + cars);

        // 5. Remove an item
        cars.remove(0);
        System.out.println("After Removal: " + cars);

        // 6. Get Size
        System.out.println("Size: " + cars.size());

        // 7. Loop through
        System.out.println("Looping through list:");
        for (String car : cars) {
            System.out.println(car);
        }

        // 8. Sort (Bonus)
        Collections.sort(cars);
        System.out.println("Sorted List: " + cars);
    }
}
