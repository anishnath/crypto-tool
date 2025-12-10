// Packages and Crates in Rust

// A crate is the smallest amount of code that the Rust compiler considers at a time
// A package is one or more crates that provide a set of functionality

// Binary crate - has a main function
// This file itself is a binary crate

fn main() {
    println!("This is a binary crate");
    
    // Using external crates
    // In Cargo.toml, you would add:
    // [dependencies]
    // rand = "0.8"
    
    // Then you can use it:
    // use rand::Rng;
    // let number = rand::thread_rng().gen_range(1..=100);
}

// Library crate - doesn't have a main function
// lib.rs is a library crate

// Key points:
// - Crate: compilation unit (binary or library)
// - Package: one or more crates with Cargo.toml
// - Binary crate: has main(), produces executable
// - Library crate: no main(), provides functionality
// - Cargo.toml: defines package metadata and dependencies

