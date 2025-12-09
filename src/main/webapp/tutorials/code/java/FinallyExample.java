public class FinallyExample {
    public static void main(String[] args) {
        try {
            int a[] = new int[2];
            System.out.println("Accessing element three :" + a[3]);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Exception thrown: " + e);
        } finally {
            a[0] = 6;
            System.out.println("First element value: " + a[0]);
            System.out.println("The finally block is always executed.");
        }

        System.out.println("\n--- No Exception Case ---");
        try {
            int x = 100;
            System.out.println("Value: " + x);
        } catch (Exception e) {
            System.out.println("This won't print.");
        } finally {
            System.out.println("Finally block executes even with no error!");
        }
    }
}
