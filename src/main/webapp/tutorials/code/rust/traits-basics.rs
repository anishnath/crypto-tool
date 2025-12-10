fn main() {
    // Define a trait
    trait Summary {
        fn summarize(&self) -> String;
    }
    
    // Implement trait for a struct
    struct NewsArticle {
        headline: String,
        location: String,
        author: String,
        content: String,
    }
    
    impl Summary for NewsArticle {
        fn summarize(&self) -> String {
            format!("{}, by {} ({})", self.headline, self.author, self.location)
        }
    }
    
    struct Tweet {
        username: String,
        content: String,
        reply: bool,
        retweet: bool,
    }
    
    impl Summary for Tweet {
        fn summarize(&self) -> String {
            format!("{}: {}", self.username, self.content)
        }
    }
    
    // Using traits
    let article = NewsArticle {
        headline: String::from("Rust 2.0 Released!"),
        location: String::from("San Francisco"),
        author: String::from("Jane Doe"),
        content: String::from("Rust 2.0 brings amazing new features..."),
    };
    
    let tweet = Tweet {
        username: String::from("rustlang"),
        content: String::from("Rust is awesome!"),
        reply: false,
        retweet: false,
    };
    
    println!("Article: {}", article.summarize());
    println!("Tweet: {}", tweet.summarize());
}

// Traits define shared behavior across different types
// Like interfaces in other languages
