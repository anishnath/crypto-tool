fn main() {
    // Three ways closures capture variables:
    
    // 1. Fn - Borrows immutably
    let list = vec![1, 2, 3];
    let only_borrows = || println!("List: {:?}", list);
    
    only_borrows();
    println!("Can still use list: {:?}", list);  // list is still valid
    
    // 2. FnMut - Borrows mutably
    let mut list2 = vec![1, 2, 3];
    let mut borrows_mutably = || list2.push(4);
    
    borrows_mutably();
    println!("Modified list: {:?}", list2);
    
    // 3. FnOnce - Takes ownership
    let list3 = vec![1, 2, 3];
    let takes_ownership = || {
        println!("Taking ownership: {:?}", list3);
        drop(list3);  // Consumes list3
    };
    
    takes_ownership();
    // println!("{:?}", list3);  // Error: list3 was moved
    
    // move keyword forces ownership
    let x = vec![1, 2, 3];
    let closure = move || println!("Moved: {:?}", x);
    
    closure();
    // println!("{:?}", x);  // Error: x was moved
    
    // Useful with threads
    use std::thread;
    
    let data = vec![1, 2, 3];
    let handle = thread::spawn(move || {
        println!("Thread data: {:?}", data);
    });
    
    handle.join().unwrap();
    
    // Function traits hierarchy
    fn apply_fn<F>(f: F) where F: Fn() {
        f();
    }
    
    fn apply_fn_mut<F>(mut f: F) where F: FnMut() {
        f();
    }
    
    fn apply_fn_once<F>(f: F) where F: FnOnce() {
        f();
    }
    
    let s = String::from("hello");
    apply_fn(|| println!("{}", s));
    apply_fn_mut(|| println!("{}", s));
    apply_fn_once(|| println!("{}", s));
}

// Fn traits:
// - Fn: can be called multiple times, borrows immutably
// - FnMut: can be called multiple times, borrows mutably
// - FnOnce: can be called once, takes ownership
// move keyword forces closure to take ownership
