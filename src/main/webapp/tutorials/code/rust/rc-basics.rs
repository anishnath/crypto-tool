use std::rc::Rc;

fn main() {
    // Rc allows multiple ownership
    let a = Rc::new(String::from("Hello, Rust!"));
    println!("Count after creating a: {}", Rc::strong_count(&a));

    // Clone creates a new reference, not a deep copy
    let b = Rc::clone(&a);
    println!("Count after creating b: {}", Rc::strong_count(&a));

    {
        let c = Rc::clone(&a);
        println!("Count after creating c: {}", Rc::strong_count(&a));
        println!("c = {}", c);
    }

    // c is dropped, count decreases
    println!("Count after c goes out of scope: {}", Rc::strong_count(&a));

    println!("a = {}", a);
    println!("b = {}", b);
}
