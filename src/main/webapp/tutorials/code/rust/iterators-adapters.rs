fn main() {
    // Iterator adapters - transform iterators
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    // map - transform each element
    let doubled: Vec<i32> = numbers.iter()
        .map(|x| x * 2)
        .collect();
    println!("Doubled: {:?}", doubled);
    
    // filter - keep elements matching condition
    let evens: Vec<&i32> = numbers.iter()
        .filter(|x| *x % 2 == 0)
        .collect();
    println!("Evens: {:?}", evens);
    
    // take - take first n elements
    let first_three: Vec<&i32> = numbers.iter()
        .take(3)
        .collect();
    println!("First 3: {:?}", first_three);
    
    // skip - skip first n elements
    let skip_three: Vec<&i32> = numbers.iter()
        .skip(3)
        .collect();
    println!("Skip 3: {:?}", skip_three);
    
    // enumerate - add index
    for (i, val) in numbers.iter().enumerate() {
        println!("Index {}: {}", i, val);
    }
    
    // zip - combine two iterators
    let names = vec!["Alice", "Bob", "Charlie"];
    let ages = vec![30, 25, 35];
    
    let people: Vec<_> = names.iter()
        .zip(ages.iter())
        .collect();
    println!("People: {:?}", people);
    
    // chain - concatenate iterators
    let v1 = vec![1, 2, 3];
    let v2 = vec![4, 5, 6];
    
    let chained: Vec<&i32> = v1.iter()
        .chain(v2.iter())
        .collect();
    println!("Chained: {:?}", chained);
    
    // Chaining multiple adapters
    let result: Vec<i32> = numbers.iter()
        .filter(|x| *x % 2 == 0)
        .map(|x| x * x)
        .take(3)
        .copied()
        .collect();
    println!("Even squares (first 3): {:?}", result);
    
    // flat_map - map and flatten
    let words = vec!["hello", "world"];
    let chars: Vec<char> = words.iter()
        .flat_map(|s| s.chars())
        .collect();
    println!("All chars: {:?}", chars);
    
    // rev - reverse iterator
    let reversed: Vec<&i32> = numbers.iter()
        .rev()
        .collect();
    println!("Reversed: {:?}", reversed);
}

// Iterator adapters are lazy - chain them efficiently
// collect() consumes the iterator
// Adapters can be chained for complex transformations
