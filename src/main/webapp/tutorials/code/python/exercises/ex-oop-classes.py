# Exercise: Bank Account Class
# Task: Create a BankAccount class with proper initialization.

# Requirements:
# 1. Initialize with owner name and optional starting balance (default 0)
# 2. Add a class attribute to track total accounts created
# 3. Validate that balance is not negative in __init__
# 4. Create a method to display account info

class BankAccount:
    """A simple bank account class."""
    # Your code here: add class attribute for tracking accounts

    def __init__(self, owner, balance=0):
        """Initialize account with owner and optional balance."""
        # Your code here:
        # - Validate owner is not empty
        # - Validate balance is not negative
        # - Set instance attributes
        # - Increment account counter
        pass

    def display(self):
        """Display account information."""
        # Your code here
        pass


# Test the class
acc1 = BankAccount("Alice", 1000)
acc2 = BankAccount("Bob", 500)

print("=== Bank Accounts ===")
print(acc1.display())
print(acc2.display())
