fn main() {
    // Mutable references (&mut T)
    let mut s = String::from("hello");
    
    // Create a mutable reference
    change(&mut s);
    
    println!("Modified string: {}", s);
    
    // Only ONE mutable reference at a time
    let mut s1 = String::from("world");
    
    let r1 = &mut s1;
    r1.push_str("!");
    println!("r1: {}", r1);
    
    // r1 is no longer used, so we can create another mutable reference
    let r2 = &mut s1;
    r2.push_str("!");
    println!("r2: {}", r2);
    
    // Demonstrating the rule: one mutable ref OR multiple immutable refs
    let mut s2 = String::from("Rust");
    
    {
        let r1 = &mut s2;
        r1.push_str(" is");
    }  // r1 goes out of scope here
    
    // Now we can create another mutable reference
    let r2 = &mut s2;
    r2.push_str(" awesome");
    
    println!("{}", s2);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
