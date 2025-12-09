public class LogicalOperators {
    public static void main(String[] args) {
        boolean hasLicense = true;
        boolean hasCar = false;
        boolean canRent = true;

        System.out.println("Has License: " + hasLicense);
        System.out.println("Has Car: " + hasCar);
        System.out.println("Can Rent: " + canRent);

        // Logical AND (&&)
        // Needs (License AND Car) OR (License AND Rent)
        boolean canDrive = (hasLicense && hasCar) || (hasLicense && canRent);

        System.out.println("\nCan user drive? " + canDrive);

        // Logical NOT (!)
        boolean isNotAllowed = !canDrive;
        System.out.println("Is driving forbidden? " + isNotAllowed);

        // Short-circuit demo
        System.out.println("\n--- Short Circuit Demo ---");
        int calls = 0;
        // The second part ((calls = 1) > 0) is NEVER executed because first part is
        // false
        if (false && ((calls = 1) > 0)) {
            System.out.println("This won't print");
        }
        System.out.println("Calls made (should be 0): " + calls); // 0

        // No Short-circuit (using single &)
        // Both sides executed
        if (false & ((calls = 1) > 0)) {
            System.out.println("This won't print");
        }
        System.out.println("Calls made (should be 1): " + calls); // 1
    }
}
