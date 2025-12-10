// Literal Types

type Direction = "north" | "south" | "east" | "west";
type Status = "pending" | "approved" | "rejected";

let direction: Direction = "north";
let orderStatus: Status = "pending";

console.log("Direction:", direction);
console.log("Status:", orderStatus);

// Literal numbers
type DiceRoll = 1 | 2 | 3 | 4 | 5 | 6;
let roll: DiceRoll = 4;

// Function with literal return
function getStatus(): "active" | "inactive" {
    return "active";
}

console.log("User status:", getStatus());

// Boolean literals
type Yes = true;
type No = false;
