// Default Parameters

function greet(personName: string, greeting: string = "Hello"): string {
    return `${greeting}, ${personName}!`;
}

console.log(greet("Alice"));
console.log(greet("Bob", "Hi"));
console.log(greet("Charlie", "Welcome"));
