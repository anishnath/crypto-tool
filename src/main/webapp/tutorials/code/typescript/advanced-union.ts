// Union Types (OR logic)

type ID = string | number;

let userId: ID = "user123";
let productId: ID = 456;

console.log("User ID:", userId);
console.log("Product ID:", productId);

// Function with union parameter
function formatId(id: ID): string {
    if (typeof id === "string") {
        return id.toUpperCase();
    } else {
        return `ID-${id}`;
    }
}

console.log(formatId("abc123"));
console.log(formatId(789));

// Union with multiple types
type Result = "success" | "error" | "pending";
let orderStatus: Result = "success";
