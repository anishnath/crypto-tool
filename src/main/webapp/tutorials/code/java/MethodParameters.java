public class MethodParameters {

    // Method with one parameter
    static void checkAge(int age) {
        if (age < 18) {
            System.out.println("Access denied - You are not old enough!");
        } else {
            System.out.println("Access granted - You are old enough!");
        }
    }

    // Method with multiple parameters
    static void printPerson(String fname, String lname, int age) {
        System.out.println(fname + " " + lname + " is " + age + " years old.");
    }

    public static void main(String[] args) {
        System.out.println("--- Checking Age ---");
        checkAge(15);
        checkAge(20);

        System.out.println("\n--- Printing Details ---");
        // Arguments must match order (String, String, int)
        printPerson("John", "Doe", 30);
        printPerson("Jane", "Smith", 25);

        // Passing variables
        String myName = "Alice";
        String myLast = "Wonder";
        int myAge = 22;
        printPerson(myName, myLast, myAge);
    }
}
