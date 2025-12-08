# Python Encapsulation
# Encapsulation is one of the fundamental concepts in object-oriented programming (OOP).
# It describes the idea of wrapping data and the methods that work on data within one unit.

class BankAccount:
    def __init__(self, name, balance):
        self.name = name       # Public attribute
        self._type = "Savings" # Protected attribute (convention)
        self.__balance = balance # Private attribute

    # Public method
    def deposit(self, amount):
        self.__balance += amount

    # Public method to access private data
    def get_balance(self):
        return self.__balance

account = BankAccount("John", 1000)

# Accessing public attribute
print(account.name)

# Accessing protected attribute (Possible, but should be avoided outside class/subclasses)
print(account._type)

# Accessing private attribute (Raises AttributeError)
# print(account.__balance)

# Accessing private attribute via method
print(account.get_balance())

# Name Mangling (How Python implements private variables)
# print(account._BankAccount__balance) # This works but is not recommended
