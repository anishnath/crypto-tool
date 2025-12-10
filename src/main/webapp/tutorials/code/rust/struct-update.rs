fn main() {
    struct User {
        username: String,
        email: String,
        active: bool,
        sign_in_count: u64,
    }
    
    let user1 = User {
        email: String::from("user1@example.com"),
        username: String::from("user1"),
        active: true,
        sign_in_count: 1,
    };
    
    // Struct update syntax - create new instance from existing
    let user2 = User {
        email: String::from("user2@example.com"),
        username: String::from("user2"),
        ..user1  // Use remaining fields from user1
    };
    
    println!("User2 email: {}", user2.email);
    println!("User2 active: {}", user2.active);
    
    // Note: user1 is no longer valid because String fields were moved
    // println!("{}", user1.username);  // Error!
    
    // With Copy types, original is still valid
    struct Point {
        x: i32,
        y: i32,
    }
    
    let point1 = Point { x: 10, y: 20 };
    let point2 = Point {
        x: 5,
        ..point1  // Copy y from point1
    };
    
    println!("Point1: ({}, {})", point1.x, point1.y);  // Still valid!
    println!("Point2: ({}, {})", point2.x, point2.y);
}

struct User {
    username: String,
    email: String,
    active: bool,
    sign_in_count: u64,
}
