// Parent class with methods to override
class Animal {
    void makeSound() {
        System.out.println("Animal makes a generic sound");
    }

    void move() {
        System.out.println("Animal moves");
    }

    // Method that cannot be overridden
    final void breathe() {
        System.out.println("Animal breathes");
    }
}

// Subclass overriding methods
class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Dog says: Woof! Woof!");
    }

    @Override
    void move() {
        System.out.println("Dog runs on four legs");
    }

    // Dog-specific method
    void fetch() {
        System.out.println("Dog fetches the ball");
    }
}

class Cat extends Animal {
    @Override
    void makeSound() {
        System.out.println("Cat says: Meow!");
    }

    @Override
    void move() {
        System.out.println("Cat walks gracefully");
    }
}

class Bird extends Animal {
    @Override
    void makeSound() {
        System.out.println("Bird says: Tweet tweet!");
    }

    @Override
    void move() {
        System.out.println("Bird flies in the sky");
    }
}

// Demonstrating covariant return types
class Shape {
    Shape getInstance() {
        return new Shape();
    }

    void draw() {
        System.out.println("Drawing a shape");
    }
}

class Circle extends Shape {
    @Override
    Circle getInstance() {  // Covariant return - Circle is subtype of Shape
        return new Circle();
    }

    @Override
    void draw() {
        System.out.println("Drawing a circle");
    }
}

// Demonstrating access modifier rules
class Parent {
    protected void display() {
        System.out.println("Parent display (protected)");
    }
}

class Child extends Parent {
    @Override
    public void display() {  // public is less restrictive than protected - OK!
        System.out.println("Child display (public)");
    }
}

// Using super to call parent's overridden method
class Employee {
    void work() {
        System.out.println("Employee: Working on general tasks");
    }
}

class Developer extends Employee {
    @Override
    void work() {
        super.work();  // Call parent's version first
        System.out.println("Developer: Writing code");
        System.out.println("Developer: Debugging issues");
    }
}

public class MethodOverriding {
    public static void main(String[] args) {
        System.out.println("=== Basic Method Overriding ===\n");

        Animal genericAnimal = new Animal();
        Dog dog = new Dog();
        Cat cat = new Cat();
        Bird bird = new Bird();

        genericAnimal.makeSound();
        dog.makeSound();
        cat.makeSound();
        bird.makeSound();

        System.out.println("\n=== Dynamic Method Dispatch (Runtime Polymorphism) ===\n");

        // Parent reference pointing to child objects
        Animal animal1 = new Dog();   // Upcasting
        Animal animal2 = new Cat();
        Animal animal3 = new Bird();

        // Method called depends on ACTUAL object type, not reference type
        animal1.makeSound();  // Dog's makeSound()
        animal1.move();       // Dog's move()

        animal2.makeSound();  // Cat's makeSound()
        animal2.move();       // Cat's move()

        animal3.makeSound();  // Bird's makeSound()
        animal3.move();       // Bird's move()

        System.out.println("\n=== Final Methods Cannot Be Overridden ===\n");

        // breathe() is final in Animal - all use the same implementation
        dog.breathe();
        cat.breathe();
        bird.breathe();

        System.out.println("\n=== Covariant Return Types ===\n");

        Shape shape = new Shape();
        Circle circle = new Circle();

        System.out.println("shape.getInstance() returns: " + shape.getInstance().getClass().getSimpleName());
        System.out.println("circle.getInstance() returns: " + circle.getInstance().getClass().getSimpleName());

        System.out.println("\n=== Access Modifier Rules ===\n");

        Parent parent = new Parent();
        Child child = new Child();

        parent.display();  // Parent's protected method
        child.display();   // Child's public method (less restrictive - OK!)

        System.out.println("\n=== Using super.method() ===\n");

        Developer dev = new Developer();
        dev.work();  // Calls both parent and child implementations

        System.out.println("\n=== Polymorphic Array Example ===\n");

        // Array of parent type holding different child types
        Animal[] animals = {new Dog(), new Cat(), new Bird()};

        for (Animal a : animals) {
            a.makeSound();  // Each calls its own overridden version
        }
    }
}
