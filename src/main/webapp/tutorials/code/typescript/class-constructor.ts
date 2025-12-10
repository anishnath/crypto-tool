// Constructor

class User {
    userName: string;
    email: string;
    isActive: boolean;
    
    constructor(userName: string, email: string) {
        this.userName = userName;
        this.email = email;
        this.isActive = true;  // Default value
        console.log(`User ${userName} created!`);
    }
    
    deactivate(): void {
        this.isActive = false;
    }
}

let user1 = new User("alice", "alice@example.com");
let user2 = new User("bob", "bob@example.com");
console.log(user1);
