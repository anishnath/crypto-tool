// Conditional Types

// Basic conditional type
type IsString<T> = T extends string ? true : false;

type Test1 = IsString<string>;  // true
type Test2 = IsString<number>;  // false

// Extract array element type
type ArrayElement<T> = T extends (infer E)[] ? E : never;

type StringArray = ArrayElement<string[]>;  // string
type NumberArray = ArrayElement<number[]>;  // number

// Exclude null and undefined
type NonNullable<T> = T extends null | undefined ? never : T;

type MaybeString = string | null;
type DefiniteString = NonNullable<MaybeString>;  // string

// Function return type extraction
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

function getUserName(): string {
    return "Alice";
}

type UserNameType = ReturnType<typeof getUserName>;  // string

console.log("Conditional types demonstrated");
