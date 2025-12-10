fn main() {
    // Single-line comments start with //
    // This is a comment
    let x = 5; // Comments can be at the end of lines
    
    /* 
     * Multi-line comments use /* */
     * They can span multiple lines
     * Useful for longer explanations
     */
    let y = 10;
    
    /// Documentation comments use three slashes
    /// They support Markdown formatting
    /// Used to document functions, structs, etc.
    
    println!("x = {}, y = {}", x, y);
}

/// Adds two numbers together
/// 
/// # Examples
/// 
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}

//! Module-level documentation
//! This comment documents the containing module
