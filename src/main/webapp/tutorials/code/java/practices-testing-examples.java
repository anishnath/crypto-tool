import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

public class BankAccountTest {
    private BankAccount account;
    
    @Before
    public void setUp() {
        account = new BankAccount("ACC001", 1000.0);
    }
    
    @Test
    public void testDeposit() {
        account.deposit(500.0);
        assertEquals(1500.0, account.getBalance(), 0.01);
    }
    
    @Test
    public void testWithdraw() {
        boolean success = account.withdraw(300.0);
        assertTrue(success);
        assertEquals(700.0, account.getBalance(), 0.01);
    }
    
    @Test
    public void testWithdrawInsufficientFunds() {
        boolean success = account.withdraw(2000.0);
        assertFalse(success);
        assertEquals(1000.0, account.getBalance(), 0.01);
    }
    
    @Test
    public void testGetAccountNumber() {
        assertEquals("ACC001", account.getAccountNumber());
    }
}

class BankAccount {
    private String accountNumber;
    private double balance;
    
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }
    
    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            return true;
        }
        return false;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
}

