fn main() {
    // Array slices
    let a = [1, 2, 3, 4, 5];
    
    let slice = &a[1..3];  // [2, 3]
    println!("Array slice: {:?}", slice);
    
    // Slice type is &[T]
    let numbers = [10, 20, 30, 40, 50];
    
    let first_three = &numbers[..3];   // [10, 20, 30]
    let last_two = &numbers[3..];      // [40, 50]
    let middle = &numbers[1..4];       // [20, 30, 40]
    
    println!("First three: {:?}", first_three);
    println!("Last two: {:?}", last_two);
    println!("Middle: {:?}", middle);
    
    // Using slices in functions
    let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    let sum = sum_slice(&arr[..]);
    println!("Sum of all: {}", sum);
    
    let sum = sum_slice(&arr[2..7]);
    println!("Sum of [2..7]: {}", sum);
    
    // Slices are references
    let data = [100, 200, 300];
    print_slice(&data);
    println!("Original array still valid: {:?}", data);
}

fn sum_slice(slice: &[i32]) -> i32 {
    let mut total = 0;
    for &value in slice {
        total += value;
    }
    total
}

fn print_slice(slice: &[i32]) {
    println!("Slice: {:?}", slice);
}
