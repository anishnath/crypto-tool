// String Type - Three Ways to Define Strings

// 1. Double quotes
let firstName: string = "Alice";

// 2. Single quotes
let lastName: string = 'Johnson';

// 3. Template literals (backticks) - most powerful!
let fullName: string = `${firstName} ${lastName}`;

console.log("First Name:", firstName);
console.log("Last Name:", lastName);
console.log("Full Name:", fullName);

// String methods
console.log("Uppercase:", fullName.toUpperCase());
console.log("Length:", fullName.length);
