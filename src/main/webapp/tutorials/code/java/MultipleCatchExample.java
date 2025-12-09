public class MultipleCatchExample {
    public static void main(String[] args) {
        try {
            int a[] = new int[5];

            // This line might throw ArithmeticException
            int result = 30 / 0;

            // This line might throw ArrayIndexOutOfBoundsException
            a[10] = 50;

        } catch (ArithmeticException e) {
            System.out.println("Caught Arithmetic Exception (Division by Zero)");
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Caught Array Index Issue");
        } catch (Exception e) {
            System.out.println("Caught Some Other Exception: " + e.getMessage());
        }

        System.out.println("Rest of the code...");
    }
}
