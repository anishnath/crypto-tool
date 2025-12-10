fn main() {
    // Closures with iterators - functional programming style
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
    
    // filter_map - filter and transform in one step
    let results: Vec<i32> = numbers.iter()
        .filter_map(|x| {
            if x % 2 == 0 {
                Some(x * 2)
            } else {
                None
            }
        })
        .collect();
    println!("Even doubled: {:?}", results);
    
    // fold - reduce to single value
    let sum = numbers.iter()
        .fold(0, |acc, x| acc + x);
    println!("Sum: {}", sum);
    
    // Chain multiple operations
    let result: Vec<i32> = numbers.iter()
        .filter(|x| *x % 2 == 0)
        .map(|x| x * x)
        .filter(|x| *x > 10)
        .collect();
    println!("Even squares > 10: {:?}", result);
    
    // find - get first matching element
    let first_even = numbers.iter()
        .find(|x| *x % 2 == 0);
    println!("First even: {:?}", first_even);
    
    // any and all
    let has_even = numbers.iter().any(|x| x % 2 == 0);
    let all_positive = numbers.iter().all(|x| *x > 0);
    println!("Has even: {}, All positive: {}", has_even, all_positive);
    
    // Custom iterator methods
    struct Counter {
        count: u32,
    }
    
    impl Counter {
        fn new() -> Counter {
            Counter { count: 0 }
        }
    }
    
    impl Iterator for Counter {
        type Item = u32;
        
        fn next(&mut self) -> Option<Self::Item> {
            if self.count < 5 {
                self.count += 1;
                Some(self.count)
            } else {
                None
            }
        }
    }
    
    let sum: u32 = Counter::new()
        .map(|x| x * x)
        .sum();
    println!("Sum of squares 1-5: {}", sum);
    
    // Returning closures
    fn make_adder(x: i32) -> impl Fn(i32) -> i32 {
        move |y| x + y
    }
    
    let add_5 = make_adder(5);
    println!("10 + 5 = {}", add_5(10));
}

// Closures enable functional programming patterns
// Lazy evaluation with iterators
// Chain operations for readable, efficient code
// Can return closures using impl Fn
