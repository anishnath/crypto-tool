fn main() {
    // Loop labels - for nested loops
    // Labels start with a single quote '
    
    let mut count = 0;
    
    'outer: loop {
        println!("Outer loop iteration");
        let mut inner_count = 0;
        
        'inner: loop {
            inner_count += 1;
            count += 1;
            
            println!("  Inner loop: {}", inner_count);
            
            if inner_count == 3 {
                println!("  Breaking inner loop");
                break 'inner;  // Break only the inner loop
            }
            
            if count == 10 {
                println!("  Breaking outer loop from inner!");
                break 'outer;  // Break the outer loop
            }
        }
        
        if count >= 6 {
            println!("Breaking outer loop normally");
            break 'outer;
        }
    }
    println!("Total count: {}\n", count);
    
    // Practical example: Finding in 2D array
    let matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ];
    let target = 5;
    let mut found = false;
    
    'search: for (row_idx, row) in matrix.iter().enumerate() {
        for (col_idx, &value) in row.iter().enumerate() {
            if value == target {
                println!("Found {} at position ({}, {})", target, row_idx, col_idx);
                found = true;
                break 'search;  // Exit both loops
            }
        }
    }
    
    if !found {
        println!("{} not found in matrix", target);
    }
    println!();
    
    // Returning values from labeled loops
    let result = 'counting: loop {
        let mut inner_result = 0;
        
        loop {
            inner_result += 1;
            
            if inner_result == 5 {
                break 'counting inner_result * 10;  // Return from outer loop
            }
        }
    };
    println!("Result from labeled loop: {}", result);
}
