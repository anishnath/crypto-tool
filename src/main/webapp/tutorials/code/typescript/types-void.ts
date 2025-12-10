// The void Type - No Return Value

function logMessage(message: string): void {
    console.log(message);
    // No return statement
}

function displayWarning(): void {
    console.log("Warning!");
    return; // Can return without a value
}

logMessage("Hello, TypeScript!");
displayWarning();

// void variables can only be undefined or null
let unusable: void = undefined;
