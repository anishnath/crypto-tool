/**
 * Represents a bank account with basic operations.
 * 
 * This class provides methods to deposit, withdraw, and check balance.
 * 
 * @author John Doe
 * @version 1.0
 * @since 1.0
 */
public class Account {
    private String accountNumber;
    private double balance;
    
    /**
     * Creates a new account with the specified account number.
     * 
     * @param accountNumber the unique account identifier
     * @throws IllegalArgumentException if accountNumber is null or empty
     */
    public Account(String accountNumber) {
        if (accountNumber == null || accountNumber.isEmpty()) {
            throw new IllegalArgumentException("Account number cannot be null or empty");
        }
        this.accountNumber = accountNumber;
        this.balance = 0.0;
    }
    
    /**
     * Deposits money into the account.
     * 
     * @param amount the amount to deposit (must be positive)
     * @return the new balance after deposit
     * @throws IllegalArgumentException if amount is negative or zero
     */
    public double deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be positive");
        }
        balance += amount;
        return balance;
    }
    
    /**
     * Withdraws money from the account.
     * 
     * @param amount the amount to withdraw
     * @return true if withdrawal was successful, false if insufficient funds
     * @throws IllegalArgumentException if amount is negative or zero
     */
    public boolean withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be positive");
        }
        if (amount <= balance) {
            balance -= amount;
            return true;
        }
        return false;
    }
    
    /**
     * Gets the current account balance.
     * 
     * @return the current balance
     */
    public double getBalance() {
        return balance;
    }
    
    /**
     * Gets the account number.
     * 
     * @return the account number
     */
    public String getAccountNumber() {
        return accountNumber;
    }
}

