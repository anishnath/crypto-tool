// Mapped Types

interface User {
    userName: string;
    email: string;
    age: number;
}

// Make all properties optional
type PartialUser = {
    [K in keyof User]?: User[K];
};

// Make all properties readonly
type ReadonlyUser = {
    readonly [K in keyof User]: User[K];
};

// Transform property types
type StringifiedUser = {
    [K in keyof User]: string;
};

let partialUser: PartialUser = {
    userName: "Alice"  // Only some properties
};

let readonlyUser: ReadonlyUser = {
    userName: "Bob",
    email: "bob@example.com",
    age: 30
};

// readonlyUser.userName = "Charlie";  // ✗ Error - readonly!

console.log(partialUser, readonlyUser);
