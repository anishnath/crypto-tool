fn main() {
    // break - exit the loop immediately
    let mut count = 0;
    
    loop {
        count += 1;
        
        if count == 5 {
            println!("Breaking at count = {}", count);
            break;
        }
        
        println!("Count: {}", count);
    }
    println!();
    
    // continue - skip to next iteration
    println!("Printing only even numbers:");
    for i in 1..=10 {
        if i % 2 != 0 {
            continue;  // Skip odd numbers
        }
        println!("{}", i);
    }
    println!();
    
    // break with value
    let result = loop {
        count += 1;
        
        if count == 10 {
            break count * 2;  // Return 20
        }
    };
    println!("Result: {}\n", result);
    
    // Using break and continue together
    println!("Numbers 1-20, skipping multiples of 3:");
    for num in 1..=20 {
        if num % 3 == 0 {
            continue;  // Skip multiples of 3
        }
        
        if num > 15 {
            break;  // Stop at 15
        }
        
        print!("{} ", num);
    }
    println!("\n");
    
    // Searching with break
    let numbers = [1, 5, 10, 15, 20, 25];
    let target = 15;
    let mut found = false;
    
    for (index, &num) in numbers.iter().enumerate() {
        if num == target {
            println!("Found {} at index {}", target, index);
            found = true;
            break;
        }
    }
    
    if !found {
        println!("{} not found", target);
    }
}
