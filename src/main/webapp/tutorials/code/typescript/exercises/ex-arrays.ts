// Exercise: Shopping Cart
// TODO: Create a shopping cart system

// TODO: Create an array of product names
// let products: string[] = ...

// TODO: Create an array of prices
// let prices: number[] = ...

// TODO: Create tuples for cart items: [product, quantity, price]
// type CartItem = [string, number, number];
// let cart: CartItem[] = ...

// TODO: Calculate total
// let total: number = ...

/* Example solution:
let products: string[] = ["Laptop", "Mouse", "Keyboard"];
let prices: number[] = [999.99, 29.99, 79.99];

type CartItem = [string, number, number];
let cart: CartItem[] = [
    ["Laptop", 1, 999.99],
    ["Mouse", 2, 29.99],
    ["Keyboard", 1, 79.99]
];

let total = cart.reduce((sum, [_, qty, price]) => sum + (qty * price), 0);
console.log(`Total: $${total.toFixed(2)}`);
*/
