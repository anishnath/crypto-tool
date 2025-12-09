// final class - cannot be inherited
final class FinalClass {
    final int value = 10;  // final variable - cannot be changed
    
    // final method - cannot be overridden
    final void display() {
        System.out.println("Value: " + value);
    }
}

public class Constants {
    // Final constant - must be initialized
    public static final double PI = 3.14159;
    
    // Final constant with naming convention (UPPERCASE)
    public static final int MAX_SIZE = 100;
    
    // Final instance variable
    private final String name;
    
    // Constructor - can initialize final variable
    public Constants(String name) {
        this.name = name;
    }
    
    public String getName() {
        return name;
    }
    
    void displayConstants() {
        System.out.println("PI: " + PI);
        System.out.println("MAX_SIZE: " + MAX_SIZE);
        System.out.println("Name: " + name);
    }
}

public class OopFinal {
    public static void main(String[] args) {
        // Using static final constants
        System.out.println("PI value: " + Constants.PI);
        System.out.println("MAX_SIZE: " + Constants.MAX_SIZE);
        
        // Cannot modify final constants
        // Constants.PI = 3.14;  // Error!
        
        // Create object with final instance variable
        Constants obj = new Constants("Test");
        obj.displayConstants();
        
        // Cannot modify final instance variable
        // obj.name = "New Name";  // Error!
        
        // Cannot inherit from final class
        // class SubClass extends FinalClass { }  // Error!
    }
}

