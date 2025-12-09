public class Main {
    public static void main(String[] args) {
        // 1. Declaration
        int age;
        // System.out.println(age); // Error! Not initialized yet

        // 2. Initialization
        age = 25;
        System.out.println("Age: " + age);

        // 3. Declaration + Initialization (One line)
        String name = "Alice";
        System.out.println("Name: " + name);

        // 4. Multiple variables (same type)
        int x = 10, y = 20, z = 30;
        System.out.println("Sum: " + (x + y + z));

        // 5. Updating variables
        age = 26; // Changing value
        System.out.println("New Age: " + age);

        // 6. Final variables (Constants)
        final double PI = 3.14159;
        // PI = 3.14; // Error! Cannot change a final variable
        System.out.println("Value of PI: " + PI);

        // 7. Var keyword (Java 10+) - Type inference
        var city = "New York"; // Compiler infers String
        var population = 8000000; // Compiler infers int
        System.out.println("City: " + city + ", Pop: " + population);
    }
}
