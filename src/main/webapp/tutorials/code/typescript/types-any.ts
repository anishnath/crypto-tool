// The any Type - Disables Type Checking

let anything: any = "hello";
anything = 42;           // OK
anything = true;         // OK
anything = [1, 2, 3];    // OK

console.log("Any can be anything:", anything);

// Dangerous - no type safety!
let value: any = "text";
let textLength: number = value.length;  // OK
// value.nonExistent();  // No error, but will crash at runtime!

// Use any sparingly - only when absolutely necessary
