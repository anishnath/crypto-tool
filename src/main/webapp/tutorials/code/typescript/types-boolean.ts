// Boolean Type - True or False

let isLoggedIn: boolean = true;
let hasPermission: boolean = false;

console.log("Is logged in?", isLoggedIn);
console.log("Has permission?", hasPermission);

// Booleans from comparisons
let age: number = 25;
let isAdult: boolean = age >= 18;
let isTeenager: boolean = age >= 13 && age <= 19;

console.log(`Age: ${age}`);
console.log(`Is adult? ${isAdult}`);
console.log(`Is teenager? ${isTeenager}`);

// Logical operations
let canVote: boolean = isAdult && isLoggedIn;
let needsParentalConsent: boolean = !isAdult;

console.log(`Can vote? ${canVote}`);
console.log(`Needs parental consent? ${needsParentalConsent}`);

// Boolean in conditional logic
if (isLoggedIn) {
    console.log("Welcome back!");
} else {
    console.log("Please log in.");
}
