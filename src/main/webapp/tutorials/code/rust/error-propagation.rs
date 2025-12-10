use std::fs::File;
use std::io;
use std::io::Read;

// The ? operator for error propagation
fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}

// Equivalent code without ? operator
fn read_username_from_file_verbose() -> Result<String, io::Error> {
    let mut f = match File::open("hello.txt") {
        Ok(file) => file,
        Err(e) => return Err(e),
    };
    
    let mut s = String::new();
    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}

// Using ? with different error types
fn parse_and_read() -> Result<i32, Box<dyn std::error::Error>> {
    let mut s = String::new();
    File::open("number.txt")?
        .read_to_string(&mut s)?;
    let num: i32 = s.trim().parse()?;
    Ok(num)
}

// Chaining with ?
fn read_and_process() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("data.txt")?.read_to_string(&mut s)?;
    Ok(s)
}

// Using ? in main
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let username = read_username_from_file()?;
    println!("Username: {}", username);
    Ok(())
}

// Key points:
// - ? operator automatically propagates errors
// - Works with Result<T, E> where E implements From trait
// - Can be used in functions that return Result
// - Much more concise than match expressions
// - Can convert between error types automatically

