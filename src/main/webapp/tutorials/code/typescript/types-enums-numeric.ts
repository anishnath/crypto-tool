// Numeric Enums

enum Direction {
    Up,      // 0
    Down,    // 1
    Left,    // 2
    Right    // 3
}

console.log("Up:", Direction.Up);
console.log("Down:", Direction.Down);

// Custom starting value
enum Status {
    Pending = 1,
    Approved,    // 2
    Rejected     // 3
}

console.log("Pending:", Status.Pending);
console.log("Approved:", Status.Approved);

// Using enums
let currentDirection: Direction = Direction.Up;
console.log("Current direction:", currentDirection);
