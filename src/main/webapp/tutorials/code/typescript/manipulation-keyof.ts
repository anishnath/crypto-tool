// keyof Operator

interface Person {
    personName: string;
    age: number;
    email: string;
}

// keyof creates union of keys
type PersonKeys = keyof Person;  // "personName" | "age" | "email"

function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}

let person: Person = {
    personName: "Alice",
    age: 25,
    email: "alice@example.com"
};

let personName = getProperty(person, "personName");  // Type: string
let personAge = getProperty(person, "age");  // Type: number

console.log(personName, personAge);
