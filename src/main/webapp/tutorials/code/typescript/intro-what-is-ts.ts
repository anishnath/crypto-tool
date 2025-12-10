// 1. Static Typing
let message: string = "Hello, TypeScript!";
// message = 123; // Error: Type 'number' is not assignable to type 'string'.

// 2. Interfaces
interface User {
    id: number;
    name: string;
}

const user: User = {
    id: 1,
    name: "Alice"
};

// 3. Classes
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}

let greeter = new Greeter("world");

console.log(message);
console.log("User ID:", user.id);
console.log(greeter.greet());
