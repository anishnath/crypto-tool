fn main() {
    // Returning types that implement traits
    trait Summary {
        fn summarize(&self) -> String;
    }
    
    struct Article {
        title: String,
    }
    
    impl Summary for Article {
        fn summarize(&self) -> String {
            format!("Article: {}", self.title)
        }
    }
    
    struct Tweet {
        content: String,
    }
    
    impl Summary for Tweet {
        fn summarize(&self) -> String {
            format!("Tweet: {}", self.content)
        }
    }
    
    // Return impl Trait
    fn returns_summarizable() -> impl Summary {
        Article {
            title: String::from("Rust Traits are Powerful"),
        }
    }
    
    // Note: Can only return ONE concrete type
    // This won't work:
    // fn returns_summarizable(switch: bool) -> impl Summary {
    //     if switch {
    //         Article { title: String::from("Article") }
    //     } else {
    //         Tweet { content: String::from("Tweet") }  // Error!
    //     }
    // }
    
    let item = returns_summarizable();
    println!("{}", item.summarize());
    
    // Common standard library traits
    #[derive(Debug, Clone, PartialEq)]
    struct Point {
        x: i32,
        y: i32,
    }
    
    let p1 = Point { x: 5, y: 10 };
    let p2 = p1.clone();
    
    println!("p1: {:?}", p1);  // Debug trait
    println!("p1 == p2: {}", p1 == p2);  // PartialEq trait
    
    // Implementing Display trait
    use std::fmt;
    
    struct Circle {
        radius: f64,
    }
    
    impl fmt::Display for Circle {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            write!(f, "Circle with radius {}", self.radius)
        }
    }
    
    let circle = Circle { radius: 5.0 };
    println!("{}", circle);  // Uses Display trait
}

// impl Trait in return position
// Derive common traits with #[derive]
// Implement standard library traits like Display
