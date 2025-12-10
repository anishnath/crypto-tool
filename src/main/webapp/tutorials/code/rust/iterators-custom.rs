fn main() {
    // Creating custom iterators
    
    // Simple counter iterator
    struct Counter {
        count: u32,
        max: u32,
    }
    
    impl Counter {
        fn new(max: u32) -> Counter {
            Counter { count: 0, max }
        }
    }
    
    impl Iterator for Counter {
        type Item = u32;
        
        fn next(&mut self) -> Option<Self::Item> {
            if self.count < self.max {
                self.count += 1;
                Some(self.count)
            } else {
                None
            }
        }
    }
    
    let counter = Counter::new(5);
    for num in counter {
        println!("{}", num);
    }
    
    // Using iterator methods on custom iterator
    let sum: u32 = Counter::new(10).sum();
    println!("Sum 1-10: {}", sum);
    
    let squares: Vec<u32> = Counter::new(5)
        .map(|x| x * x)
        .collect();
    println!("Squares: {:?}", squares);
    
    // Fibonacci iterator
    struct Fibonacci {
        curr: u32,
        next: u32,
    }
    
    impl Fibonacci {
        fn new() -> Fibonacci {
            Fibonacci { curr: 0, next: 1 }
        }
    }
    
    impl Iterator for Fibonacci {
        type Item = u32;
        
        fn next(&mut self) -> Option<Self::Item> {
            let current = self.curr;
            
            self.curr = self.next;
            self.next = current + self.next;
            
            Some(current)
        }
    }
    
    let fib: Vec<u32> = Fibonacci::new()
        .take(10)
        .collect();
    println!("First 10 Fibonacci: {:?}", fib);
    
    // Iterator from range
    let range_sum: i32 = (1..=100).sum();
    println!("Sum 1-100: {}", range_sum);
    
    // Infinite iterators
    let first_even_square: Option<i32> = (1..)
        .map(|x| x * x)
        .filter(|x| x % 2 == 0)
        .take(1)
        .next();
    println!("First even square: {:?}", first_even_square);
    
    // Implementing other Iterator methods
    impl Counter {
        fn new_with_step(max: u32, step: u32) -> CounterWithStep {
            CounterWithStep { count: 0, max, step }
        }
    }
    
    struct CounterWithStep {
        count: u32,
        max: u32,
        step: u32,
    }
    
    impl Iterator for CounterWithStep {
        type Item = u32;
        
        fn next(&mut self) -> Option<Self::Item> {
            if self.count < self.max {
                let current = self.count;
                self.count += self.step;
                Some(current)
            } else {
                None
            }
        }
        
        // Optional: implement size_hint for optimization
        fn size_hint(&self) -> (usize, Option<usize>) {
            let remaining = ((self.max - self.count) / self.step) as usize;
            (remaining, Some(remaining))
        }
    }
    
    let by_twos: Vec<u32> = CounterWithStep { count: 0, max: 10, step: 2 }
        .collect();
    println!("Count by 2s: {:?}", by_twos);
}

// Implement Iterator trait with next() method
// type Item defines what the iterator yields
// Can implement optional methods like size_hint
// Infinite iterators are possible - use take() to limit
