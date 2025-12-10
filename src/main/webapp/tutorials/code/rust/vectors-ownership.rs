fn main() {
    // Ownership and borrowing with vectors
    let mut v = vec![1, 2, 3, 4, 5];
    
    // Immutable borrow
    let first = &v[0];
    println!("First element: {}", first);
    
    // Can't modify while borrowed
    // v.push(6);  // Error! Can't borrow as mutable
    
    // first is no longer used, so we can modify
    v.push(6);
    println!("After push: {:?}", v);
    
    // Why can't we have immutable and mutable borrows?
    // Because push might reallocate the vector!
    let mut v2 = vec![1, 2, 3];
    
    // This would be dangerous:
    // let first = &v2[0];
    // v2.push(4);  // Might reallocate!
    // println!("{}", first);  // first might point to freed memory!
    
    // Vector methods
    let mut numbers = vec![1, 2, 3, 4, 5];
    
    // pop - remove and return last element
    if let Some(last) = numbers.pop() {
        println!("Popped: {}", last);
    }
    println!("After pop: {:?}", numbers);
    
    // insert - insert at index
    numbers.insert(2, 99);
    println!("After insert: {:?}", numbers);
    
    // remove - remove at index
    let removed = numbers.remove(2);
    println!("Removed: {}", removed);
    println!("After remove: {:?}", numbers);
    
    // len and is_empty
    println!("Length: {}", numbers.len());
    println!("Is empty: {}", numbers.is_empty());
    
    // clear - remove all elements
    numbers.clear();
    println!("After clear: {:?}", numbers);
    println!("Is empty: {}", numbers.is_empty());
    
    // Capacity vs length
    let mut v3 = Vec::with_capacity(10);
    println!("Capacity: {}, Length: {}", v3.capacity(), v3.len());
    
    v3.push(1);
    v3.push(2);
    println!("Capacity: {}, Length: {}", v3.capacity(), v3.len());
}

// Key points:
// - Vectors own their data
// - Can't modify while borrowed
// - push might reallocate
// - Use get() for safe access
