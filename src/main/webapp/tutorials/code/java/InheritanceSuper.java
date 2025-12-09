// Parent class
class Animal {
    String name;
    int age;

    // Parameterized constructor
    Animal(String name, int age) {
        this.name = name;
        this.age = age;
        System.out.println("Animal constructor called: " + name + ", " + age);
    }

    void eat() {
        System.out.println(name + " is eating.");
    }

    void displayInfo() {
        System.out.println("Animal - Name: " + name + ", Age: " + age);
    }
}

// Child class demonstrating super() and super.method()
class Dog extends Animal {
    String breed;

    // Constructor using super() to call parent constructor
    Dog(String name, int age, String breed) {
        super(name, age);  // MUST be first statement - calls Animal(name, age)
        this.breed = breed;
        System.out.println("Dog constructor called: " + breed);
    }

    // Overriding eat() but also calling parent's version
    @Override
    void eat() {
        super.eat();  // Call Animal's eat() method first
        System.out.println(name + " is eating dog food specifically!");
    }

    @Override
    void displayInfo() {
        super.displayInfo();  // Call parent's displayInfo()
        System.out.println("Dog - Breed: " + breed);
    }

    void bark() {
        System.out.println(name + " says: Woof!");
    }
}

// Demonstrating constructor chaining
class Grandparent {
    Grandparent() {
        System.out.println("1. Grandparent constructor");
    }
}

class Parent extends Grandparent {
    Parent() {
        // super() is implicitly called
        System.out.println("2. Parent constructor");
    }
}

class Child extends Parent {
    Child() {
        // super() is implicitly called
        System.out.println("3. Child constructor");
    }
}

// Demonstrating super.field for variable shadowing
class Vehicle {
    int maxSpeed = 100;
    String type = "Generic Vehicle";
}

class Car extends Vehicle {
    int maxSpeed = 200;  // Shadows parent's maxSpeed
    String type = "Car";  // Shadows parent's type

    void displaySpeeds() {
        System.out.println("Car's maxSpeed (this.maxSpeed): " + this.maxSpeed);
        System.out.println("Vehicle's maxSpeed (super.maxSpeed): " + super.maxSpeed);
        System.out.println("Car's type: " + type);
        System.out.println("Vehicle's type: " + super.type);
    }
}

public class InheritanceSuper {
    public static void main(String[] args) {
        System.out.println("=== super() Constructor Demo ===\n");

        Dog myDog = new Dog("Buddy", 3, "Golden Retriever");

        System.out.println("\n=== super.method() Demo ===\n");

        myDog.eat();           // Calls overridden eat() which uses super.eat()

        System.out.println();

        myDog.displayInfo();   // Calls overridden displayInfo() which uses super.displayInfo()

        System.out.println("\n=== Constructor Chaining Demo ===\n");

        // Creating Child will trigger all constructors up the chain
        Child child = new Child();

        System.out.println("\n=== super.field (Variable Shadowing) Demo ===\n");

        Car myCar = new Car();
        myCar.displaySpeeds();

        System.out.println("\n=== Key Takeaways ===");
        System.out.println("1. super() must be first statement in constructor");
        System.out.println("2. super.method() calls parent's version of method");
        System.out.println("3. super.field accesses parent's shadowed field");
        System.out.println("4. Constructors chain from parent to child");
    }
}
