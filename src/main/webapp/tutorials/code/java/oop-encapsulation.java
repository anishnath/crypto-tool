// Example of proper encapsulation
public class BankAccount {
    // Private instance variables - cannot be accessed directly
    private String accountNumber;
    private double balance;
    
    // Public constructor
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        if (initialBalance >= 0) {
            this.balance = initialBalance;
        } else {
            this.balance = 0;
        }
    }
    
    // Public getter method
    public double getBalance() {
        return balance;
    }
    
    // Public method to deposit (with validation)
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
        } else {
            System.out.println("Invalid deposit amount");
        }
    }
    
    // Public method to withdraw (with validation)
    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrew: $" + amount);
            return true;
        } else {
            System.out.println("Insufficient funds or invalid amount");
            return false;
        }
    }
    
    // Public method to display account info
    public void displayInfo() {
        System.out.println("Account: " + accountNumber);
        System.out.println("Balance: $" + balance);
    }
}

public class OopEncapsulation {
    public static void main(String[] args) {
        BankAccount account = new BankAccount("ACC001", 1000.0);
        
        // Cannot directly modify balance
        // account.balance = -100;  // Error! balance is private
        
        // Must use public methods
        account.displayInfo();
        account.deposit(500.0);
        account.withdraw(200.0);
        account.displayInfo();
        
        // Validation prevents invalid operations
        account.withdraw(2000.0);  // Should fail - insufficient funds
        account.deposit(-100.0);   // Should fail - invalid amount
    }
}

