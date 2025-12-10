// Generic Types

// Generic function - works with any type
function identity<T>(value: T): T {
    return value;
}

let num = identity<number>(42);
let str = identity<string>("Hello");
let bool = identity<boolean>(true);

console.log(num, str, bool);

// Generic array function
function getFirst<T>(arr: T[]): T | undefined {
    return arr[0];
}

let firstNum = getFirst([1, 2, 3]);
let firstStr = getFirst(["a", "b", "c"]);

console.log(firstNum, firstStr);
