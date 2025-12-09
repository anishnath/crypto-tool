// Basic interface
interface Drawable {
    void draw();  // Abstract method (public abstract by default)
}

// Interface with multiple methods
interface Animal {
    void makeSound();
    void move();
}

// Interfaces for multiple inheritance
interface Flyable {
    void fly();

    // Default method (Java 8+)
    default void takeOff() {
        System.out.println("Taking off...");
    }
}

interface Swimmable {
    void swim();

    default void dive() {
        System.out.println("Diving...");
    }
}

interface Walkable {
    void walk();
}

// Interface with constants
interface GameConstants {
    int MAX_PLAYERS = 4;        // public static final by default
    int MIN_PLAYERS = 2;
    String GAME_NAME = "Adventure";
}

// Interface with static method
interface MathUtils {
    static int add(int a, int b) {
        return a + b;
    }

    static int multiply(int a, int b) {
        return a * b;
    }
}

// Interface extending interfaces
interface ReadWritable extends Drawable {
    void read();
    void write();
}

// Class implementing single interface
class Circle implements Drawable {
    private double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public void draw() {
        System.out.println("Drawing a circle with radius: " + radius);
    }
}

// Class implementing interface
class Dog implements Animal {
    private String name;

    Dog(String name) {
        this.name = name;
    }

    @Override
    public void makeSound() {
        System.out.println(name + " says: Woof!");
    }

    @Override
    public void move() {
        System.out.println(name + " runs on four legs");
    }
}

// Class implementing MULTIPLE interfaces
class Duck implements Flyable, Swimmable, Walkable {
    private String name;

    Duck(String name) {
        this.name = name;
    }

    @Override
    public void fly() {
        System.out.println(name + " is flying!");
    }

    @Override
    public void swim() {
        System.out.println(name + " is swimming!");
    }

    @Override
    public void walk() {
        System.out.println(name + " is walking!");
    }

    // Can use default methods from interfaces
}

// Class implementing interface with constants
class Game implements GameConstants {
    void showInfo() {
        System.out.println("Game: " + GAME_NAME);
        System.out.println("Min players: " + MIN_PLAYERS);
        System.out.println("Max players: " + MAX_PLAYERS);
    }
}

// Functional interface example
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

public class InterfacesBasics {
    public static void main(String[] args) {
        System.out.println("=== Basic Interface Implementation ===\n");

        Drawable circle = new Circle(5.0);
        circle.draw();

        System.out.println("\n=== Interface with Multiple Methods ===\n");

        Animal dog = new Dog("Buddy");
        dog.makeSound();
        dog.move();

        System.out.println("\n=== Multiple Interface Implementation ===\n");

        Duck duck = new Duck("Donald");

        // Duck can fly, swim, AND walk
        duck.fly();
        duck.swim();
        duck.walk();

        // Using default methods from interfaces
        duck.takeOff();  // From Flyable
        duck.dive();     // From Swimmable

        System.out.println("\n=== Interface Constants ===\n");

        Game game = new Game();
        game.showInfo();

        // Can also access directly via interface
        System.out.println("Direct access: " + GameConstants.GAME_NAME);

        System.out.println("\n=== Static Methods in Interfaces ===\n");

        int sum = MathUtils.add(10, 5);
        int product = MathUtils.multiply(10, 5);

        System.out.println("10 + 5 = " + sum);
        System.out.println("10 * 5 = " + product);

        System.out.println("\n=== Polymorphism with Interfaces ===\n");

        // Interface types can hold implementing objects
        Flyable flyingThing = duck;
        Swimmable swimmingThing = duck;

        System.out.println("Using Flyable reference:");
        flyingThing.fly();

        System.out.println("Using Swimmable reference:");
        swimmingThing.swim();

        System.out.println("\n=== Functional Interface with Lambda ===\n");

        // Using lambda expressions with functional interface
        Calculator add = (a, b) -> a + b;
        Calculator subtract = (a, b) -> a - b;
        Calculator multiply = (a, b) -> a * b;
        Calculator divide = (a, b) -> a / b;

        int x = 20, y = 5;
        System.out.println(x + " + " + y + " = " + add.calculate(x, y));
        System.out.println(x + " - " + y + " = " + subtract.calculate(x, y));
        System.out.println(x + " * " + y + " = " + multiply.calculate(x, y));
        System.out.println(x + " / " + y + " = " + divide.calculate(x, y));

        System.out.println("\n=== Key Points ===");
        System.out.println("1. Interfaces define contracts (what, not how)");
        System.out.println("2. Classes use 'implements' keyword");
        System.out.println("3. A class can implement multiple interfaces");
        System.out.println("4. Interface methods are public abstract by default");
        System.out.println("5. Default methods provide default implementation (Java 8+)");
        System.out.println("6. Functional interfaces have one abstract method (for lambdas)");
    }
}
