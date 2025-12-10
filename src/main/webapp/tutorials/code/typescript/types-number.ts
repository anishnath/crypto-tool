// Number Type - All Numeric Values

// Integers
let age: number = 25;
let score: number = 100;

// Decimals
let price: number = 19.99;
let pi: number = 3.14159;

// Negative numbers
let temperature: number = -5;

// Different number formats
let decimal: number = 42;
let hex: number = 0x2A;        // Hexadecimal (42 in decimal)
let binary: number = 0b101010;  // Binary (42 in decimal)
let octal: number = 0o52;       // Octal (42 in decimal)

console.log("Decimal:", decimal);
console.log("Hex:", hex);
console.log("Binary:", binary);
console.log("Octal:", octal);

// All represent the same value!
console.log("All equal?", decimal === hex && hex === binary && binary === octal);

// Arithmetic operations
let sum: number = 10 + 5;
let difference: number = 10 - 5;
let product: number = 10 * 5;
let quotient: number = 10 / 5;
let remainder: number = 10 % 3;

console.log(`Sum: ${sum}, Difference: ${difference}, Product: ${product}`);
console.log(`Quotient: ${quotient}, Remainder: ${remainder}`);
