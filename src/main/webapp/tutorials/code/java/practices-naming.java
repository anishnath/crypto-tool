// Good naming conventions examples

// Class names: PascalCase
public class BankAccount {
    // Constants: UPPER_SNAKE_CASE
    public static final int MAX_WITHDRAWAL = 10000;
    private static final String DEFAULT_CURRENCY = "USD";
    
    // Instance variables: camelCase
    private String accountNumber;
    private double balance;
    private boolean isActive;
    
    // Methods: camelCase, verb-noun pattern
    public void depositMoney(double amount) {
        if (isValidAmount(amount)) {
            balance += amount;
        }
    }
    
    public double getBalance() {
        return balance;
    }
    
    // Boolean methods: is/has/can prefix
    private boolean isValidAmount(double amount) {
        return amount > 0;
    }
    
    public boolean isAccountActive() {
        return isActive;
    }
    
    // Constructor: same as class name
    public BankAccount(String accountNumber) {
        this.accountNumber = accountNumber;
        this.balance = 0.0;
        this.isActive = true;
    }
}

// Package: lowercase, reverse domain
package com.example.banking;

// Interface: PascalCase, often adjective
interface Withdrawable {
    void withdraw(double amount);
}

