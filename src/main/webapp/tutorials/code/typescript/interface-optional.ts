// Optional Properties in Interfaces

interface User {
    userName: string;
    email: string;
    age?: number;  // Optional
}

let user1: User = {
    userName: "alice",
    email: "alice@example.com",
    age: 25
};

let user2: User = {
    userName: "bob",
    email: "bob@example.com"
    // age is optional
};

console.log(user1);
console.log(user2);
