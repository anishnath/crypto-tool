fn main() {
    // Shadowing allows reusing variable names
    let x = 5;
    println!("x = {}", x);
    
    let x = x + 1;  // Shadow with new value
    println!("x = {}", x);
    
    {
        let x = x * 2;  // Shadow in inner scope
        println!("Inner scope x = {}", x);
    }
    
    println!("Outer scope x = {}", x);
    
    // Shadowing can change type
    let spaces = "   ";
    let spaces = spaces.len();  // Now it's a number!
    println!("Number of spaces: {}", spaces);
}
