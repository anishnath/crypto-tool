// Base class hierarchy for demonstration
class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    void makeSound() {
        System.out.println(name + " makes a sound");
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    void bark() {
        System.out.println(name + " says: Woof!");
    }

    void fetch() {
        System.out.println(name + " is fetching the ball!");
    }
}

class Cat extends Animal {
    Cat(String name) {
        super(name);
    }

    void meow() {
        System.out.println(name + " says: Meow!");
    }

    void scratch() {
        System.out.println(name + " is scratching!");
    }
}

// Interface for demonstration
interface Swimmable {
    void swim();
}

class Fish extends Animal implements Swimmable {
    Fish(String name) {
        super(name);
    }

    public void swim() {
        System.out.println(name + " is swimming!");
    }
}

class Duck extends Animal implements Swimmable {
    Duck(String name) {
        super(name);
    }

    public void swim() {
        System.out.println(name + " is swimming in the pond!");
    }

    void quack() {
        System.out.println(name + " says: Quack!");
    }
}

public class InstanceofOperator {
    public static void main(String[] args) {
        System.out.println("=== Basic instanceof Usage ===\n");

        Dog myDog = new Dog("Buddy");
        Cat myCat = new Cat("Whiskers");

        // Check exact type
        System.out.println("myDog instanceof Dog: " + (myDog instanceof Dog));
        System.out.println("myCat instanceof Cat: " + (myCat instanceof Cat));

        // Check parent type (IS-A relationship)
        System.out.println("myDog instanceof Animal: " + (myDog instanceof Animal));
        System.out.println("myCat instanceof Animal: " + (myCat instanceof Animal));

        // Everything is an Object
        System.out.println("myDog instanceof Object: " + (myDog instanceof Object));

        // Check unrelated type
        System.out.println("myDog instanceof Cat: " + (myDog instanceof Cat));

        System.out.println("\n=== instanceof with Polymorphism ===\n");

        // Parent reference pointing to child objects
        Animal animal1 = new Dog("Rex");
        Animal animal2 = new Cat("Mittens");

        System.out.println("animal1 (Dog) instanceof Dog: " + (animal1 instanceof Dog));
        System.out.println("animal1 (Dog) instanceof Cat: " + (animal1 instanceof Cat));
        System.out.println("animal2 (Cat) instanceof Cat: " + (animal2 instanceof Cat));
        System.out.println("animal2 (Cat) instanceof Dog: " + (animal2 instanceof Dog));

        System.out.println("\n=== Safe Downcasting with instanceof ===\n");

        // Array of animals (mixed types)
        Animal[] animals = {
            new Dog("Max"),
            new Cat("Luna"),
            new Dog("Charlie"),
            new Cat("Simba")
        };

        for (Animal animal : animals) {
            // Safe downcasting using instanceof
            if (animal instanceof Dog) {
                Dog dog = (Dog) animal;  // Safe to cast
                dog.bark();
                dog.fetch();
            } else if (animal instanceof Cat) {
                Cat cat = (Cat) animal;  // Safe to cast
                cat.meow();
            }
        }

        System.out.println("\n=== instanceof with null ===\n");

        Animal nullAnimal = null;
        String nullString = null;

        // instanceof safely returns false for null
        System.out.println("null instanceof Animal: " + (nullAnimal instanceof Animal));
        System.out.println("null instanceof String: " + (nullString instanceof String));
        System.out.println("null instanceof Object: " + (nullAnimal instanceof Object));

        System.out.println("\n=== instanceof with Interfaces ===\n");

        Fish nemo = new Fish("Nemo");
        Duck donald = new Duck("Donald");

        System.out.println("Fish instanceof Swimmable: " + (nemo instanceof Swimmable));
        System.out.println("Duck instanceof Swimmable: " + (donald instanceof Swimmable));
        System.out.println("Dog instanceof Swimmable: " + (myDog instanceof Swimmable));

        System.out.println("\n=== Practical Example: Processing Mixed Collection ===\n");

        Animal[] zoo = {
            new Dog("Buddy"),
            new Cat("Whiskers"),
            new Fish("Nemo"),
            new Duck("Donald")
        };

        for (Animal animal : zoo) {
            System.out.println("Processing: " + animal.name);

            // Check for interface implementation
            if (animal instanceof Swimmable) {
                Swimmable swimmer = (Swimmable) animal;
                swimmer.swim();
            }

            // Check for specific types
            if (animal instanceof Dog) {
                ((Dog) animal).bark();
            } else if (animal instanceof Cat) {
                ((Cat) animal).meow();
            } else if (animal instanceof Duck) {
                ((Duck) animal).quack();
            }

            System.out.println();
        }

        System.out.println("=== Key Points ===");
        System.out.println("1. instanceof checks the runtime type of an object");
        System.out.println("2. Returns true for the class AND all parent classes/interfaces");
        System.out.println("3. Returns false for null (safe, no exception)");
        System.out.println("4. Essential for safe downcasting");
    }
}
