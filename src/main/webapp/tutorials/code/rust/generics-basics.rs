fn main() {
    // Generic function
    fn largest<T: PartialOrd>(list: &[T]) -> &T {
        let mut largest = &list[0];
        
        for item in list {
            if item > largest {
                largest = item;
            }
        }
        
        largest
    }
    
    let number_list = vec![34, 50, 25, 100, 65];
    let result = largest(&number_list);
    println!("The largest number is {}", result);
    
    let char_list = vec!['y', 'm', 'a', 'q'];
    let result = largest(&char_list);
    println!("The largest char is {}", result);
    
    // Generic struct
    struct Point<T> {
        x: T,
        y: T,
    }
    
    let integer_point = Point { x: 5, y: 10 };
    let float_point = Point { x: 1.0, y: 4.0 };
    
    // Multiple type parameters
    struct Point2<T, U> {
        x: T,
        y: U,
    }
    
    let mixed_point = Point2 { x: 5, y: 4.0 };
    println!("Point: ({}, {})", mixed_point.x, mixed_point.y);
    
    // Generic enum
    enum Option<T> {
        Some(T),
        None,
    }
    
    enum Result<T, E> {
        Ok(T),
        Err(E),
    }
    
    let some_number = Option::Some(5);
    let some_string = Option::Some("a string");
    
    let success: Result<i32, &str> = Result::Ok(200);
    let failure: Result<i32, &str> = Result::Err("error");
}

// Generics allow code to work with multiple types
// Type parameters are specified in angle brackets <T>
// Compiler generates specific code for each concrete type used
