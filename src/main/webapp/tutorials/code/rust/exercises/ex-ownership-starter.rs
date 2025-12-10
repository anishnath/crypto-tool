// Exercise: Ownership Practice
// Fix the ownership errors

fn main() {
    // TODO: Fix this - s1 is moved to s2
    let s1 = String::from("hello");
    let s2 = s1;
    println!("s1: {}, s2: {}", s1, s2);  // Error!
    
    // TODO: Fix this function call
    let s3 = String::from("world");
    print_string(s3);
    println!("s3: {}", s3);  // Error: s3 was moved
    
    // TODO: Make this work without clone
    let s4 = String::from("Rust");
    let len = calculate_length_broken(s4);
    println!("Length of '{}' is {}", s4, len);  // Error: s4 was moved
    
    // TODO: Fix the return value
    let s5 = String::from("programming");
    let s6 = append_exclamation(s5);
    // We want both s5 and s6 to be valid
    
    // TODO: Make this copy instead of move
    let x = String::from("copy");
    let y = x;
    println!("x: {}, y: {}", x, y);  // Error!
    
    // TODO: Fix this to avoid moving in loop
    let words = vec![
        String::from("hello"),
        String::from("world"),
    ];
    
    for word in words {
        println!("{}", word);
    }
    
    println!("Words: {:?}", words);  // Error: words was moved
}

fn print_string(s: String) {
    println!("{}", s);
}

fn calculate_length_broken(s: String) -> usize {
    s.len()
    // s is dropped here
}

fn append_exclamation(s: String) -> String {
    let mut result = s;
    result.push('!');
    result
}

// Hints:
// 1. Use .clone() for deep copy
// 2. Return ownership from functions
// 3. Use references (we'll learn this next!)
// 4. Return tuples to return multiple values
// 5. For Copy types, use simple assignment
// 6. Use .iter() instead of consuming the vector
