// Const Enums - Inlined at compile time

const enum Size {
    Small = 1,
    Medium = 2,
    Large = 3
}

let shirtSize: Size = Size.Medium;
console.log("Shirt size:", shirtSize);

// Const enums are completely removed during compilation
// The code above becomes: let shirtSize = 2;
