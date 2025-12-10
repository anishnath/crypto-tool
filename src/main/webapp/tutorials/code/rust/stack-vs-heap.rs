fn main() {
    // Stack vs Heap demonstration
    
    // Stack: Fixed size, known at compile time
    let x = 5;           // Stored on stack
    let y = true;        // Stored on stack
    let z = 'A';         // Stored on stack
    
    println!("Stack values: x={}, y={}, z={}", x, y, z);
    
    // Heap: Dynamic size, allocated at runtime
    let s1 = String::from("hello");  // Data stored on heap
    let s2 = String::from("world");  // Data stored on heap
    
    println!("Heap values: s1={}, s2={}", s1, s2);
    
    // Stack: Copy types (implement Copy trait)
    let a = 10;
    let b = a;  // Value is copied
    println!("Both valid - a: {}, b: {}", a, b);
    
    // Heap: Move types (do NOT implement Copy)
    let str1 = String::from("Rust");
    let str2 = str1;  // Ownership is moved
    // println!("{}", str1); // Error: str1 is no longer valid
    println!("Only str2 valid: {}", str2);
    
    // Clone: Explicit deep copy
    let s3 = String::from("clone");
    let s4 = s3.clone();  // Deep copy on heap
    println!("Both valid - s3: {}, s4: {}", s3, s4);
    
    // Types that implement Copy (stored on stack)
    // - All integers: i32, u32, i64, etc.
    // - Booleans: bool
    // - Floating point: f32, f64
    // - Characters: char
    // - Tuples (if all elements implement Copy)
    
    let tuple1 = (1, 2, 3);
    let tuple2 = tuple1;  // Copied
    println!("Tuple copied - tuple1: {:?}, tuple2: {:?}", tuple1, tuple2);
    
    // This tuple contains String, so it does NOT implement Copy
    let tuple3 = (String::from("a"), 1);
    let tuple4 = tuple3;  // Moved, not copied
    // println!("{:?}", tuple3); // Error: tuple3 is moved
    println!("Tuple moved - tuple4: {:?}", tuple4);
}
