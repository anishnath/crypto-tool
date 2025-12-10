// Inheritance with extends

class Animal {
    constructor(public nameAnimal: string) {}
    
    makeSound(): void {
        console.log("Some generic sound");
    }
    
    move(): void {
        console.log(`${this.nameAnimal} is moving`);
    }
}

class Dog extends Animal {
    constructor(nameAnimal: string, public breed: string) {
        super(nameAnimal);  // Call parent constructor
    }
    
    // Override parent method
    makeSound(): void {
        console.log("Woof! Woof!");
    }
    
    // New method specific to Dog
    bark(): void {
        console.log(`${this.nameAnimal} is barking!`);
    }
}

let dog = new Dog("Buddy", "Golden Retriever");
dog.makeSound();  // Woof! Woof!
dog.move();       // Buddy is moving
dog.bark();       // Buddy is barking!
