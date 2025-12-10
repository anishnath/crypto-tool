// Readonly Arrays

let mutableNumbers: number[] = [1, 2, 3];
mutableNumbers.push(4); // OK
console.log("Mutable:", mutableNumbers);

// Readonly array - cannot be modified
let readonlyNumbers: readonly number[] = [1, 2, 3];
// readonlyNumbers.push(4); // Error!
// readonlyNumbers[0] = 10; // Error!
console.log("Readonly:", readonlyNumbers);

// ReadonlyArray<T> syntax
let alsoReadonly: ReadonlyArray<string> = ["a", "b", "c"];
// alsoReadonly.push("d"); // Error!
console.log("Also readonly:", alsoReadonly);
