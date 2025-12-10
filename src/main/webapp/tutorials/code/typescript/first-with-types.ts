// TypeScript with Type Annotations

// Variables with type annotations
let userName: string = "Alice";
let age: number = 25;
let isStudent: boolean = true;

// Function with typed parameters and return type
function greet(person: string): void {
    console.log(`Hello, ${person}!`);
}

// Function that returns a value
function add(a: number, b: number): number {
    return a + b;
}

// Using the functions
greet(userName);
console.log(`${userName} is ${age} years old`);
console.log(`Is student: ${isStudent}`);
console.log(`5 + 3 = ${add(5, 3)}`);
