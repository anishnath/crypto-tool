// Interface Basics

interface Person {
    firstName: string;
    lastName: string;
    age: number;
}

function greet(person: Person): string {
    return `Hello, ${person.firstName} ${person.lastName}!`;
}

let user: Person = {
    firstName: "Alice",
    lastName: "Johnson",
    age: 25
};

console.log(greet(user));
