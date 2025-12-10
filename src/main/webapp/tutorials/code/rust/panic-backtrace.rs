fn main() {
    // Demonstrating panic backtrace
    // Run with: RUST_BACKTRACE=1 cargo run
    
    println!("Calling a()...");
    a();
}

fn a() {
    println!("a() calling b()...");
    b();
}

fn b() {
    println!("b() calling c()...");
    c();
}

fn c() {
    println!("c() panicking...");
    panic!("Something went wrong in c()!");
}

// When you run this with RUST_BACKTRACE=1, you'll see:
// - The panic message
// - The call stack showing a() -> b() -> c() -> panic!
// - Line numbers and file names for debugging

