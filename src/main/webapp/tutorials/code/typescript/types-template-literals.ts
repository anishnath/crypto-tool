// Template Literals - String Interpolation and Multi-line

let product: string = "Laptop";
let price: number = 999.99;
let quantity: number = 2;

// String interpolation with expressions
let message: string = `You ordered ${quantity} ${product}(s) for $${price * quantity}`;
console.log(message);

// Multi-line strings (no escape characters needed!)
let invoice: string = `
=== INVOICE ===
Product: ${product}
Price: $${price}
Quantity: ${quantity}
Total: $${price * quantity}
===============
`;

console.log(invoice);

// Expression evaluation
console.log(`Tax (10%): $${(price * quantity * 0.1).toFixed(2)}`);
console.log(`Grand Total: $${(price * quantity * 1.1).toFixed(2)}`);
