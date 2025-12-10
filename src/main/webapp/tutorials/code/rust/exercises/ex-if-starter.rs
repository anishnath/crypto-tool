// Exercise: if Expressions
// Fix the code to make it compile and run correctly

fn main() {
    // TODO: Fix this if statement to check if number is positive
    let number = 42;
    if number {  // Fix this condition
        println!("Number is positive");
    }
    
    // TODO: Complete the if-else to categorize the age
    let age = 25;
    if age >= 65 {
        println!("Senior");
    }
    // Add else if for adult (18-64)
    // Add else for minor (under 18)
    
    // TODO: Use if as an expression to assign a value
    let score = 85;
    let grade;  // Fix: use if expression to assign grade
    if score >= 90 {
        grade = "A";
    } else {
        grade = "B";
    }
    println!("Grade: {}", grade);
    
    // TODO: Fix the type mismatch error
    let is_even = true;
    let result = if is_even {
        2
    } else {
        "odd"  // Error: type mismatch!
    };
    println!("Result: {}", result);
    
    // TODO: Write an if expression that returns the absolute value
    let num = -15;
    let absolute = 0;  // Fix: use if expression
    println!("Absolute value of {}: {}", num, absolute);
    
    // TODO: Check multiple conditions
    let temperature = 25;
    let is_sunny = true;
    // Write an if statement: if temp > 20 AND sunny, print "Perfect day!"
    
    // TODO: Use if expression to find the maximum of three numbers
    let a = 10;
    let b = 25;
    let c = 15;
    let max = 0;  // Fix: use nested if expressions
    println!("Max of {}, {}, {}: {}", a, b, c, max);
}

// Hints:
// 1. Conditions must be boolean (true/false)
// 2. Use comparison operators: >, <, >=, <=, ==, !=
// 3. Use logical operators: && (AND), || (OR), ! (NOT)
// 4. if expressions must return the same type in all branches
// 5. Use if-else if-else for multiple conditions
// 6. For absolute value: if num < 0 { -num } else { num }
