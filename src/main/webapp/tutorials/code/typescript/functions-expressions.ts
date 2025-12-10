// Function Expressions

// Function expression with explicit type
let multiply: (x: number, y: number) => number = function(x, y) {
    return x * y;
};

// Shorter with type inference
let divide = function(x: number, y: number): number {
    return x / y;
};

console.log("4 * 5 =", multiply(4, 5));
console.log("20 / 4 =", divide(20, 4));
