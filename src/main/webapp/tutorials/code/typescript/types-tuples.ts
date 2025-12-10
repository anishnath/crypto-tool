// Tuples - Fixed Length, Specific Types

// Tuple: [string, number]
let person: [string, number] = ["Alice", 25];
console.log("Name:", person[0], "Age:", person[1]);

// Tuple: [string, number, boolean]
let user: [string, number, boolean] = ["Bob", 30, true];
console.log("User:", user);

// Type safety enforced
// let invalid: [string, number] = [25, "Alice"]; // Error! Wrong order
// let tooMany: [string, number] = ["Alice", 25, true]; // Error! Too many

// Readonly tuples
let coordinates: readonly [number, number] = [40.7128, -74.0060];
// coordinates[0] = 50; // Error! Cannot modify
console.log("Coordinates:", coordinates);
