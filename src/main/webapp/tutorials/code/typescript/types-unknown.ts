// The unknown Type - Type-Safe Alternative to any

let value: unknown = "hello";
value = 42;
value = true;

// Cannot use unknown without type checking
// let str: string = value;  // Error!

// Must check type first
if (typeof value === "string") {
    let str: string = value;  // OK now
    console.log("String:", str);
}

if (typeof value === "number") {
    let num: number = value;
    console.log("Number:", num);
}

// unknown is safer than any!
