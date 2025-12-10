// Exercise: Slices Practice
// Complete the functions using slices

fn main() {
    // TODO: Fix this to return a slice instead of index
    let s = String::from("hello world");
    let word = first_word_broken(&s);
    println!("First word: {}", word);
    
    // TODO: Implement second_word
    let text = "Rust programming language";
    let second = second_word(text);
    println!("Second word: {}", second);
    
    // TODO: Implement get_slice that returns middle portion
    let data = "abcdefghij";
    let middle = get_middle(data);
    println!("Middle: {}", middle);  // Should print "cdefgh"
    
    // TODO: Fix array slice function
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let evens = get_even_indices(&numbers);
    println!("Even indices: {:?}", evens);
    
    // TODO: Implement last_word
    let sentence = "The quick brown fox";
    let last = last_word(sentence);
    println!("Last word: {}", last);
}

fn first_word_broken(s: &String) -> usize {
    // Fix: Return &str instead of usize
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }
    s.len()
}

fn second_word(s: &str) -> &str {
    // TODO: Return the second word
    ""
}

fn get_middle(s: &str) -> &str {
    // TODO: Return characters from index 2 to len-2
    ""
}

fn get_even_indices(arr: &[i32]) -> Vec<i32> {
    // TODO: Return elements at even indices (0, 2, 4, ...)
    vec![]
}

fn last_word(s: &str) -> &str {
    // TODO: Return the last word
    ""
}

// Hints:
// 1. Use &s[start..end] for slices
// 2. Use .. for shortcuts: &s[..5], &s[5..], &s[..]
// 3. Use split_whitespace() to split by spaces
// 4. Use .last() to get last element
// 5. Array slices: &arr[start..end]
// 6. Iterate with .iter().enumerate()
