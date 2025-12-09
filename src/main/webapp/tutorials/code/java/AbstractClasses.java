// Abstract class representing a shape
abstract class Shape {
    String color;
    String name;

    // Constructor in abstract class
    Shape(String name, String color) {
        this.name = name;
        this.color = color;
        System.out.println("Shape constructor called for: " + name);
    }

    // Abstract method - must be implemented by subclasses
    abstract double calculateArea();

    // Abstract method
    abstract double calculatePerimeter();

    // Concrete method - shared by all shapes
    void displayInfo() {
        System.out.println("Shape: " + name);
        System.out.println("Color: " + color);
        System.out.println("Area: " + calculateArea());
        System.out.println("Perimeter: " + calculatePerimeter());
    }

    // Concrete method with default implementation
    void setColor(String color) {
        this.color = color;
    }
}

// Concrete class implementing all abstract methods
class Circle extends Shape {
    double radius;

    Circle(String color, double radius) {
        super("Circle", color);  // Call abstract class constructor
        this.radius = radius;
    }

    @Override
    double calculateArea() {
        return Math.PI * radius * radius;
    }

    @Override
    double calculatePerimeter() {
        return 2 * Math.PI * radius;
    }
}

class Rectangle extends Shape {
    double width;
    double height;

    Rectangle(String color, double width, double height) {
        super("Rectangle", color);
        this.width = width;
        this.height = height;
    }

    @Override
    double calculateArea() {
        return width * height;
    }

    @Override
    double calculatePerimeter() {
        return 2 * (width + height);
    }
}

class Triangle extends Shape {
    double base;
    double height;
    double side1, side2, side3;

    Triangle(String color, double base, double height, double side1, double side2, double side3) {
        super("Triangle", color);
        this.base = base;
        this.height = height;
        this.side1 = side1;
        this.side2 = side2;
        this.side3 = side3;
    }

    @Override
    double calculateArea() {
        return 0.5 * base * height;
    }

    @Override
    double calculatePerimeter() {
        return side1 + side2 + side3;
    }
}

// Abstract class with template method pattern
abstract class Employee {
    String name;
    double baseSalary;

    Employee(String name, double baseSalary) {
        this.name = name;
        this.baseSalary = baseSalary;
    }

    // Abstract method - different for each employee type
    abstract double calculateBonus();

    // Template method - uses abstract method
    double getTotalPay() {
        return baseSalary + calculateBonus();
    }

    void displayPayInfo() {
        System.out.println("Employee: " + name);
        System.out.println("Base Salary: $" + baseSalary);
        System.out.println("Bonus: $" + calculateBonus());
        System.out.println("Total Pay: $" + getTotalPay());
    }
}

class Manager extends Employee {
    int teamSize;

    Manager(String name, double baseSalary, int teamSize) {
        super(name, baseSalary);
        this.teamSize = teamSize;
    }

    @Override
    double calculateBonus() {
        // Managers get 20% bonus plus $500 per team member
        return baseSalary * 0.20 + (teamSize * 500);
    }
}

class Developer extends Employee {
    int projectsCompleted;

    Developer(String name, double baseSalary, int projectsCompleted) {
        super(name, baseSalary);
        this.projectsCompleted = projectsCompleted;
    }

    @Override
    double calculateBonus() {
        // Developers get 15% bonus plus $1000 per project
        return baseSalary * 0.15 + (projectsCompleted * 1000);
    }
}

public class AbstractClasses {
    public static void main(String[] args) {
        System.out.println("=== Abstract Class: Shape Example ===\n");

        // Cannot do: Shape shape = new Shape(); // Compile error!

        // Create concrete subclass objects
        Shape circle = new Circle("Red", 5.0);
        Shape rectangle = new Rectangle("Blue", 4.0, 6.0);
        Shape triangle = new Triangle("Green", 3.0, 4.0, 3.0, 4.0, 5.0);

        System.out.println("\n--- Shape Information ---\n");

        circle.displayInfo();
        System.out.println();

        rectangle.displayInfo();
        System.out.println();

        triangle.displayInfo();

        System.out.println("\n=== Polymorphism with Abstract Classes ===\n");

        // Array of abstract type holding concrete objects
        Shape[] shapes = {circle, rectangle, triangle};

        double totalArea = 0;
        for (Shape s : shapes) {
            totalArea += s.calculateArea();  // Calls appropriate implementation
        }
        System.out.println("Total area of all shapes: " + String.format("%.2f", totalArea));

        System.out.println("\n=== Template Method Pattern: Employee Example ===\n");

        Employee manager = new Manager("Alice", 80000, 5);
        Employee developer = new Developer("Bob", 70000, 3);

        manager.displayPayInfo();
        System.out.println();
        developer.displayPayInfo();

        System.out.println("\n=== Key Points ===");
        System.out.println("1. Abstract classes cannot be instantiated directly");
        System.out.println("2. Abstract methods have no body (just signature)");
        System.out.println("3. Concrete subclasses must implement all abstract methods");
        System.out.println("4. Abstract classes can have constructors");
        System.out.println("5. Abstract classes can have concrete methods too");
        System.out.println("6. Use abstract classes for IS-A with shared implementation");
    }
}
