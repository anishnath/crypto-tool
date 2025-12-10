fn main() {
    // Returning ownership from functions
    let s1 = gives_ownership();
    println!("s1: {}", s1);
    
    let s2 = String::from("hello");
    let s3 = takes_and_gives_back(s2);
    // println!("{}", s2); // Error: s2 was moved
    println!("s3: {}", s3);
    
    // Returning multiple values with tuples
    let s4 = String::from("world");
    let (s5, len) = calculate_length(s4);
    println!("The length of '{}' is {}", s5, len);
    
    // Pattern: Take ownership and return it
    let mut text = String::from("Rust");
    text = add_exclamation(text);
    println!("Modified: {}", text);
}

fn gives_ownership() -> String {
    let some_string = String::from("yours");
    some_string  // Ownership is moved to caller
}

fn takes_and_gives_back(a_string: String) -> String {
    a_string  // Ownership is moved back to caller
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len();
    (s, length)  // Return both the String and its length
}

fn add_exclamation(mut s: String) -> String {
    s.push_str("!");
    s  // Return the modified String
}
