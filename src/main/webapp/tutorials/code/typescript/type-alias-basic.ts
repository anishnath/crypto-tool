// Type Aliases

type Point = {
    x: number;
    y: number;
};

type ID = string | number;

let point: Point = { x: 10, y: 20 };
let userId: ID = "user123";
let productId: ID = 456;

console.log("Point:", point);
console.log("User ID:", userId);
console.log("Product ID:", productId);
