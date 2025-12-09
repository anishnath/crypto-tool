public class Main {
    // 1. Static Variable (Class Scope)
    // Shared by all instances of the class
    static int classCount = 0;

    // 2. Instance Variable (Object Scope)
    // Each object has its own copy
    String instanceName = "Default";

    public static void main(String[] args) {
        System.out.println("--- Variable Scope Demo ---");

        // 3. Local Variable (Method Scope)
        // Only accessible inside this main method
        int localScore = 100;
        System.out.println("Local Score: " + localScore);

        // Accessing Static Variable
        System.out.println("Class Count: " + classCount);

        // Block Scope
        if (localScore > 50) {
            String message = "Excellent!"; // Block Scope
            System.out.println("Inside block: " + message);
        }
        // System.out.println(message); // Error! message not accessible here

        demoMethod();
    }

    public static void demoMethod() {
        // System.out.println(localScore); // Error! localScore is local to main()

        int methodVar = 500;
        System.out.println("Inside demoMethod: " + methodVar);
    }
}
