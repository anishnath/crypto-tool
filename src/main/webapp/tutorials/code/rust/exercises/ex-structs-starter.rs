// Exercise: Structs Practice
// Complete the struct definitions and functions

fn main() {
    // TODO: Define a Rectangle struct with width and height fields
    
    // TODO: Create a rectangle instance
    let rect = Rectangle {
        width: 30,
        height: 50,
    };
    
    // TODO: Calculate area
    let area = calculate_area(&rect);
    println!("Area: {}", area);
    
    // TODO: Define a Person struct with name (String) and age (u32)
    
    // TODO: Create a person
    let person = Person {
        name: String::from("Alice"),
        age: 30,
    };
    
    // TODO: Print person details
    
    // TODO: Create another person using struct update syntax
    let person2 = Person {
        name: String::from("Bob"),
        ..person
    };
    
    // TODO: Define a tuple struct for RGB color
    
    // TODO: Create a color
    let red = Color(255, 0, 0);
    
    // TODO: Print color values
    
    // TODO: Define a Point3D tuple struct
    
    // TODO: Create a point and calculate distance from origin
}

// TODO: Implement calculate_area function
fn calculate_area(rect: &Rectangle) -> u32 {
    0  // Fix this
}

// TODO: Implement a function to create a square (Rectangle with equal sides)
fn create_square(size: u32) -> Rectangle {
    // Your code here
}

// TODO: Implement a function to check if person is adult (age >= 18)
fn is_adult(person: &Person) -> bool {
    false  // Fix this
}

// Hints:
// 1. Struct syntax: struct Name { field: Type, ... }
// 2. Tuple struct: struct Name(Type, Type, ...);
// 3. Access fields: instance.field or instance.0
// 4. Struct update: NewStruct { field: value, ..old_struct }
// 5. Use & to borrow structs in functions
