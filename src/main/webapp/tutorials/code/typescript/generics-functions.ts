// Generic Functions

// Generic function with type inference
function wrap<T>(value: T): { data: T } {
    return { data: value };
}

let wrapped = wrap(123);  // Type inferred as { data: number }
console.log(wrapped);

// Multiple type parameters
function pair<T, U>(first: T, second: U): [T, U] {
    return [first, second];
}

let result = pair("Alice", 25);  // [string, number]
console.log(result);

// Generic array operations
function map<T, U>(arr: T[], fn: (item: T) => U): U[] {
    return arr.map(fn);
}

let numbers = [1, 2, 3];
let strings = map(numbers, n => n.toString());
console.log(strings);
