public class Blocks {
    public static void main(String[] args) {
        // This is a block - everything inside {}
        System.out.println("Inside main method block");
        
        {
            // Nested block
            int localVar = 5;
            System.out.println("Inside nested block: " + localVar);
        }
        
        // localVar is not accessible here - it's out of scope
        // System.out.println(localVar);  // This would cause an error
        
        if (true) {
            // Block inside if statement
            System.out.println("Inside if block");
        }
    }
}

