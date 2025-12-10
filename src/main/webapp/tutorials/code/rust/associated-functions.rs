fn main() {
    struct Rectangle {
        width: u32,
        height: u32,
    }
    
    impl Rectangle {
        // Associated function (no self) - like a constructor
        fn new(width: u32, height: u32) -> Rectangle {
            Rectangle { width, height }
        }
        
        // Another associated function - create a square
        fn square(size: u32) -> Rectangle {
            Rectangle {
                width: size,
                height: size,
            }
        }
        
        // Method
        fn area(&self) -> u32 {
            self.width * self.height
        }
    }
    
    // Call associated functions with ::
    let rect = Rectangle::new(30, 50);
    let sq = Rectangle::square(25);
    
    println!("Rectangle area: {}", rect.area());
    println!("Square area: {}", sq.area());
    
    // Common pattern: new() as constructor
    struct User {
        username: String,
        email: String,
        active: bool,
    }
    
    impl User {
        fn new(username: String, email: String) -> User {
            User {
                username,
                email,
                active: true,  // Default value
            }
        }
        
        fn deactivate(&mut self) {
            self.active = false;
        }
    }
    
    let mut user = User::new(
        String::from("alice"),
        String::from("alice@example.com"),
    );
    
    println!("User active: {}", user.active);
    user.deactivate();
    println!("User active after deactivate: {}", user.active);
}

// Associated functions are often used for constructors
// They're called with Type::function() syntax
