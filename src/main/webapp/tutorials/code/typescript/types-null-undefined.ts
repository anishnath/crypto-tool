// null and undefined Types

let notAssigned: undefined = undefined;
let empty: null = null;

console.log("Undefined:", notAssigned);
console.log("Null:", empty);

// Optional properties can be undefined
function greet(personName?: string): void {
    if (personName === undefined) {
        console.log("Hello, guest!");
    } else {
        console.log(`Hello, ${personName}!`);
    }
}

greet();
greet("Alice");

// Null checking
let value: string | null = null;
if (value !== null) {
    console.log(value.toUpperCase());
}
