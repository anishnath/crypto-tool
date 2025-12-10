// Arrow Functions - Concise Syntax

// Single parameter, single expression
let square = (x: number): number => x * x;

// Multiple parameters
let add = (a: number, b: number): number => a + b;

// Multiple statements need braces
let greet = (personName: string): string => {
    let greeting = `Hello, ${personName}!`;
    return greeting;
};

// No parameters
let getRandom = (): number => Math.random();

console.log("Square of 5:", square(5));
console.log("3 + 7 =", add(3, 7));
console.log(greet("Bob"));
console.log("Random:", getRandom());
