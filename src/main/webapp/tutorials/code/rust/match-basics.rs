fn main() {
    // Basic match expression
    let number = 3;
    
    match number {
        1 => println!("One!"),
        2 => println!("Two!"),
        3 => println!("Three!"),
        4 => println!("Four!"),
        5 => println!("Five!"),
        _ => println!("Something else"),  // _ is the catch-all pattern
    }
    
    // match is an expression - it returns a value
    let number = 2;
    let description = match number {
        1 => "one",
        2 => "two",
        3 => "three",
        _ => "other",
    };
    println!("The number is: {}", description);
    
    // Multiple patterns with |
    let number = 5;
    match number {
        1 | 2 => println!("One or two"),
        3 | 4 | 5 => println!("Three, four, or five"),
        _ => println!("Something else"),
    }
    
    // Matching ranges
    let number = 42;
    match number {
        1..=10 => println!("Between 1 and 10"),
        11..=50 => println!("Between 11 and 50"),
        51..=100 => println!("Between 51 and 100"),
        _ => println!("Outside range"),
    }
    
    // Matching with code blocks
    let number = 7;
    match number {
        1 => {
            println!("It's one!");
            println!("The first number!");
        }
        2..=10 => {
            println!("It's between 2 and 10");
            println!("The number is: {}", number);
        }
        _ => println!("Something else"),
    }
    
    // Matching boolean values
    let is_active = true;
    match is_active {
        true => println!("Active"),
        false => println!("Inactive"),
    }
    
    // Matching characters
    let letter = 'x';
    match letter {
        'a' | 'e' | 'i' | 'o' | 'u' => println!("Vowel"),
        'y' => println!("Sometimes a vowel"),
        _ => println!("Consonant"),
    }
}
