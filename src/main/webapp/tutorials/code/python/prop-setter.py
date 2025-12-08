# Property Setters - @property.setter

print("=== Property Setters ===\n")

# 1. Adding a setter to a property
print("1. Getter and setter together:")

class Temperature:
    def __init__(self, celsius=0):
        self._celsius = celsius

    @property
    def celsius(self):
        """Getter for celsius."""
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        """Setter with validation."""
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value

temp = Temperature(25)
print(f"   Initial: {temp.celsius}°C")

temp.celsius = 100  # Calls setter
print(f"   After setting to 100: {temp.celsius}°C")

try:
    temp.celsius = -300  # Validation fails
except ValueError as e:
    print(f"   Validation error: {e}")
print()

# 2. Property with type conversion
print("2. Setter with type conversion:")

class Person:
    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, value):
        """Convert to int and validate."""
        value = int(value)  # Convert strings, floats
        if value < 0 or value > 150:
            raise ValueError("Age must be between 0 and 150")
        self._age = value

p = Person("Alice", 30)
print(f"   Initial age: {p.age}")

p.age = "35"  # String - gets converted
print(f"   After setting '35' (string): {p.age}")

p.age = 40.9  # Float - gets converted to int
print(f"   After setting 40.9 (float): {p.age}")
print()

# 3. The setter must have the same name
print("3. Setter pattern:")
print("""
   @property
   def name(self):
       return self._name

   @name.setter  # Must be @<property_name>.setter
   def name(self, value):
       self._name = value
""")

# 4. Property with deleter
print("4. Adding a deleter:")

class User:
    def __init__(self, email):
        self._email = email

    @property
    def email(self):
        return self._email

    @email.setter
    def email(self, value):
        if '@' not in value:
            raise ValueError("Invalid email")
        self._email = value

    @email.deleter
    def email(self):
        """Called by: del user.email"""
        print("   Clearing email...")
        self._email = None

user = User("alice@example.com")
print(f"   Email: {user.email}")

del user.email  # Calls deleter
print(f"   After delete: {user.email}")
print()

# 5. Complete example with all three
print("5. Complete property (getter, setter, deleter):")

class BankAccount:
    def __init__(self, initial_balance=0):
        self._balance = initial_balance

    @property
    def balance(self):
        """Get current balance."""
        return self._balance

    @balance.setter
    def balance(self, value):
        """Set balance with validation."""
        if value < 0:
            raise ValueError("Balance cannot be negative")
        self._balance = value

    @balance.deleter
    def balance(self):
        """Close account (reset to zero)."""
        print("   Account closed.")
        self._balance = 0

account = BankAccount(1000)
print(f"   Balance: ${account.balance}")
account.balance = 500
print(f"   New balance: ${account.balance}")
