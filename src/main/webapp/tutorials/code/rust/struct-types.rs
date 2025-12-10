fn main() {
    // Tuple structs - structs without named fields
    struct Color(i32, i32, i32);
    struct Point(i32, i32, i32);
    
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);
    
    // Access with dot notation and index
    println!("Black: ({}, {}, {})", black.0, black.1, black.2);
    println!("Origin: ({}, {}, {})", origin.0, origin.1, origin.2);
    
    // Note: Color and Point are different types!
    // let color: Color = origin;  // Error! Different types
    
    // Unit-like structs - no fields
    struct AlwaysEqual;
    
    let subject = AlwaysEqual;
    
    // Useful for implementing traits without data
    println!("Created unit-like struct");
    
    // Destructuring tuple structs
    let white = Color(255, 255, 255);
    let Color(r, g, b) = white;
    println!("RGB: ({}, {}, {})", r, g, b);
    
    // Practical example: Coordinates
    struct Coordinates(f64, f64);  // latitude, longitude
    
    let location = Coordinates(37.7749, -122.4194);  // San Francisco
    println!("Location: ({}, {})", location.0, location.1);
}

// Tuple structs are useful when:
// 1. You want to give the tuple a name
// 2. Make it a different type from other tuples
// 3. Naming each field would be verbose
