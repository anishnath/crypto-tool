// Type Annotations vs Type Inference

// Type Inference - TypeScript automatically determines the type
let inferredString = "Hello";     // TypeScript infers: string
let inferredNumber = 42;           // TypeScript infers: number
let inferredBoolean = true;        // TypeScript infers: boolean

console.log("Inferred types work perfectly!");

// Explicit Type Annotations - You specify the type
let annotatedString: string = "World";
let annotatedNumber: number = 100;
let annotatedBoolean: boolean = false;

console.log("Annotated types provide clarity!");

// When to use annotations: Variables without initial values
let futureValue: string;  // Must annotate - no value to infer from
futureValue = "Assigned later";

// Function parameters ALWAYS need annotations
function greet(personName: string, age: number): string {
    return `Hello, ${personName}! You are ${age} years old.`;
}

console.log(greet("Alice", 25));

// Best practice: Let TypeScript infer when obvious
let city = "New York";        // Inference is clear
let population: number;        // Annotation needed (no initial value)
population = 8000000;
