// Discriminated Unions

type Circle = {
    kind: "circle";
    radius: number;
};

type Rectangle = {
    kind: "rectangle";
    width: number;
    height: number;
};

type Triangle = {
    kind: "triangle";
    base: number;
    heightTriangle: number;
};

type Shape = Circle | Rectangle | Triangle;

function calculateArea(shape: Shape): number {
    switch (shape.kind) {
        case "circle":
            return Math.PI * shape.radius * shape.radius;
        case "rectangle":
            return shape.width * shape.height;
        case "triangle":
            return (shape.base * shape.heightTriangle) / 2;
    }
}

let circle: Circle = { kind: "circle", radius: 5 };
let rectangle: Rectangle = { kind: "rectangle", width: 10, height: 5 };
let triangle: Triangle = { kind: "triangle", base: 8, heightTriangle: 6 };

console.log("Circle area:", calculateArea(circle));
console.log("Rectangle area:", calculateArea(rectangle));
console.log("Triangle area:", calculateArea(triangle));
