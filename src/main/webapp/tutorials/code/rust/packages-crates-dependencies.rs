// Working with Dependencies

// Cargo.toml example:
/*
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0"
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }
*/

fn main() {
    // After adding dependencies to Cargo.toml, run:
    // cargo build
    
    // This will download and compile dependencies
    
    // Using dependencies:
    // use serde_json;
    // use tokio;
    
    println!("Dependencies are managed by Cargo");
}

// Common dependency sources:
// - crates.io (default)
// - Git repositories
// - Local paths
// - Workspace dependencies

// Dependency features:
// - Version specification: "1.0", "^1.0", "~1.0", "1.0.0"
// - Feature flags: { version = "1.0", features = ["async"] }
// - Optional dependencies: optional = true
// - Development dependencies: [dev-dependencies]

