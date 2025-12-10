fn main() {
    // Combining generics with traits
    use std::fmt::Display;
    
    // Generic function with trait bound
    fn print_and_return<T: Display>(value: T) -> T {
        println!("Value: {}", value);
        value
    }
    
    let num = print_and_return(42);
    let text = print_and_return("Hello");
    
    // Multiple trait bounds
    fn compare_and_display<T: Display + PartialOrd>(a: T, b: T) {
        if a > b {
            println!("{} is greater than {}", a, b);
        } else {
            println!("{} is less than or equal to {}", a, b);
        }
    }
    
    compare_and_display(10, 20);
    compare_and_display("apple", "banana");
    
    // where clause for complex bounds
    fn some_function<T, U>(t: T, u: U) -> String
    where
        T: Display + Clone,
        U: Clone + std::fmt::Debug,
    {
        format!("t: {}, u: {:?}", t, u.clone())
    }
    
    let result = some_function(42, vec![1, 2, 3]);
    println!("{}", result);
    
    // Blanket implementations
    // This is how standard library implements ToString for any type that implements Display
    trait MyToString {
        fn my_to_string(&self) -> String;
    }
    
    // Blanket implementation: implement MyToString for all types that implement Display
    impl<T: Display> MyToString for T {
        fn my_to_string(&self) -> String {
            format!("{}", self)
        }
    }
    
    let num = 42;
    let text = "hello";
    println!("{}", num.my_to_string());
    println!("{}", text.my_to_string());
    
    // Returning generic types
    fn get_default<T: Default>() -> T {
        T::default()
    }
    
    let num: i32 = get_default();
    let text: String = get_default();
    let vec: Vec<i32> = get_default();
    
    println!("Default i32: {}", num);
    println!("Default String: '{}'", text);
    println!("Default Vec: {:?}", vec);
}

// Generics + traits enable powerful abstractions
// where clauses improve readability
// Blanket implementations apply traits to many types at once
// Zero-cost abstraction: no runtime overhead
