public class StaticBlockDemo {
    // Static variable
    static int value;
    
    // Static block - executed once when class is first loaded
    static {
        System.out.println("Static block 1 executed");
        value = 100;
    }
    
    // Another static block - executed in order
    static {
        System.out.println("Static block 2 executed");
        value += 50;
    }
    
    // Static method
    static void displayValue() {
        System.out.println("Value: " + value);
    }
}

public class OopStaticBlocks {
    public static void main(String[] args) {
        System.out.println("Main method started");
        
        // Access static member - this triggers class loading
        System.out.println("\nAccessing static method:");
        StaticBlockDemo.displayValue();
        
        // Class is already loaded, static blocks won't run again
        System.out.println("\nAccessing again:");
        StaticBlockDemo.displayValue();
    }
}

