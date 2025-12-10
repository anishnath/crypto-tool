// Return Types

// Explicit return type
function getFullName(first: string, last: string): string {
    return `${first} ${last}`;
}

// Inferred return type (TypeScript figures it out)
function calculateArea(width: number, height: number) {
    return width * height;  // Inferred as number
}

// void return type
function printInfo(info: string): void {
    console.log(info);
    // No return statement
}

// never return type (function never returns)
function throwError(message: string): never {
    throw new Error(message);
}

console.log(getFullName("John", "Doe"));
console.log("Area:", calculateArea(10, 5));
printInfo("TypeScript rocks!");
