// Exercise: Methods Practice
// Complete the implementation of methods for these structs

fn main() {
    // TODO: Implement methods for BankAccount
    struct BankAccount {
        balance: f64,
        owner: String,
    }
    
    impl BankAccount {
        // TODO: Create a new account with initial balance
        fn new(owner: String, initial_balance: f64) -> BankAccount {
            // Your code here
        }
        
        // TODO: Deposit money (needs &mut self)
        fn deposit(&mut self, amount: f64) {
            // Your code here
        }
        
        // TODO: Withdraw money (needs &mut self, return bool for success)
        fn withdraw(&mut self, amount: f64) -> bool {
            // Your code here
            false
        }
        
        // TODO: Get balance (needs &self)
        fn balance(&self) -> f64 {
            // Your code here
            0.0
        }
    }
    
    // Test BankAccount
    let mut account = BankAccount::new(String::from("Alice"), 100.0);
    println!("Initial balance: {}", account.balance());
    
    account.deposit(50.0);
    println!("After deposit: {}", account.balance());
    
    if account.withdraw(30.0) {
        println!("Withdrawal successful. New balance: {}", account.balance());
    }
    
    // TODO: Implement methods for Temperature
    struct Temperature {
        celsius: f64,
    }
    
    impl Temperature {
        // TODO: Create from Celsius
        fn from_celsius(celsius: f64) -> Temperature {
            // Your code here
        }
        
        // TODO: Create from Fahrenheit
        fn from_fahrenheit(fahrenheit: f64) -> Temperature {
            // Formula: C = (F - 32) * 5/9
            // Your code here
        }
        
        // TODO: Convert to Fahrenheit
        fn to_fahrenheit(&self) -> f64 {
            // Formula: F = C * 9/5 + 32
            // Your code here
            0.0
        }
        
        // TODO: Check if freezing (0°C or below)
        fn is_freezing(&self) -> bool {
            // Your code here
            false
        }
    }
    
    // Test Temperature
    let temp = Temperature::from_fahrenheit(32.0);
    println!("Is freezing? {}", temp.is_freezing());
    println!("In Fahrenheit: {}°F", temp.to_fahrenheit());
}

// Hints:
// 1. Use &self for methods that only read data
// 2. Use &mut self for methods that modify data
// 3. Associated functions don't have self parameter
// 4. Use Type::function() for associated functions
// 5. Use instance.method() for methods
