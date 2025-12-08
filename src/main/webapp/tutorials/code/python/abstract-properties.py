# Abstract Properties

print("=== Abstract Properties ===\n")

from abc import ABC, abstractmethod

# 1. Abstract property (getter only)
print("1. Abstract property:")

class Vehicle(ABC):
    @property
    @abstractmethod
    def max_speed(self):
        """Subclasses must define max_speed property."""
        pass

    @property
    @abstractmethod
    def wheels(self):
        """Subclasses must define wheels property."""
        pass

    def describe(self):
        return f"Vehicle with {self.wheels} wheels, max {self.max_speed} mph"

class Car(Vehicle):
    @property
    def max_speed(self):
        return 120

    @property
    def wheels(self):
        return 4

class Motorcycle(Vehicle):
    @property
    def max_speed(self):
        return 150

    @property
    def wheels(self):
        return 2

car = Car()
moto = Motorcycle()

print(f"   Car: {car.describe()}")
print(f"   Motorcycle: {moto.describe()}")
print()

# 2. Abstract property with setter
print("2. Abstract property with getter and setter:")

class Account(ABC):
    @property
    @abstractmethod
    def balance(self):
        """Get balance."""
        pass

    @balance.setter
    @abstractmethod
    def balance(self, value):
        """Set balance."""
        pass

class BankAccount(Account):
    def __init__(self, initial_balance=0):
        self._balance = initial_balance

    @property
    def balance(self):
        return self._balance

    @balance.setter
    def balance(self, value):
        if value < 0:
            raise ValueError("Balance cannot be negative")
        self._balance = value

account = BankAccount(100)
print(f"   Initial balance: ${account.balance}")
account.balance = 500
print(f"   New balance: ${account.balance}")
print()

# 3. Combining abstract methods and properties
print("3. Complete interface with methods and properties:")

class FileHandler(ABC):
    @property
    @abstractmethod
    def extension(self):
        """File extension this handler supports."""
        pass

    @abstractmethod
    def read(self, filename):
        """Read file and return contents."""
        pass

    @abstractmethod
    def write(self, filename, data):
        """Write data to file."""
        pass

    def can_handle(self, filename):
        """Concrete method using abstract property."""
        return filename.endswith(self.extension)

class JSONHandler(FileHandler):
    @property
    def extension(self):
        return ".json"

    def read(self, filename):
        return f"Reading JSON from {filename}"

    def write(self, filename, data):
        return f"Writing JSON to {filename}"

class CSVHandler(FileHandler):
    @property
    def extension(self):
        return ".csv"

    def read(self, filename):
        return f"Reading CSV from {filename}"

    def write(self, filename, data):
        return f"Writing CSV to {filename}"

handlers = [JSONHandler(), CSVHandler()]
for handler in handlers:
    print(f"   Handler for {handler.extension}:")
    print(f"      Can handle 'data.json': {handler.can_handle('data.json')}")
    print(f"      Can handle 'data.csv': {handler.can_handle('data.csv')}")
