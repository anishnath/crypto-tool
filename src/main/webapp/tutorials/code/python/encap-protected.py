# Protected Attributes (Single Underscore)

print("=== Protected Access (_) ===\n")

# 1. Protected convention - single underscore prefix
print("1. Protected attributes (_prefix):")

class BankAccount:
    def __init__(self, owner, balance):
        self.owner = owner       # Public
        self._balance = balance  # Protected by convention
        self._account_type = "Savings"

    def deposit(self, amount):
        if amount > 0:
            self._balance += amount
            return True
        return False

    def get_info(self):
        return f"{self.owner}: ${self._balance} ({self._account_type})"

account = BankAccount("Alice", 1000)
print(f"   Info: {account.get_info()}")

# Protected attributes ARE accessible (just a convention)
print(f"   _balance: ${account._balance}")  # Works, but discouraged
print(f"   _account_type: {account._account_type}")  # Works, but discouraged
print()

# 2. Protected means "internal use"
print("2. Protected = 'use at your own risk':")
print("""
   The underscore says:
   - "This is an implementation detail"
   - "Don't rely on this in your code"
   - "May change without notice"
   - "Subclasses can use it"
""")

# 3. Protected in inheritance
print("3. Protected is useful in inheritance:")

class Vehicle:
    def __init__(self, brand):
        self._brand = brand   # Protected - subclasses can use
        self._speed = 0

    def _accelerate(self, amount):
        """Protected method for subclasses."""
        self._speed += amount

class Car(Vehicle):
    def drive(self):
        self._accelerate(10)  # Subclass uses protected method
        return f"{self._brand} driving at {self._speed} mph"

car = Car("Toyota")
print(f"   {car.drive()}")
print(f"   {car.drive()}")
print()

# 4. Common protected patterns
print("4. Common uses of protected:")

class DatabaseConnection:
    def __init__(self, host):
        self._host = host
        self._connection = None
        self._is_connected = False

    def connect(self):
        """Public interface."""
        self._establish_connection()

    def _establish_connection(self):
        """Protected - implementation detail."""
        print(f"   Connecting to {self._host}...")
        self._connection = f"Connection to {self._host}"
        self._is_connected = True
        print(f"   Connected!")

    def _validate_connection(self):
        """Protected helper method."""
        if not self._is_connected:
            raise Exception("Not connected!")

db = DatabaseConnection("localhost")
db.connect()
print()

# 5. Tools respect the convention
print("5. IDEs and tools recognize underscore:")
print("""
   - IDEs won't autocomplete _attributes by default
   - Linters may warn about accessing _attributes
   - Documentation tools may hide _methods
   - It's a social contract, not enforcement
""")
