// Array Type Syntax

// Syntax 1: type[]
let numbers: number[] = [1, 2, 3, 4, 5];
let names: string[] = ["Alice", "Bob", "Charlie"];
let flags: boolean[] = [true, false, true];

// Syntax 2: Array<type>
let scores: Array<number> = [95, 87, 92];
let cities: Array<string> = ["New York", "London", "Tokyo"];

console.log("Numbers:", numbers);
console.log("Names:", names);
console.log("Scores:", scores);

// Mixed type arrays (use union types)
let mixed: (string | number)[] = ["Alice", 25, "Bob", 30];
console.log("Mixed:", mixed);
