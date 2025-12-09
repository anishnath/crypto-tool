public class Calculator {
    double num1;
    double num2;
    
    // Instance method - operates on instance variables
    double add() {
        return num1 + num2;
    }
    
    // Instance method with parameters
    double multiply(double a, double b) {
        return a * b;
    }
    
    // Method that accepts an object as parameter
    void copyFrom(Calculator other) {
        this.num1 = other.num1;
        this.num2 = other.num2;
    }
    
    // Method that returns an object
    Calculator createCopy() {
        Calculator copy = new Calculator();
        copy.num1 = this.num1;
        copy.num2 = this.num2;
        return copy;
    }
    
    void display() {
        System.out.println("num1: " + num1 + ", num2: " + num2);
    }
}

public class OopMethods {
    public static void main(String[] args) {
        Calculator calc1 = new Calculator();
        calc1.num1 = 10;
        calc1.num2 = 5;
        
        // Call instance method
        System.out.println("Sum: " + calc1.add());
        
        // Call method with parameters
        System.out.println("Product: " + calc1.multiply(3, 4));
        
        // Pass object to method
        Calculator calc2 = new Calculator();
        calc2.copyFrom(calc1);
        System.out.println("\nCalc2 after copying from Calc1:");
        calc2.display();
        
        // Return object from method
        Calculator calc3 = calc1.createCopy();
        System.out.println("\nCalc3 (copy of Calc1):");
        calc3.display();
    }
}

