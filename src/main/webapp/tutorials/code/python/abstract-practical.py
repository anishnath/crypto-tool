# Practical Abstract Class Examples

print("=== Practical Abstract Classes ===\n")

from abc import ABC, abstractmethod

# 1. Database interface
print("1. Database interface pattern:")

class Database(ABC):
    """Abstract interface for database operations."""

    @abstractmethod
    def connect(self):
        pass

    @abstractmethod
    def execute(self, query):
        pass

    @abstractmethod
    def close(self):
        pass

    def query(self, sql):
        """Template method using abstract methods."""
        self.connect()
        result = self.execute(sql)
        self.close()
        return result

class SQLiteDB(Database):
    def connect(self):
        print("   Connecting to SQLite...")

    def execute(self, query):
        print(f"   Executing: {query}")
        return ["row1", "row2"]

    def close(self):
        print("   Closing SQLite connection")

class PostgresDB(Database):
    def connect(self):
        print("   Connecting to PostgreSQL...")

    def execute(self, query):
        print(f"   Executing: {query}")
        return ["row1", "row2", "row3"]

    def close(self):
        print("   Closing PostgreSQL connection")

# Use any database - same interface!
for db in [SQLiteDB(), PostgresDB()]:
    print(f"   Using {db.__class__.__name__}:")
    db.query("SELECT * FROM users")
    print()

# 2. Payment processor
print("2. Payment processor interface:")

class PaymentProcessor(ABC):
    @abstractmethod
    def process_payment(self, amount):
        pass

    @abstractmethod
    def refund(self, transaction_id):
        pass

    @property
    @abstractmethod
    def name(self):
        pass

class StripeProcessor(PaymentProcessor):
    @property
    def name(self):
        return "Stripe"

    def process_payment(self, amount):
        return f"   {self.name}: Charged ${amount}"

    def refund(self, transaction_id):
        return f"   {self.name}: Refunded {transaction_id}"

class PayPalProcessor(PaymentProcessor):
    @property
    def name(self):
        return "PayPal"

    def process_payment(self, amount):
        return f"   {self.name}: Processed ${amount}"

    def refund(self, transaction_id):
        return f"   {self.name}: Reversed {transaction_id}"

def checkout(processor, amount):
    """Works with any payment processor."""
    print(processor.process_payment(amount))

checkout(StripeProcessor(), 99.99)
checkout(PayPalProcessor(), 49.99)
print()

# 3. Plugin system
print("3. Plugin system:")

class Plugin(ABC):
    @property
    @abstractmethod
    def name(self):
        pass

    @abstractmethod
    def activate(self):
        pass

    @abstractmethod
    def execute(self, data):
        pass

class LoggerPlugin(Plugin):
    @property
    def name(self):
        return "Logger"

    def activate(self):
        print(f"   [{self.name}] Activated")

    def execute(self, data):
        print(f"   [{self.name}] Processing: {data}")

class ValidatorPlugin(Plugin):
    @property
    def name(self):
        return "Validator"

    def activate(self):
        print(f"   [{self.name}] Activated")

    def execute(self, data):
        is_valid = len(data) > 0
        print(f"   [{self.name}] Valid: {is_valid}")

# Plugin manager
plugins = [LoggerPlugin(), ValidatorPlugin()]
for plugin in plugins:
    plugin.activate()

for plugin in plugins:
    plugin.execute("test data")
