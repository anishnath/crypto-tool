// Access Modifiers

class BankAccount {
    public accountHolder: string;      // Accessible everywhere
    private balance: number;            // Only within this class
    protected accountNumber: string;    // This class + child classes

    constructor(holder: string, initialBalance: number) {
        this.accountHolder = holder;
        this.balance = initialBalance;
        this.accountNumber = `ACC${Math.random().toString().slice(2, 10)}`;
    }

    // Public method
    public deposit(amount: number): void {
        this.balance += amount;
        console.log(`Deposited $${amount}`);
    }

    // Private method
    private calculateInterest(): number {
        return this.balance * 0.05;
    }

    // Public method using private method
    public getBalance(): number {
        return this.balance;
    }
}

let account = new BankAccount("Alice", 1000);
account.deposit(500);
console.log("Balance:", account.getBalance());
// console.log(account.balance); // Error! Private
