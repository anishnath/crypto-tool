// Base class for runtime polymorphism demo
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    void makeSound() {
        System.out.println(name + " makes a sound");
    }

    void eat() {
        System.out.println(name + " is eating");
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Woof! Woof!");
    }

    void fetch() {
        System.out.println(name + " is fetching the ball!");
    }
}

class Cat extends Animal {
    Cat(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Meow!");
    }

    void scratch() {
        System.out.println(name + " is scratching!");
    }
}

class Bird extends Animal {
    Bird(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " says: Tweet tweet!");
    }

    void fly() {
        System.out.println(name + " is flying!");
    }
}

// Class for compile-time polymorphism (method overloading)
class Calculator {
    // Method overloading - same name, different parameters
    int add(int a, int b) {
        System.out.println("Adding two integers");
        return a + b;
    }

    double add(double a, double b) {
        System.out.println("Adding two doubles");
        return a + b;
    }

    int add(int a, int b, int c) {
        System.out.println("Adding three integers");
        return a + b + c;
    }

    String add(String a, String b) {
        System.out.println("Concatenating strings");
        return a + b;
    }
}

// Interface for interface polymorphism
interface Drawable {
    void draw();
}

class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing a Circle");
    }
}

class Rectangle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing a Rectangle");
    }
}

class Triangle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing a Triangle");
    }
}

// Real-world example: Payment processing
abstract class Payment {
    abstract void processPayment(double amount);
}

class CreditCardPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via Credit Card");
        System.out.println("  -> Validating card number...");
        System.out.println("  -> Payment successful!");
    }
}

class PayPalPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via PayPal");
        System.out.println("  -> Connecting to PayPal...");
        System.out.println("  -> Payment successful!");
    }
}

class CryptoPayment extends Payment {
    @Override
    void processPayment(double amount) {
        System.out.println("Processing $" + amount + " via Cryptocurrency");
        System.out.println("  -> Verifying blockchain...");
        System.out.println("  -> Payment successful!");
    }
}

public class PolymorphismDemo {
    public static void main(String[] args) {
        System.out.println("=== Runtime Polymorphism (Method Overriding) ===\n");

        // Parent reference pointing to child objects
        Animal animal1 = new Dog("Buddy");
        Animal animal2 = new Cat("Whiskers");
        Animal animal3 = new Bird("Tweety");

        // Method called depends on ACTUAL object type at runtime
        animal1.makeSound();  // Dog's makeSound()
        animal2.makeSound();  // Cat's makeSound()
        animal3.makeSound();  // Bird's makeSound()

        System.out.println("\n=== Polymorphic Array ===\n");

        // Array of parent type can hold any child type
        Animal[] zoo = {
            new Dog("Rex"),
            new Cat("Felix"),
            new Bird("Polly"),
            new Dog("Max")
        };

        // Process all animals uniformly
        System.out.println("All animals in the zoo:");
        for (Animal animal : zoo) {
            animal.makeSound();  // Each calls its own overridden version
        }

        System.out.println("\n=== Compile-time Polymorphism (Method Overloading) ===\n");

        Calculator calc = new Calculator();

        System.out.println("Result: " + calc.add(5, 3));
        System.out.println("Result: " + calc.add(5.5, 3.3));
        System.out.println("Result: " + calc.add(1, 2, 3));
        System.out.println("Result: " + calc.add("Hello, ", "World!"));

        System.out.println("\n=== Interface Polymorphism ===\n");

        Drawable[] shapes = {
            new Circle(),
            new Rectangle(),
            new Triangle()
        };

        for (Drawable shape : shapes) {
            shape.draw();  // Each calls its own implementation
        }

        System.out.println("\n=== Upcasting and Downcasting ===\n");

        // Upcasting (implicit, always safe)
        Dog myDog = new Dog("Charlie");
        Animal animal = myDog;  // Dog -> Animal (automatic)
        System.out.println("After upcasting, can call:");
        animal.makeSound();  // Works
        animal.eat();        // Works
        // animal.fetch();   // ERROR! Animal reference doesn't know about fetch()

        // Downcasting (explicit, requires instanceof check)
        if (animal instanceof Dog) {
            Dog downcastDog = (Dog) animal;  // Animal -> Dog
            System.out.println("\nAfter safe downcasting:");
            downcastDog.fetch();  // Now we can call Dog-specific method
        }

        System.out.println("\n=== Real-World Example: Payment Processing ===\n");

        // Polymorphic method that works with any payment type
        processCheckout(new CreditCardPayment(), 99.99);
        System.out.println();
        processCheckout(new PayPalPayment(), 49.99);
        System.out.println();
        processCheckout(new CryptoPayment(), 199.99);

        System.out.println("\n=== Key Points ===");
        System.out.println("1. Runtime polymorphism: Method called determined at runtime");
        System.out.println("2. Compile-time polymorphism: Method called determined at compile time");
        System.out.println("3. Upcasting is implicit and safe");
        System.out.println("4. Downcasting requires explicit cast and instanceof check");
        System.out.println("5. Use polymorphism for flexible, extensible code");
    }

    // This method demonstrates polymorphism - works with ANY Payment type
    static void processCheckout(Payment payment, double amount) {
        System.out.println("--- Checkout Started ---");
        payment.processPayment(amount);  // Calls the appropriate overridden method
        System.out.println("--- Checkout Complete ---");
    }
}
