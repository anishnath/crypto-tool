// Basic Class

class Person {
    // Properties
    personName: string;
    age: number;
    
    // Constructor
    constructor(personName: string, age: number) {
        this.personName = personName;
        this.age = age;
    }
    
    // Method
    greet(): string {
        return `Hello, I'm ${this.personName} and I'm ${this.age} years old.`;
    }
}

// Create instance
let person = new Person("Alice", 25);
console.log(person.greet());
