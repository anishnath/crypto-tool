// Function Type Aliases

// Define a function type
type MathOperation = (a: number, b: number) => number;

// Use the type alias
let add: MathOperation = (a, b) => a + b;
let subtract: MathOperation = (a, b) => a - b;
let multiply: MathOperation = (a, b) => a * b;

// Function that accepts a function type
function calculate(x: number, y: number, operation: MathOperation): number {
    return operation(x, y);
}

console.log("Add:", calculate(10, 5, add));
console.log("Subtract:", calculate(10, 5, subtract));
console.log("Multiply:", calculate(10, 5, multiply));
