<?php
// Access Modifiers

class BankAccount
{
    public $accountNumber;      // Accessible everywhere
    protected $balance;         // Accessible in class and subclasses
    private $pin;              // Only accessible in this class

    public function __construct($accountNumber, $balance, $pin)
    {
        $this->accountNumber = $accountNumber;
        $this->balance = $balance;
        $this->pin = $pin;
    }

    // Public method - accessible everywhere
    public function getBalance()
    {
        return $this->balance;
    }

    // Public method to deposit
    public function deposit($amount)
    {
        $this->balance += $amount;
    }

    // Private method - only within this class
    private function validatePin($pin)
    {
        return $this->pin === $pin;
    }
}

$account = new BankAccount("123456", 1000, "1234");
echo $account->accountNumber . "\n";  // OK - public
echo $account->getBalance() . "\n";   // OK - public method
// echo $account->balance;  // Error - protected
// echo $account->pin;      // Error - private
