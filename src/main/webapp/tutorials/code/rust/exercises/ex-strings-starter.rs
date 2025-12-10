// Exercise: String Manipulation
// Fix the code to make it compile and run correctly

fn main() {
    // TODO: Create a mutable String with value "Rust"
    let language = "Rust";
    
    // TODO: Add " is awesome!" to the string
    language.push_str(" is awesome!");
    println!("{}", language);
    
    // TODO: Create two strings and concatenate them without moving
    let first = String::from("Hello");
    let second = String::from("World");
    let combined = first + " " + second;
    println!("{}", combined);
    println!("First: {}, Second: {}", first, second);
    
    // TODO: Extract the first word from this sentence
    let sentence = "Rust programming language";
    let first_word = sentence; // Should be "Rust"
    println!("First word: {}", first_word);
    
    // TODO: Count the number of characters (not bytes) in this string
    let emoji_text = "Hello 👋 World 🌍";
    let char_count = emoji_text.len(); // This counts bytes, not characters!
    println!("Character count: {}", char_count);
    
    // TODO: Convert this string to uppercase
    let message = "rust is great";
    println!("Uppercase: {}", message);
}

// Hints:
// 1. Use String::from() or .to_string() to create a String
// 2. Use format!() macro to concatenate without moving
// 3. Use string slicing &str[start..end]
// 4. Use .chars().count() for character count
// 5. Use .to_uppercase() method
