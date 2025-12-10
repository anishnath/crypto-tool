fn main() {
    struct Point {
        x: f64,
        y: f64,
    }
    
    // Multiple impl blocks are allowed
    impl Point {
        fn new(x: f64, y: f64) -> Point {
            Point { x, y }
        }
    }
    
    impl Point {
        fn distance_from_origin(&self) -> f64 {
            (self.x.powi(2) + self.y.powi(2)).sqrt()
        }
    }
    
    impl Point {
        fn translate(&mut self, dx: f64, dy: f64) {
            self.x += dx;
            self.y += dy;
        }
    }
    
    let mut p = Point::new(3.0, 4.0);
    println!("Distance from origin: {}", p.distance_from_origin());
    
    p.translate(1.0, 1.0);
    println!("After translation: ({}, {})", p.x, p.y);
    
    // Automatic referencing and dereferencing
    struct Circle {
        radius: f64,
    }
    
    impl Circle {
        fn area(&self) -> f64 {
            std::f64::consts::PI * self.radius * self.radius
        }
    }
    
    let circle = Circle { radius: 5.0 };
    
    // These are equivalent - Rust auto-references
    println!("Area: {}", circle.area());
    println!("Area: {}", (&circle).area());
    
    // Method chaining
    struct Builder {
        value: i32,
    }
    
    impl Builder {
        fn new() -> Builder {
            Builder { value: 0 }
        }
        
        fn add(&mut self, n: i32) -> &mut Self {
            self.value += n;
            self  // Return self for chaining
        }
        
        fn multiply(&mut self, n: i32) -> &mut Self {
            self.value *= n;
            self
        }
        
        fn build(&self) -> i32 {
            self.value
        }
    }
    
    let result = Builder::new()
        .add(5)
        .multiply(2)
        .add(3)
        .build();
    
    println!("Chained result: {}", result);
}

// Multiple impl blocks help organize code
// Rust automatically handles references in method calls
