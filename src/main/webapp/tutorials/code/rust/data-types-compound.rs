fn main() {
    // Tuples - fixed size, mixed types
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    
    // Destructuring
    let (x, y, z) = tup;
    println!("x = {}, y = {}, z = {}", x, y, z);
    
    // Access by index
    let five_hundred = tup.0;
    let six_point_four = tup.1;
    let one = tup.2;
    
    println!("Values: {}, {}, {}", five_hundred, six_point_four, one);
    
    // Arrays - fixed size, same type
    let arr = [1, 2, 3, 4, 5];
    let first = arr[0];
    let second = arr[1];
    
    println!("First: {}, Second: {}", first, second);
    
    // Array with type annotation
    let arr: [i32; 5] = [1, 2, 3, 4, 5];
    
    // Initialize array with same value
    let arr = [3; 5];  // [3, 3, 3, 3, 3]
    println!("Array: {:?}", arr);
}
