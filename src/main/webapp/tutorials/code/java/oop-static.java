public class Counter {
    // Instance variable - each object has its own copy
    int instanceCount;
    
    // Static variable - shared by all objects
    static int staticCount;
    
    // Constructor
    public Counter() {
        instanceCount = 0;
        staticCount++;
    }
    
    // Instance method - operates on instance variable
    void incrementInstance() {
        instanceCount++;
    }
    
    // Static method - can only access static variables
    static void incrementStatic() {
        staticCount++;
    }
    
    // Static method to get static count
    static int getStaticCount() {
        return staticCount;
    }
    
    void displayCounts() {
        System.out.println("Instance count: " + instanceCount);
        System.out.println("Static count: " + staticCount);
    }
}

public class OopStatic {
    public static void main(String[] args) {
        // Access static variable without creating object
        System.out.println("Initial static count: " + Counter.getStaticCount());
        
        // Create first object
        Counter counter1 = new Counter();
        counter1.incrementInstance();
        System.out.println("\nCounter 1:");
        counter1.displayCounts();
        
        // Create second object
        Counter counter2 = new Counter();
        counter2.incrementInstance();
        counter2.incrementInstance();
        System.out.println("\nCounter 2:");
        counter2.displayCounts();
        
        // Notice: staticCount is shared!
        System.out.println("\nCounter 1 after Counter 2 was created:");
        counter1.displayCounts();
        
        // Call static method using class name
        Counter.incrementStatic();
        System.out.println("\nAfter calling static method:");
        System.out.println("Static count: " + Counter.getStaticCount());
    }
}

