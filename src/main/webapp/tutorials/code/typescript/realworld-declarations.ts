// Declaration Files (.d.ts)

// Declare external library types
declare module "my-library" {
    export function doSomething(value: string): void;
    export class MyClass {
        constructor(name: string);
        getName(): string;
    }
}

// Declare global variables
declare const VERSION: string;
declare const DEBUG: boolean;

// Ambient declarations
declare namespace MyGlobal {
    function init(): void;
    const config: {
        apiKey: string;
        endpoint: string;
    };
}

// Usage (these would work if declarations match actual JS)
console.log("Declaration files demonstrated");
