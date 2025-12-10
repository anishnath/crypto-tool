// Exercise: Generics Practice

fn main() {
    // TODO: Create a generic function `find_max` that finds the maximum value in a slice
    // It should work with any type that implements PartialOrd
    // fn find_max<T: PartialOrd>(list: &[T]) -> Option<&T> {
    //     // Your code here
    // }
    
    // Test with numbers
    let numbers = vec![3, 7, 2, 9, 1];
    // if let Some(max) = find_max(&numbers) {
    //     println!("Max number: {}", max);
    // }
    
    // Test with strings
    let words = vec!["apple", "zebra", "banana"];
    // if let Some(max) = find_max(&words) {
    //     println!("Max word: {}", max);
    // }
    
    // TODO: Create a generic struct `Container<T>` that holds a value
    // struct Container<T> {
    //     value: T,
    // }
    
    // TODO: Implement methods for Container:
    // - new(value: T) -> Self
    // - get(&self) -> &T
    // - set(&mut self, value: T)
    
    // impl<T> Container<T> {
    //     // Your implementations here
    // }
    
    // TODO: Add a method that only works when T implements Display
    // impl<T: Display> Container<T> {
    //     fn print(&self) {
    //         println!("Container holds: {}", self.value);
    //     }
    // }
    
    // Test Container
    // let mut container = Container::new(42);
    // println!("Value: {}", container.get());
    // container.set(100);
    // container.print();
    
    // TODO: Create a generic function `swap` that swaps two values
    // fn swap<T>(a: &mut T, b: &mut T) {
    //     // Hint: use std::mem::swap or manual swapping
    // }
    
    // Test swap
    // let mut x = 5;
    // let mut y = 10;
    // swap(&mut x, &mut y);
    // println!("After swap: x = {}, y = {}", x, y);
}

// Hints:
// 1. Use Option<&T> to handle empty slices
// 2. Use iter() to iterate over slices
// 3. Generic type parameters go in angle brackets <T>
// 4. Trait bounds constrain what types can be used
// 5. Use std::mem::swap for swapping values
