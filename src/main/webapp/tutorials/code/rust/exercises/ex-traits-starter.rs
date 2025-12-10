// Exercise: Traits Practice

fn main() {
    // TODO: Define a trait called Drawable with a method draw() that returns a String
    
    // TODO: Implement Drawable for Circle and Rectangle
    struct Circle {
        radius: f64,
    }
    
    struct Rectangle {
        width: f64,
        height: f64,
    }
    
    // TODO: Define a trait called Area with a method area() that returns f64
    
    // TODO: Implement Area for Circle and Rectangle
    
    // TODO: Write a function print_drawing that accepts any type implementing Drawable
    // fn print_drawing(item: &impl Drawable) {
    //     println!("{}", item.draw());
    // }
    
    // TODO: Write a function total_area that accepts a slice of items implementing Area
    // fn total_area(shapes: &[&impl Area]) -> f64 {
    //     shapes.iter().map(|s| s.area()).sum()
    // }
    
    // Test your implementations
    let circle = Circle { radius: 5.0 };
    let rect = Rectangle { width: 10.0, height: 5.0 };
    
    // print_drawing(&circle);
    // print_drawing(&rect);
    // println!("Circle area: {}", circle.area());
    // println!("Rectangle area: {}", rect.area());
}

// Hints:
// 1. Use trait keyword to define traits
// 2. Use impl TraitName for TypeName to implement
// 3. Use &impl Trait for trait parameters
// 4. Circle area: π * r²
// 5. Rectangle area: width * height
// 6. Use std::f64::consts::PI for π
