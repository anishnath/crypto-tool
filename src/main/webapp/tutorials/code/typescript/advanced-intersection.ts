// Intersection Types (AND logic)

type Named = {
    firstName: string;
    lastName: string;
};

type Aged = {
    age: number;
};

type Person = Named & Aged;

let person: Person = {
    firstName: "Alice",
    lastName: "Johnson",
    age: 25
};

console.log(person);

// Combining multiple types
type Timestamped = {
    createdAt: Date;
};

type User = Named & Aged & Timestamped;

let user: User = {
    firstName: "Bob",
    lastName: "Smith",
    age: 30,
    createdAt: new Date()
};

console.log(user);
