import java.util.ArrayList;
import java.util.Iterator;

public class IteratorExample {
    public static void main(String[] args) {
        ArrayList<Integer> numbers = new ArrayList<Integer>();
        numbers.add(12);
        numbers.add(8);
        numbers.add(2);
        numbers.add(23);

        System.out.println("Original List: " + numbers);

        // 1. Get Iterator
        Iterator<Integer> it = numbers.iterator();

        // 2. Loop and print
        System.out.println("Iterating:");
        while (it.hasNext()) {
            System.out.print(it.next() + " ");
        }
        System.out.println();

        // 3. Remove items smaller than 10
        // We must reset iterator to start again or get a new one
        it = numbers.iterator();

        while (it.hasNext()) {
            Integer i = it.next();
            if (i < 10) {
                // Safe Removal
                it.remove();
            }
        }

        System.out.println("After removing numbers < 10: " + numbers);
    }
}
