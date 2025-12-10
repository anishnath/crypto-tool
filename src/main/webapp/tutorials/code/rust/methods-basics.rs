fn main() {
    // Define a struct
    struct Rectangle {
        width: u32,
        height: u32,
    }
    
    // Implement methods for Rectangle
    impl Rectangle {
        // Method with &self - borrows the instance
        fn area(&self) -> u32 {
            self.width * self.height
        }
        
        // Method with &self
        fn can_hold(&self, other: &Rectangle) -> bool {
            self.width > other.width && self.height > other.height
        }
        
        // Method with &mut self - can modify the instance
        fn scale(&mut self, factor: u32) {
            self.width *= factor;
            self.height *= factor;
        }
    }
    
    // Create instances
    let mut rect1 = Rectangle {
        width: 30,
        height: 50,
    };
    
    let rect2 = Rectangle {
        width: 10,
        height: 40,
    };
    
    // Call methods using dot notation
    println!("Area of rect1: {}", rect1.area());
    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    
    // Modify with mutable method
    rect1.scale(2);
    println!("After scaling, area: {}", rect1.area());
}

// Note: impl blocks can be defined separately from struct definition
