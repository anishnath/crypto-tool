# Instance Methods

print("=== Instance Methods ===\n")

# 1. Basic instance method
print("1. Basic instance method:")

class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def bark(self):
        """Instance method - uses self to access instance data."""
        print(f"   {self.name} says: Woof!")

    def describe(self):
        """Another instance method."""
        return f"{self.name} is {self.age} years old"

buddy = Dog("Buddy", 3)
buddy.bark()
print(f"   {buddy.describe()}")
print()

# 2. Methods that modify state
print("2. Methods that modify state:")

class Counter:
    def __init__(self, start=0):
        self.value = start

    def increment(self):
        self.value += 1

    def decrement(self):
        self.value -= 1

    def reset(self):
        self.value = 0

counter = Counter(10)
print(f"   Initial: {counter.value}")
counter.increment()
counter.increment()
print(f"   After 2 increments: {counter.value}")
counter.decrement()
print(f"   After decrement: {counter.value}")
print()

# 3. Methods with parameters
print("3. Methods with parameters:")

class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        """Add money to account."""
        if amount > 0:
            self.balance += amount
            return True
        return False

    def withdraw(self, amount):
        """Remove money from account."""
        if 0 < amount <= self.balance:
            self.balance -= amount
            return True
        return False

    def transfer_to(self, other_account, amount):
        """Transfer money to another account."""
        if self.withdraw(amount):
            other_account.deposit(amount)
            return True
        return False

alice = BankAccount("Alice", 1000)
bob = BankAccount("Bob", 500)

print(f"   Alice: ${alice.balance}, Bob: ${bob.balance}")
alice.transfer_to(bob, 200)
print(f"   After transfer: Alice: ${alice.balance}, Bob: ${bob.balance}")
print()

# 4. Methods calling other methods
print("4. Methods calling other methods:")

class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)

    def describe(self):
        # Calling other methods within a method
        return f"{self.width}x{self.height}, Area: {self.area()}, Perimeter: {self.perimeter()}"

rect = Rectangle(5, 3)
print(f"   {rect.describe()}")
print()

# 5. The 'self' is passed automatically
print("5. How self works:")

class Demo:
    def show(self):
        print(f"   self is: {self}")

d = Demo()
print(f"   d is: {d}")
d.show()  # Python passes 'd' as 'self'
# Equivalent to:
Demo.show(d)  # Explicit call
