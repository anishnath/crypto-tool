public class Car {
    String brand;
    String color;
    int speed;
    
    void displayInfo() {
        System.out.println(brand + " " + color + " - Speed: " + speed);
    }
}

public class OopObjects {
    public static void main(String[] args) {
        // Create first car object
        Car car1 = new Car();
        car1.brand = "Toyota";
        car1.color = "Red";
        car1.speed = 60;
        
        // Create second car object
        Car car2 = new Car();
        car2.brand = "Honda";
        car2.color = "Blue";
        car2.speed = 70;
        
        // Display information
        System.out.println("Car 1:");
        car1.displayInfo();
        
        System.out.println("\nCar 2:");
        car2.displayInfo();
        
        // Demonstrating object references
        Car car3 = car1;  // car3 references the same object as car1
        System.out.println("\nCar 3 (references same object as Car 1):");
        car3.displayInfo();
        
        car3.color = "Green";  // Changing car3 also changes car1!
        System.out.println("\nAfter changing car3.color to Green:");
        System.out.println("Car 1 color: " + car1.color);  // Also Green!
        System.out.println("Car 3 color: " + car3.color);  // Green
    }
}

