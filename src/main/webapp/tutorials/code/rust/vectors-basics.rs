fn main() {
    // Creating vectors
    let mut v1: Vec<i32> = Vec::new();
    
    // Using vec! macro
    let v2 = vec![1, 2, 3, 4, 5];
    
    // Adding elements
    v1.push(1);
    v1.push(2);
    v1.push(3);
    
    println!("v1: {:?}", v1);
    println!("v2: {:?}", v2);
    
    // Reading elements
    let third = &v2[2];
    println!("Third element: {}", third);
    
    // Safe access with get
    match v2.get(2) {
        Some(third) => println!("Third element: {}", third),
        None => println!("No third element"),
    }
    
    // Out of bounds - panics!
    // let does_not_exist = &v2[100];
    
    // Out of bounds - returns None
    match v2.get(100) {
        Some(val) => println!("Value: {}", val),
        None => println!("Index out of bounds"),
    }
    
    // Iterating
    println!("\nIterating over v2:");
    for i in &v2 {
        println!("{}", i);
    }
    
    // Mutable iteration
    let mut v3 = vec![1, 2, 3];
    for i in &mut v3 {
        *i += 50;
    }
    println!("After adding 50: {:?}", v3);
    
    // Vector with enum for multiple types
    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }
    
    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];
    
    println!("\nSpreadsheet row has {} cells", row.len());
}

// Vectors are stored on the heap
// They can grow and shrink dynamically
// All elements must be the same type
