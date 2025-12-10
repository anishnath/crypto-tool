// Exercise: Loops Practice
// Fix and complete the code

fn main() {
    // TODO: Fix this infinite loop - make it print 1 to 5 then exit
    let mut i = 0;
    loop {
        i += 1;
        println!("{}", i);
        // Add break condition here
    }
    
    // TODO: Complete this while loop to count down from 10 to 1
    let mut countdown = 10;
    while countdown {  // Fix the condition
        println!("{}", countdown);
        // Add decrement here
    }
    
    // TODO: Use a for loop to print numbers 1 to 10
    // Fix the range
    for num in 1 {
        println!("{}", num);
    }
    
    // TODO: Print only even numbers from 1 to 20 using continue
    for num in 1..=20 {
        // Add condition to skip odd numbers
        println!("{}", num);
    }
    
    // TODO: Find the first number divisible by 7 in the range 1-100
    // Use break when found
    for num in 1..=100 {
        // Add logic here
    }
    
    // TODO: Fix this nested loop to find and print all pairs (i, j)
    // where i * j == 12
    for i in 1..=12 {
        for j in 1..=12 {
            // Add condition and print here
        }
    }
    
    // TODO: Use a loop to calculate the sum of numbers 1 to 100
    let mut sum = 0;
    // Add your loop here
    println!("Sum of 1 to 100: {}", sum);
    
    // TODO: Use a labeled loop to break out of nested loops
    // when you find the number 50
    let numbers = [
        [10, 20, 30],
        [40, 50, 60],
        [70, 80, 90],
    ];
    // Add labeled loop here
    
    // TODO: Return a value from a loop
    // Calculate factorial of 5 using a loop
    let factorial = 0;  // Fix: use loop to calculate
    println!("Factorial of 5: {}", factorial);
}

// Hints:
// 1. Use 'break' to exit loops
// 2. Use 'continue' to skip to next iteration
// 3. while condition must be boolean
// 4. for loops use ranges: 1..10 or 1..=10
// 5. Loop labels: 'label: loop { break 'label; }
// 6. Return from loop: break value;
