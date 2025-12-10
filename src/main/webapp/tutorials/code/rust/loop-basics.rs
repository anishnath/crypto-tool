fn main() {
    // 1. loop - infinite loop (must use break to exit)
    let mut counter = 0;
    
    loop {
        counter += 1;
        println!("Counter: {}", counter);
        
        if counter == 5 {
            break;  // Exit the loop
        }
    }
    println!("Loop finished!\n");
    
    // 2. Returning values from loop
    let mut count = 0;
    let result = loop {
        count += 1;
        
        if count == 10 {
            break count * 2;  // Return value from loop
        }
    };
    println!("Result from loop: {}\n", result);
    
    // 3. while loop - conditional loop
    let mut number = 3;
    
    while number != 0 {
        println!("{}!", number);
        number -= 1;
    }
    println!("LIFTOFF!\n");
    
    // 4. for loop with range
    for i in 1..6 {  // 1 to 5 (exclusive end)
        println!("for loop: {}", i);
    }
    println!();
    
    // 5. for loop with inclusive range
    for i in 1..=5 {  // 1 to 5 (inclusive end)
        println!("Inclusive range: {}", i);
    }
    println!();
    
    // 6. for loop with array
    let numbers = [10, 20, 30, 40, 50];
    
    for num in numbers {
        println!("Array element: {}", num);
    }
    println!();
    
    // 7. for loop with index
    for (index, value) in numbers.iter().enumerate() {
        println!("Index {}: {}", index, value);
    }
}
