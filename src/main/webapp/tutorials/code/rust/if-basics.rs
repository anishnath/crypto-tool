fn main() {
    // Basic if statement
    let number = 5;
    
    if number < 10 {
        println!("Number is less than 10");
    }
    
    // if-else
    let temperature = 25;
    
    if temperature > 30 {
        println!("It's hot outside!");
    } else {
        println!("It's comfortable outside.");
    }
    
    // if-else if-else
    let score = 85;
    
    if score >= 90 {
        println!("Grade: A");
    } else if score >= 80 {
        println!("Grade: B");
    } else if score >= 70 {
        println!("Grade: C");
    } else if score >= 60 {
        println!("Grade: D");
    } else {
        println!("Grade: F");
    }
    
    // Multiple conditions with logical operators
    let age = 25;
    let has_license = true;
    
    if age >= 18 && has_license {
        println!("You can drive!");
    } else {
        println!("You cannot drive.");
    }
    
    // Using || (OR)
    let is_weekend = true;
    let is_holiday = false;
    
    if is_weekend || is_holiday {
        println!("Time to relax!");
    } else {
        println!("Time to work!");
    }
    
    // Negation with !
    let is_raining = false;
    
    if !is_raining {
        println!("Let's go outside!");
    }
}
