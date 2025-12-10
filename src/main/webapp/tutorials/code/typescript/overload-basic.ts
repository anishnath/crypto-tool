// Function Overloading

// Overload signatures
function combine(a: string, b: string): string;
function combine(a: number, b: number): number;

// Implementation signature
function combine(a: any, b: any): any {
    if (typeof a === "string" && typeof b === "string") {
        return a + b;
    }
    if (typeof a === "number" && typeof b === "number") {
        return a + b;
    }
}

console.log(combine("Hello", " World"));
console.log(combine(5, 10));
