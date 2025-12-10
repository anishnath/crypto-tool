// Strict Mode Configuration

// tsconfig.json should have:
// {
//   "compilerOptions": {
//     "strict": true,
//     "noImplicitAny": true,
//     "strictNullChecks": true,
//     "strictFunctionTypes": true,
//     "strictPropertyInitialization": true
//   }
// }

// With strict mode enabled:

class UserProfile {
    // Must initialize or mark as optional
    userName: string;
    email: string;
    age?: number;  // Optional
    
    constructor(userName: string, email: string) {
        this.userName = userName;
        this.email = email;
    }
}

// No implicit any
function processData(data: unknown) {  // Must specify type
    if (typeof data === "string") {
        return data.toUpperCase();
    }
    return null;
}

// Strict null checks
function getLength(str: string | null): number {
    if (str === null) {
        return 0;
    }
    return str.length;  // Safe - null checked
}

console.log("Strict mode demonstrated");
