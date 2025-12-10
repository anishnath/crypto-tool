// Exercise: Pattern Matching
// Fix and complete the match expressions

fn main() {
    // TODO: Fix this match - it's missing the catch-all pattern
    let number = 10;
    match number {
        1 => println!("One"),
        2 => println!("Two"),
        3 => println!("Three"),
        // Add catch-all pattern here
    }
    
    // TODO: Use match to categorize the grade
    let score = 85;
    let grade = "?";  // Fix: use match expression
    // 90-100: A, 80-89: B, 70-79: C, 60-69: D, below 60: F
    println!("Grade: {}", grade);
    
    // TODO: Match on a tuple to determine quadrant
    let point = (3, -5);
    // Fix: use match to determine quadrant
    // (+, +) = Quadrant I, (-, +) = Quadrant II, etc.
    
    // TODO: Match with Option
    let maybe_number: Option<i32> = Some(42);
    // Extract the value if Some, or use 0 if None
    let value = 0;  // Fix: use match
    println!("Value: {}", value);
    
    // TODO: Use match guards to categorize temperature
    let temp = 25;
    // Below 0: Freezing, 0-15: Cold, 16-25: Comfortable, Above 25: Hot
    
    // TODO: Destructure this tuple and print only first and last
    let data = (10, 20, 30, 40, 50);
    // Use match with .. to ignore middle values
    
    // TODO: Use @ binding to capture and print the age category
    let age = 17;
    // 0-12: child, 13-19: teen, 20-64: adult, 65+: senior
    
    // TODO: Match multiple patterns
    let day = 6;
    // 1-5: Weekday, 6-7: Weekend
    
    // TODO: Create a simple calculator using match
    let operation = '+';
    let a = 10;
    let b = 5;
    // Match on operation: +, -, *, /
    // Print the result
}

// Hints:
// 1. Use _ for catch-all pattern
// 2. Ranges: 1..=10 (inclusive)
// 3. Multiple patterns: 1 | 2 | 3
// 4. Match guards: n if n > 0
// 5. @ binding: n @ 0..=12
// 6. Ignore with ..: (first, .., last)
// 7. Option: Some(value) or None
// 8. Tuples: (x, y) => ...
