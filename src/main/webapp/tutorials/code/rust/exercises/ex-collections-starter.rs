// Exercise: Collections Practice

fn main() {
    // TODO: Exercise 1 - Vector Statistics
    // Write a function that takes a Vec<i32> and returns:
    // - The mean (average)
    // - The median (middle value when sorted)
    // - The mode (most frequent value)
    
    fn statistics(numbers: &Vec<i32>) -> (f64, i32, i32) {
        // Your code here
        (0.0, 0, 0)
    }
    
    let numbers = vec![1, 2, 2, 3, 3, 3, 4, 5];
    let (mean, median, mode) = statistics(&numbers);
    println!("Mean: {}, Median: {}, Mode: {}", mean, median, mode);
    
    // TODO: Exercise 2 - String Manipulation
    // Convert "hello world" to "pig latin":
    // - First consonant moves to end + "ay": "hello" -> "ello-hay"
    // - Words starting with vowel get "hay": "apple" -> "apple-hay"
    
    fn to_pig_latin(text: &str) -> String {
        // Your code here
        String::new()
    }
    
    println!("Pig Latin: {}", to_pig_latin("hello world"));
    
    // TODO: Exercise 3 - Employee Database
    // Using HashMap, create a text interface to:
    // - Add employee to department: "Add Sally to Engineering"
    // - List all people in a department
    // - List all people in company by department (sorted)
    
    use std::collections::HashMap;
    
    fn add_employee(db: &mut HashMap<String, Vec<String>>, name: String, dept: String) {
        // Your code here
    }
    
    fn list_department(db: &HashMap<String, Vec<String>>, dept: &str) {
        // Your code here
    }
    
    let mut company: HashMap<String, Vec<String>> = HashMap::new();
    add_employee(&mut company, String::from("Sally"), String::from("Engineering"));
    add_employee(&mut company, String::from("Bob"), String::from("Sales"));
    list_department(&company, "Engineering");
}

// Hints:
// 1. For mean: sum / count
// 2. For median: sort and take middle
// 3. For mode: use HashMap to count occurrences
// 4. For pig latin: check first char, use string slicing
// 5. For employee db: entry().or_insert(Vec::new()).push(name)
