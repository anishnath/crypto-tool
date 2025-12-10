// Parameter Properties Shorthand

class User {
    // Traditional way - verbose
    // userName: string;
    // email: string;
    // constructor(userName: string, email: string) {
    //     this.userName = userName;
    //     this.email = email;
    // }
    
    // Shorthand - much cleaner!
    constructor(
        public userName: string,
        public email: string,
        public isActive: boolean = true
    ) {
        console.log(`User ${userName} created`);
    }
    
    getInfo(): string {
        return `${this.userName} (${this.email})`;
    }
}

let user = new User("alice", "alice@example.com");
console.log(user.getInfo());
console.log("Active:", user.isActive);
