// Utility Types: Record & Readonly

// Record - create object type with specific keys and values
type Role = "admin" | "user" | "guest";
type Permissions = Record<Role, string[]>;

let permissions: Permissions = {
    admin: ["read", "write", "delete"],
    user: ["read", "write"],
    guest: ["read"]
};

console.log(permissions);

// Readonly - makes all properties read-only
interface Config {
    apiUrl: string;
    timeout: number;
}

type ReadonlyConfig = Readonly<Config>;

let appConfig: ReadonlyConfig = {
    apiUrl: "https://api.example.com",
    timeout: 5000
};

// appConfig.apiUrl = "new-url";  // ✗ Error - readonly!

console.log(appConfig);
