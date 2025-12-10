fn main() {
    // Borrowing rules demonstration
    
    // Rule 1: Multiple immutable references are OK
    let s = String::from("hello");
    let r1 = &s;
    let r2 = &s;
    let r3 = &s;
    println!("{}, {}, {}", r1, r2, r3);
    
    // Rule 2: Cannot have mutable reference while immutable references exist
    let mut s1 = String::from("world");
    let r1 = &s1;
    let r2 = &s1;
    // let r3 = &mut s1;  // Error! Cannot borrow as mutable
    println!("{}, {}", r1, r2);
    
    // After immutable references are done, mutable is OK
    let r3 = &mut s1;
    r3.push_str("!");
    println!("{}", r3);
    
    // Rule 3: Only ONE mutable reference at a time
    let mut s2 = String::from("Rust");
    let r1 = &mut s2;
    // let r2 = &mut s2;  // Error! Cannot have two mutable references
    r1.push_str("!");
    println!("{}", r1);
    
    // Scope matters - references are valid until last use
    let mut s3 = String::from("programming");
    
    let r1 = &s3;
    let r2 = &s3;
    println!("{} and {}", r1, r2);
    // r1 and r2 are no longer used after this point
    
    let r3 = &mut s3;  // OK! No immutable refs are active
    r3.push_str("!");
    println!("{}", r3);
}

// Dangling references are prevented at compile time
// fn dangle() -> &String {  // Error! Missing lifetime specifier
//     let s = String::from("hello");
//     &s  // Error! s will be dropped, creating a dangling reference
// }

// Correct version - return the String itself
fn no_dangle() -> String {
    let s = String::from("hello");
    s  // Ownership is moved out
}
