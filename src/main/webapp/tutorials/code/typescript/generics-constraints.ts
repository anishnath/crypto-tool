// Generic Constraints

// Constraint with 'extends'
interface HasLength {
    length: number;
}

function logLength<T extends HasLength>(item: T): void {
    console.log("Length:", item.length);
}

logLength("Hello");  // ✓ string has length
logLength([1, 2, 3]);  // ✓ array has length
// logLength(123);  // ✗ Error - number doesn't have length

// Constraint with keyof
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}

let person = { name: "Alice", age: 25 };
let personName = getProperty(person, "name");  // Type: string
let personAge = getProperty(person, "age");  // Type: number

console.log(personName, personAge);
