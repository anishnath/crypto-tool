// Exercise: Packages & Crates Practice

fn main() {
    // TODO: Exercise 1 - Create a Cargo.toml
    // Write a Cargo.toml file for a project that:
    // - Name: "calculator"
    // - Version: "0.1.0"
    // - Edition: "2021"
    // - Has dependency on "serde" version "1.0"
    // - Has dependency on "serde_json" version "1.0"
    
    // Your Cargo.toml here (as a comment):
    /*
    [package]
    name = "calculator"
    version = "0.1.0"
    edition = "2021"
    
    [dependencies]
    serde = "1.0"
    serde_json = "1.0"
    */
    
    // TODO: Exercise 2 - Understanding Crate Types
    // Explain the difference between:
    // - Binary crate
    // - Library crate
    // - Package
    
    // TODO: Exercise 3 - Dependency Management
    // List three ways to specify dependencies in Cargo.toml:
    // 1. From crates.io
    // 2. From Git repository
    // 3. From local path
    
    println!("Packages and Crates exercise");
}

// Hints:
// 1. Binary crate has main() function
// 2. Library crate is in src/lib.rs
// 3. Package contains Cargo.toml
// 4. Dependencies can come from crates.io, git, or local paths

