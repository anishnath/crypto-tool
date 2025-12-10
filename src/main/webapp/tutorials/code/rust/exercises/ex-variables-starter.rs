// Exercise: Fix the variable declarations
// TODO: Make the necessary variables mutable
// TODO: Fix the type mismatches
// TODO: Add proper type annotations where needed

fn main() {
    // Fix this: should be able to change the value
    let count = 0;
    count = count + 1;
    println!("Count: {}", count);
    
    // Fix this: type mismatch
    let age: u32 = "25";
    println!("Age: {}", age);
    
    // Fix this: constant needs proper naming
    let max_users = 100;
    println!("Max users: {}", max_users);
    
    // Fix this: shadowing vs mutation
    let mut total = 10;
    let total = total + 5;
    total = total * 2;
    println!("Total: {}", total);
}
