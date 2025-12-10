fn main() {
    // Ownership Rule 1: Each value has a single owner
    let s1 = String::from("hello");
    // s1 is the owner of the String "hello"
    
    println!("s1: {}", s1);
    
    // Ownership Rule 2: When owner goes out of scope, value is dropped
    {
        let s2 = String::from("world");
        println!("s2: {}", s2);
    } // s2 goes out of scope here and is dropped
    
    // println!("{}", s2); // Error: s2 is no longer valid
    
    // Ownership Rule 3: There can only be one owner at a time
    let s3 = String::from("Rust");
    let s4 = s3;  // Ownership moves from s3 to s4
    
    println!("s4: {}", s4);
    // println!("s3: {}", s3); // Error: s3 is no longer valid
    
    // Move semantics
    let x = String::from("move");
    let y = x;  // x is moved to y
    // x is no longer valid
    println!("y: {}", y);
    
    // Ownership and functions
    let s = String::from("function");
    takes_ownership(s);  // s is moved into the function
    // println!("{}", s); // Error: s is no longer valid
    
    let n = 5;
    makes_copy(n);  // n is copied (integers implement Copy)
    println!("n is still valid: {}", n);  // n is still valid!
}

fn takes_ownership(some_string: String) {
    println!("Function received: {}", some_string);
} // some_string goes out of scope and is dropped

fn makes_copy(some_integer: i32) {
    println!("Function received: {}", some_integer);
} // some_integer goes out of scope, but nothing special happens
