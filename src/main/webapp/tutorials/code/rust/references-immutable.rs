fn main() {
    // Immutable references (&T)
    let s1 = String::from("hello");
    
    // Create a reference to s1
    let len = calculate_length(&s1);
    
    println!("The length of '{}' is {}", s1, len);
    // s1 is still valid! We only borrowed it
    
    // Multiple immutable references are allowed
    let s2 = String::from("world");
    let r1 = &s2;
    let r2 = &s2;
    let r3 = &s2;
    
    println!("{}, {}, {}", r1, r2, r3);  // All valid!
    
    // References don't take ownership
    let s3 = String::from("Rust");
    print_length(&s3);
    print_length(&s3);  // Can use s3 multiple times
    println!("s3 is still valid: {}", s3);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}  // s goes out of scope, but it doesn't own the data, so nothing happens

fn print_length(s: &String) {
    println!("Length: {}", s.len());
}
