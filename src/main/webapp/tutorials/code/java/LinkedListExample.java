import java.util.LinkedList;

public class LinkedListExample {
    public static void main(String[] args) {
        // 1. Create LinkedList
        LinkedList<String> cars = new LinkedList<String>();

        // 2. Standard Add
        cars.add("Volvo");
        cars.add("BMW");
        System.out.println("Initial: " + cars);

        // 3. Add First and Last
        cars.addFirst("Mazda");
        cars.addLast("Ford");
        System.out.println("After Add First/Last: " + cars);

        // 4. Get First and Last
        System.out.println("First Item: " + cars.getFirst());
        System.out.println("Last Item: " + cars.getLast());

        // 5. Remove First and Last
        cars.removeFirst();
        cars.removeLast();
        System.out.println("After Remove First/Last: " + cars);

        // 6. Access like a List
        System.out.println("Element at index 1: " + cars.get(1));
    }
}
