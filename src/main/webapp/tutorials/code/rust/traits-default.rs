fn main() {
    // Trait with default implementation
    trait Summary {
        fn summarize_author(&self) -> String;
        
        // Default implementation
        fn summarize(&self) -> String {
            format!("(Read more from {}...)", self.summarize_author())
        }
    }
    
    struct NewsArticle {
        headline: String,
        location: String,
        author: String,
    }
    
    impl Summary for NewsArticle {
        fn summarize_author(&self) -> String {
            format!("{}", self.author)
        }
        
        // Override default implementation
        fn summarize(&self) -> String {
            format!("{}, by {} ({})", self.headline, self.author, self.location)
        }
    }
    
    struct Tweet {
        username: String,
        content: String,
    }
    
    impl Summary for Tweet {
        fn summarize_author(&self) -> String {
            format!("@{}", self.username)
        }
        // Uses default summarize() implementation
    }
    
    let article = NewsArticle {
        headline: String::from("Rust 2.0 Released"),
        location: String::from("SF"),
        author: String::from("Jane Doe"),
    };
    
    let tweet = Tweet {
        username: String::from("rustlang"),
        content: String::from("Rust is awesome!"),
    };
    
    println!("Article: {}", article.summarize());
    println!("Tweet: {}", tweet.summarize());  // Uses default
}

// Default implementations can call other trait methods
// Types can override defaults or use them as-is
