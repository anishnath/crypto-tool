fn main() {
    // Basic iterator usage
    let v = vec![1, 2, 3, 4, 5];
    
    // iter() - borrows elements
    for item in v.iter() {
        println!("{}", item);
    }
    println!("v is still valid: {:?}", v);
    
    // into_iter() - takes ownership
    let v2 = vec![1, 2, 3];
    for item in v2.into_iter() {
        println!("{}", item);
    }
    // println!("{:?}", v2);  // Error: v2 was moved
    
    // iter_mut() - mutable references
    let mut v3 = vec![1, 2, 3];
    for item in v3.iter_mut() {
        *item += 10;
    }
    println!("Modified: {:?}", v3);
    
    // Iterator trait
    let v4 = vec![1, 2, 3];
    let mut iter = v4.iter();
    
    println!("{:?}", iter.next());  // Some(&1)
    println!("{:?}", iter.next());  // Some(&2)
    println!("{:?}", iter.next());  // Some(&3)
    println!("{:?}", iter.next());  // None
    
    // Iterators are lazy
    let v5 = vec![1, 2, 3, 4, 5];
    let iter = v5.iter().map(|x| {
        println!("Processing {}", x);
        x * 2
    });
    // Nothing printed yet - iterator is lazy!
    
    println!("Collecting...");
    let doubled: Vec<i32> = iter.collect();
    println!("Result: {:?}", doubled);
    
    // Common iterator methods
    let numbers = vec![1, 2, 3, 4, 5, 6];
    
    let sum: i32 = numbers.iter().sum();
    println!("Sum: {}", sum);
    
    let product: i32 = numbers.iter().product();
    println!("Product: {}", product);
    
    let max = numbers.iter().max();
    println!("Max: {:?}", max);
    
    let min = numbers.iter().min();
    println!("Min: {:?}", min);
}

// Iterators are lazy - they don't do work until consumed
// Three main iterator methods: iter(), into_iter(), iter_mut()
// Iterator trait has one required method: next()
