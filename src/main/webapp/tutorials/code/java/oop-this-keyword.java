public class Rectangle {
    double width;
    double height;
    
    // Using 'this' to distinguish instance variables from parameters
    public Rectangle(double width, double height) {
        this.width = width;   // this.width refers to instance variable
        this.height = height; // this.height refers to instance variable
    }
    
    // Default constructor using 'this' to call parameterized constructor
    public Rectangle() {
        this(1.0, 1.0);  // Calls the parameterized constructor
    }
    
    // Constructor for square using 'this'
    public Rectangle(double side) {
        this(side, side);  // Calls parameterized constructor with same value
    }
    
    double getArea() {
        return this.width * this.height;  // 'this' is optional here
    }
    
    void displayInfo() {
        System.out.println("Width: " + this.width + ", Height: " + this.height);
        System.out.println("Area: " + this.getArea());
    }
}

public class OopThisKeyword {
    public static void main(String[] args) {
        Rectangle rect1 = new Rectangle();  // Uses default constructor
        System.out.println("Rectangle 1 (default):");
        rect1.displayInfo();
        
        System.out.println();
        
        Rectangle rect2 = new Rectangle(5.0);  // Square
        System.out.println("Rectangle 2 (square):");
        rect2.displayInfo();
        
        System.out.println();
        
        Rectangle rect3 = new Rectangle(4.0, 6.0);  // Rectangle
        System.out.println("Rectangle 3 (rectangle):");
        rect3.displayInfo();
    }
}

