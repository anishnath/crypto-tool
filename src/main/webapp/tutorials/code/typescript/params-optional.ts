// Optional Parameters (use ?)

function greet(firstName: string, lastName?: string): string {
    if (lastName) {
        return `Hello, ${firstName} ${lastName}!`;
    }
    return `Hello, ${firstName}!`;
}

console.log(greet("Alice"));
console.log(greet("Bob", "Smith"));
