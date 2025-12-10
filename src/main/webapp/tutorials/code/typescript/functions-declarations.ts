// Function Declarations with Type Annotations

// Basic function with typed parameters and return type
function greet(personName: string): string {
    return `Hello, ${personName}!`;
}

// Function with multiple parameters
function add(a: number, b: number): number {
    return a + b;
}

// Function with void return (no return value)
function logMessage(message: string): void {
    console.log(message);
}

// Using the functions
console.log(greet("Alice"));
console.log("5 + 3 =", add(5, 3));
logMessage("TypeScript is awesome!");
