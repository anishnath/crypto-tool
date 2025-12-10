fn main() {
    use std::collections::HashMap;
    
    // Creating a HashMap
    let mut scores = HashMap::new();
    
    // Inserting key-value pairs
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
    
    println!("Scores: {:?}", scores);
    
    // Accessing values
    let team_name = String::from("Blue");
    let score = scores.get(&team_name);
    
    match score {
        Some(s) => println!("Blue team score: {}", s),
        None => println!("Team not found"),
    }
    
    // Iterating over HashMap
    println!("\nAll scores:");
    for (key, value) in &scores {
        println!("{}: {}", key, value);
    }
    
    // Updating values
    scores.insert(String::from("Blue"), 25);  // Overwrites old value
    println!("\nAfter update: {:?}", scores);
    
    // Only insert if key doesn't exist
    scores.entry(String::from("Blue")).or_insert(50);  // Won't change
    scores.entry(String::from("Red")).or_insert(50);   // Will insert
    println!("After or_insert: {:?}", scores);
    
    // Update based on old value
    let text = "hello world wonderful world";
    let mut map = HashMap::new();
    
    for word in text.split_whitespace() {
        let count = map.entry(word).or_insert(0);
        *count += 1;
    }
    
    println!("\nWord counts: {:?}", map);
    
    // Ownership
    let field_name = String::from("Favorite color");
    let field_value = String::from("Blue");
    
    let mut map2 = HashMap::new();
    map2.insert(field_name, field_value);
    // field_name and field_value are moved
    // println!("{}", field_name);  // Error!
    
    // With references (must outlive HashMap)
    let key = String::from("key");
    let value = String::from("value");
    let mut map3 = HashMap::new();
    map3.insert(&key, &value);
    println!("key still valid: {}", key);
}

// Key points:
// - HashMap<K, V> stores key-value pairs
// - Keys must implement Eq and Hash
// - insert moves ownership
// - Use entry API for conditional updates
