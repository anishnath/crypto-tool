fn main() {
    // Define and instantiate a struct
    struct User {
        username: String,
        email: String,
        sign_in_count: u64,
        active: bool,
    }
    
    // Create an instance
    let user1 = User {
        email: String::from("user@example.com"),
        username: String::from("someuser123"),
        active: true,
        sign_in_count: 1,
    };
    
    // Access fields with dot notation
    println!("Username: {}", user1.username);
    println!("Email: {}", user1.email);
    println!("Active: {}", user1.active);
    println!("Sign-in count: {}", user1.sign_in_count);
    
    // Mutable struct
    let mut user2 = User {
        email: String::from("another@example.com"),
        username: String::from("anotheruser"),
        active: true,
        sign_in_count: 1,
    };
    
    // Modify a field
    user2.email = String::from("newemail@example.com");
    user2.sign_in_count += 1;
    
    println!("\nUpdated user2:");
    println!("Email: {}", user2.email);
    println!("Sign-in count: {}", user2.sign_in_count);
    
    // Note: entire instance must be mutable
    // Can't have only some fields mutable
}

// Function that returns a struct
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}

// Shorthand when parameter names match field names
fn build_user_shorthand(email: String, username: String) -> User {
    User {
        email,      // Shorthand!
        username,   // Shorthand!
        active: true,
        sign_in_count: 1,
    }
}

struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
