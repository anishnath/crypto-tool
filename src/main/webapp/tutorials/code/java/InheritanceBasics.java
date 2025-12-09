// Superclass (Parent class)
class Animal {
    String name;
    int age;

    void eat() {
        System.out.println(name + " is eating.");
    }

    void sleep() {
        System.out.println(name + " is sleeping.");
    }

    void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age);
    }
}

// Subclass (Child class) - inherits from Animal
class Dog extends Animal {
    String breed;

    void bark() {
        System.out.println(name + " says: Woof! Woof!");
    }

    void fetch() {
        System.out.println(name + " is fetching the ball!");
    }
}

// Another subclass of Animal
class Cat extends Animal {
    boolean isIndoor;

    void meow() {
        System.out.println(name + " says: Meow!");
    }

    void scratch() {
        System.out.println(name + " is scratching the furniture!");
    }
}

// Multi-level inheritance example
class Mammal extends Animal {
    void warmBlooded() {
        System.out.println(name + " is warm-blooded.");
    }
}

class Whale extends Mammal {
    void swim() {
        System.out.println(name + " is swimming in the ocean.");
    }
}

public class InheritanceBasics {
    public static void main(String[] args) {
        System.out.println("=== Basic Inheritance Demo ===\n");

        // Create a Dog object
        Dog myDog = new Dog();
        myDog.name = "Buddy";
        myDog.age = 3;
        myDog.breed = "Golden Retriever";

        // Dog can use inherited methods from Animal
        myDog.displayInfo();    // Inherited from Animal
        myDog.eat();            // Inherited from Animal
        myDog.sleep();          // Inherited from Animal
        myDog.bark();           // Defined in Dog
        myDog.fetch();          // Defined in Dog

        System.out.println("\n=== Cat Example ===\n");

        // Create a Cat object
        Cat myCat = new Cat();
        myCat.name = "Whiskers";
        myCat.age = 5;
        myCat.isIndoor = true;

        myCat.displayInfo();    // Inherited from Animal
        myCat.eat();            // Inherited from Animal
        myCat.meow();           // Defined in Cat

        System.out.println("\n=== Multi-level Inheritance ===\n");

        // Whale extends Mammal extends Animal
        Whale whale = new Whale();
        whale.name = "Moby";
        whale.age = 20;

        whale.displayInfo();    // From Animal (grandparent)
        whale.eat();            // From Animal
        whale.warmBlooded();    // From Mammal (parent)
        whale.swim();           // From Whale (own method)

        System.out.println("\n=== IS-A Relationship ===\n");

        // Dog IS-A Animal
        System.out.println("myDog instanceof Dog: " + (myDog instanceof Dog));
        System.out.println("myDog instanceof Animal: " + (myDog instanceof Animal));

        // Cat IS-A Animal
        System.out.println("myCat instanceof Cat: " + (myCat instanceof Cat));
        System.out.println("myCat instanceof Animal: " + (myCat instanceof Animal));

        // Whale IS-A Mammal IS-A Animal
        System.out.println("whale instanceof Whale: " + (whale instanceof Whale));
        System.out.println("whale instanceof Mammal: " + (whale instanceof Mammal));
        System.out.println("whale instanceof Animal: " + (whale instanceof Animal));
    }
}
