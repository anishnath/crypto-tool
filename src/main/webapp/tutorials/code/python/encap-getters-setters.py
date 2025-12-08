# Getter and Setter Methods

print("=== Getters and Setters ===\n")

# 1. Why use getters/setters?
print("1. The problem with direct access:")

class TemperatureBad:
    def __init__(self, celsius):
        self.celsius = celsius  # No validation

temp = TemperatureBad(25)
temp.celsius = -500  # Invalid! Below absolute zero
print(f"   Bad: celsius set to {temp.celsius}°C (invalid!)")
print()

# 2. Solution: Getter and setter methods
print("2. Getter and setter methods:")

class Temperature:
    def __init__(self, celsius):
        self._celsius = None
        self.set_celsius(celsius)  # Use setter for validation

    def get_celsius(self):
        """Getter method."""
        return self._celsius

    def set_celsius(self, value):
        """Setter method with validation."""
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value

    def get_fahrenheit(self):
        """Computed getter."""
        return self._celsius * 9/5 + 32

temp = Temperature(25)
print(f"   Celsius: {temp.get_celsius()}")
print(f"   Fahrenheit: {temp.get_fahrenheit()}")

temp.set_celsius(100)
print(f"   After set_celsius(100): {temp.get_celsius()}°C")

try:
    temp.set_celsius(-300)
except ValueError as e:
    print(f"   Validation error: {e}")
print()

# 3. Encapsulation benefits
print("3. Benefits of getters/setters:")

class BankAccount:
    def __init__(self, balance):
        self._balance = balance
        self._transactions = []

    def get_balance(self):
        """Read-only access to balance."""
        return self._balance

    def deposit(self, amount):
        """Controlled way to modify balance."""
        if amount <= 0:
            raise ValueError("Amount must be positive")
        self._balance += amount
        self._transactions.append(f"+${amount}")
        return self._balance

    def withdraw(self, amount):
        """Validation before modification."""
        if amount <= 0:
            raise ValueError("Amount must be positive")
        if amount > self._balance:
            raise ValueError("Insufficient funds")
        self._balance -= amount
        self._transactions.append(f"-${amount}")
        return self._balance

    def get_transactions(self):
        """Return copy to prevent modification."""
        return self._transactions.copy()

account = BankAccount(1000)
print(f"   Balance: ${account.get_balance()}")
account.deposit(500)
account.withdraw(200)
print(f"   After transactions: ${account.get_balance()}")
print(f"   Transaction log: {account.get_transactions()}")
print()

# 4. Read-only attributes
print("4. Read-only with getter only:")

class Employee:
    _next_id = 1

    def __init__(self, name):
        self._id = Employee._next_id
        Employee._next_id += 1
        self._name = name

    def get_id(self):
        """Read-only - no setter provided."""
        return self._id

    def get_name(self):
        return self._name

    def set_name(self, name):
        """Name can be changed."""
        self._name = name

emp = Employee("Alice")
print(f"   Employee ID: {emp.get_id()} (read-only)")
print(f"   Name: {emp.get_name()}")
emp.set_name("Alicia")
print(f"   Name changed to: {emp.get_name()}")
# emp.set_id(999)  # No such method - ID is read-only
print()

# 5. Note: Python has @property
print("5. Preview: Python has a better way!")
print("""
   Instead of explicit getters/setters:

   class Temperature:
       @property
       def celsius(self):
           return self._celsius

       @celsius.setter
       def celsius(self, value):
           if value < -273.15:
               raise ValueError("Too cold!")
           self._celsius = value

   # Use like an attribute:
   temp.celsius = 25  # Calls setter
   print(temp.celsius)  # Calls getter

   Learn more in the Properties lesson!
""")
