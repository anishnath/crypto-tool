// Exercise: Enums Practice

fn main() {
    // TODO: Define a Shape enum with variants for Circle, Rectangle, and Triangle
    // Circle should contain radius (f64)
    // Rectangle should contain width and height (f64, f64)
    // Triangle should contain base and height (f64, f64)
    
    // TODO: Implement area method for Shape
    
    // TODO: Define a WebEvent enum
    // PageLoad
    // PageUnload
    // KeyPress(char)
    // Click { x: i64, y: i64 }
    
    // TODO: Implement inspect method that prints event details
    
    // TODO: Write a function that returns Option<i32>
    // find_first_even that takes a Vec<i32> and returns the first even number
    
    // TODO: Write a function that returns Result<f64, String>
    // safe_sqrt that returns Ok(sqrt) for positive numbers, Err for negative
}

// Hints:
// 1. Use enum Name { Variant1, Variant2(Type), Variant3 { field: Type } }
// 2. Implement methods with impl EnumName { fn method(&self) { match self { ... } } }
// 3. Use Option::Some(value) or Option::None
// 4. Use Result::Ok(value) or Result::Err(error)
// 5. Match on enum variants to extract data
