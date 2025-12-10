fn main() {
    // Traits as parameters
    trait Summary {
        fn summarize(&self) -> String;
    }
    
    struct Article {
        title: String,
        author: String,
    }
    
    impl Summary for Article {
        fn summarize(&self) -> String {
            format!("{} by {}", self.title, self.author)
        }
    }
    
    struct Tweet {
        username: String,
        content: String,
    }
    
    impl Summary for Tweet {
        fn summarize(&self) -> String {
            format!("@{}: {}", self.username, self.content)
        }
    }
    
    // Function that accepts any type implementing Summary
    fn notify(item: &impl Summary) {
        println!("Breaking news! {}", item.summarize());
    }
    
    // Trait bound syntax (equivalent)
    fn notify_verbose<T: Summary>(item: &T) {
        println!("Breaking news! {}", item.summarize());
    }
    
    // Multiple trait bounds
    fn notify_and_display<T: Summary + std::fmt::Display>(item: &T) {
        println!("Display: {}", item);
        println!("Summary: {}", item.summarize());
    }
    
    // where clause for complex bounds
    fn some_function<T, U>(t: &T, u: &U) -> String
    where
        T: Summary + Clone,
        U: Summary + std::fmt::Debug,
    {
        format!("{} and {:?}", t.summarize(), u)
    }
    
    let article = Article {
        title: String::from("Rust Traits"),
        author: String::from("Rustacean"),
    };
    
    let tweet = Tweet {
        username: String::from("rust"),
        content: String::from("Learning traits!"),
    };
    
    notify(&article);
    notify(&tweet);
    notify_verbose(&article);
}

// Traits as parameters enable polymorphism
// Use impl Trait or generic syntax with trait bounds
