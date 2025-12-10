// Exercise: Closures Practice

fn main() {
    // TODO: Create a closure that squares a number
    // let square = |x| { ... };
    // println!("5 squared: {}", square(5));
    
    // TODO: Create a closure that captures a variable and adds it
    let base = 10;
    // let add_base = |x| { ... };
    // println!("5 + 10 = {}", add_base(5));
    
    // TODO: Use map to convert temperatures from Celsius to Fahrenheit
    // Formula: F = C * 9/5 + 32
    let celsius = vec![0, 10, 20, 30, 40];
    // let fahrenheit: Vec<i32> = celsius.iter()
    //     .map(|c| { ... })
    //     .collect();
    // println!("Fahrenheit: {:?}", fahrenheit);
    
    // TODO: Filter numbers greater than 5 and square them
    let numbers = vec![1, 3, 5, 7, 9, 11];
    // let result: Vec<i32> = numbers.iter()
    //     .filter(|x| { ... })
    //     .map(|x| { ... })
    //     .collect();
    // println!("Filtered and squared: {:?}", result);
    
    // TODO: Calculate sum of even numbers
    let nums = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // let sum: i32 = nums.iter()
    //     .filter(|x| { ... })
    //     .sum();
    // println!("Sum of evens: {}", sum);
    
    // TODO: Create a function that returns a closure
    // The closure should multiply by the given factor
    // fn make_multiplier(factor: i32) -> impl Fn(i32) -> i32 {
    //     move |x| { ... }
    // }
    
    // let times_3 = make_multiplier(3);
    // println!("5 * 3 = {}", times_3(5));
    
    // TODO: Use fold to find the maximum value
    let values = vec![3, 7, 2, 9, 1, 5];
    // let max = values.iter()
    //     .fold(0, |acc, x| { ... });
    // println!("Max: {}", max);
}

// Hints:
// 1. Closure syntax: |params| expression or |params| { body }
// 2. Closures capture variables from environment
// 3. Use * to dereference in closures: *x
// 4. filter keeps elements where closure returns true
// 5. map transforms each element
// 6. fold accumulates values: fold(initial, |accumulator, item| ...)
