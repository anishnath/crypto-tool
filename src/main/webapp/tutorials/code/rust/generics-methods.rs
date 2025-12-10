fn main() {
    // Generic struct
    struct Point<T> {
        x: T,
        y: T,
    }
    
    // Generic implementation for all types
    impl<T> Point<T> {
        fn x(&self) -> &T {
            &self.x
        }
    }
    
    // Implementation for specific type
    impl Point<f32> {
        fn distance_from_origin(&self) -> f32 {
            (self.x.powi(2) + self.y.powi(2)).sqrt()
        }
    }
    
    let p = Point { x: 5, y: 10 };
    println!("p.x = {}", p.x());
    
    let p2 = Point { x: 1.0_f32, y: 4.0_f32 };
    println!("Distance: {}", p2.distance_from_origin());
    
    // Generic methods with different type parameters
    struct Point2<T, U> {
        x: T,
        y: U,
    }
    
    impl<T, U> Point2<T, U> {
        fn mixup<V, W>(self, other: Point2<V, W>) -> Point2<T, W> {
            Point2 {
                x: self.x,
                y: other.y,
            }
        }
    }
    
    let p1 = Point2 { x: 5, y: 10.4 };
    let p2 = Point2 { x: "Hello", y: 'c' };
    
    let p3 = p1.mixup(p2);
    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
    
    // Generic with trait bounds
    use std::fmt::Display;
    
    struct Pair<T> {
        first: T,
        second: T,
    }
    
    impl<T> Pair<T> {
        fn new(first: T, second: T) -> Self {
            Self { first, second }
        }
    }
    
    // Method only available when T implements Display + PartialOrd
    impl<T: Display + PartialOrd> Pair<T> {
        fn cmp_display(&self) {
            if self.first >= self.second {
                println!("The largest member is first = {}", self.first);
            } else {
                println!("The largest member is second = {}", self.second);
            }
        }
    }
    
    let pair = Pair::new(10, 20);
    pair.cmp_display();
}

// impl<T> for generic implementations
// impl Type<ConcreteType> for specific type implementations
// Methods can have their own generic parameters
