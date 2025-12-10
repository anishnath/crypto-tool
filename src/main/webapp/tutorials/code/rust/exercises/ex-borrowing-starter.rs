// Exercise: References & Borrowing
// Fix the borrowing errors

fn main() {
    // TODO: Fix this - can't modify through immutable reference
    let s = String::from("hello");
    change_string(&s);
    
    // TODO: Fix this - multiple mutable references
    let mut s1 = String::from("world");
    let r1 = &mut s1;
    let r2 = &mut s1;
    println!("{}, {}", r1, r2);
    
    // TODO: Fix this - mutable and immutable references together
    let mut s2 = String::from("Rust");
    let r1 = &s2;
    let r2 = &mut s2;
    println!("{}, {}", r1, r2);
    
    // TODO: Fix this function to use references
    let s3 = String::from("programming");
    let len = calculate_length_broken(s3);
    println!("Length of '{}' is {}", s3, len);
    
    // TODO: Fix this to modify the string
    let mut s4 = String::from("hello");
    append_world(s4);
    println!("{}", s4);
    
    // TODO: Fix the scope issue
    let mut s5 = String::from("test");
    let r1 = &s5;
    let r2 = &mut s5;
    println!("{}", r1);
    println!("{}", r2);
}

fn change_string(s: &String) {
    s.push_str(", world");  // Error: cannot mutate through & reference
}

fn calculate_length_broken(s: String) -> usize {
    s.len()
}

fn append_world(s: String) {
    s.push_str(" world");  // Error: s is not mutable
}

// Hints:
// 1. Use &mut for mutable references
// 2. Only one mutable reference at a time
// 3. Can't have mutable and immutable refs together
// 4. Use references to avoid taking ownership
// 5. Make parameters mutable with &mut
// 6. References are valid until their last use
