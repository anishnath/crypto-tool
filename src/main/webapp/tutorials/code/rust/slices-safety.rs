fn main() {
    // Problem: Without slices
    let mut s = String::from("hello world");
    let word_index = first_word_index(&s);
    
    s.clear();  // This empties the String
    // word_index still has value 5, but it's now meaningless!
    
    // Solution: With slices
    let s = String::from("hello world");
    let word = first_word(&s);
    
    // s.clear();  // Error! Can't mutate while immutable borrow exists
    println!("First word: {}", word);
    
    // Practical example: Parsing
    let text = "Rust is awesome";
    let words = get_words(text);
    for word in words {
        println!("Word: {}", word);
    }
    
    // Slices keep data valid
    let data = String::from("important data");
    let slice = &data[..9];  // "important"
    
    // data can't be modified while slice exists
    println!("Slice: {}", slice);
    // Now data can be modified
}

fn first_word_index(s: &String) -> usize {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }
    
    s.len()
}

fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}

fn get_words(s: &str) -> Vec<&str> {
    s.split_whitespace().collect()
}
