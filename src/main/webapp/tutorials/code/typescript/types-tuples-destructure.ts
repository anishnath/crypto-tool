// Tuple Destructuring

// Tuple with coordinates
let point: [number, number] = [10, 20];

// Destructure into variables
let [x, y] = point;
console.log(`X: ${x}, Y: ${y}`);

// Tuple with user data
let userData: [string, number, string] = ["Alice", 25, "alice@example.com"];
let [userName, userAge, userEmail] = userData;
console.log(`${userName} is ${userAge} years old. Email: ${userEmail}`);

// Swap values using tuples
let a = 5;
let b = 10;
[a, b] = [b, a];
console.log(`After swap: a=${a}, b=${b}`);
