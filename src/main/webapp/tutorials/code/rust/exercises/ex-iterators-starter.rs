// Exercise: Iterators Practice

fn main() {
    // TODO: Use iterators to find the sum of squares of even numbers
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // let sum: i32 = numbers.iter()
    //     .filter(|x| { ... })
    //     .map(|x| { ... })
    //     .sum();
    // println!("Sum of squares of evens: {}", sum);
    
    // TODO: Create a custom iterator that yields powers of 2
    // struct PowersOfTwo {
    //     current: u32,
    //     max_power: u32,
    // }
    
    // impl Iterator for PowersOfTwo {
    //     type Item = u32;
    //     
    //     fn next(&mut self) -> Option<Self::Item> {
    //         // Your code here
    //     }
    // }
    
    // Test PowersOfTwo
    // let powers: Vec<u32> = PowersOfTwo { current: 0, max_power: 8 }
    //     .collect();
    // println!("Powers of 2: {:?}", powers);
    
    // TODO: Use zip to combine names and scores, then filter high scorers
    let names = vec!["Alice", "Bob", "Charlie", "Diana"];
    let scores = vec![85, 92, 78, 95];
    
    // let high_scorers: Vec<_> = names.iter()
    //     .zip(scores.iter())
    //     .filter(|(_, score)| { ... })
    //     .collect();
    // println!("High scorers (>= 90): {:?}", high_scorers);
    
    // TODO: Flatten a nested vector using flat_map
    let nested = vec![vec![1, 2], vec![3, 4], vec![5, 6]];
    // let flattened: Vec<i32> = nested.iter()
    //     .flat_map(|v| { ... })
    //     .collect();
    // println!("Flattened: {:?}", flattened);
    
    // TODO: Create an iterator that generates the first n prime numbers
    // struct Primes {
    //     current: u32,
    //     count: usize,
    //     max_count: usize,
    // }
    
    // impl Iterator for Primes {
    //     type Item = u32;
    //     
    //     fn next(&mut self) -> Option<Self::Item> {
    //         // Your code here - find next prime
    //     }
    // }
    
    // Test Primes
    // let primes: Vec<u32> = Primes { current: 2, count: 0, max_count: 10 }
    //     .collect();
    // println!("First 10 primes: {:?}", primes);
}

// Hints:
// 1. Use filter to keep even numbers: *x % 2 == 0
// 2. Use map to square: x * x
// 3. Powers of 2: 2^n where n is current
// 4. zip combines two iterators element by element
// 5. flat_map flattens nested structures
// 6. For primes: check if number is divisible by any smaller number
