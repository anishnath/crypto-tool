// Utility Types: Partial & Required

interface User {
    id: number;
    userName: string;
    email: string;
    age: number;
}

// Partial - makes all properties optional
type PartialUser = Partial<User>;

let updateUser: PartialUser = {
    userName: "NewName"  // Only updating name
};

console.log(updateUser);

// Required - makes all properties required
interface OptionalConfig {
    host?: string;
    port?: number;
}

type RequiredConfig = Required<OptionalConfig>;

let config: RequiredConfig = {
    host: "localhost",
    port: 3000  // Both required now
};

console.log(config);
