// The never Type - Values That Never Occur

// Function that never returns (throws error)
function throwError(message: string): never {
    throw new Error(message);
}

// Function with infinite loop
function infiniteLoop(): never {
    while (true) {
        // Never exits
    }
}

// Exhaustive type checking
type Shape = "circle" | "square";

function getArea(shape: Shape): number {
    switch (shape) {
        case "circle":
            return 3.14;
        case "square":
            return 4;
        default:
            const exhaustive: never = shape;
            return exhaustive;
    }
}

console.log("Circle area:", getArea("circle"));
