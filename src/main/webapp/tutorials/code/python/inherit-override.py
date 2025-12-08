# Method Overriding

print("=== Method Overriding ===\n")

# 1. Basic method overriding
print("1. Basic overriding - replace parent method:")

class Shape:
    def area(self):
        return 0

    def describe(self):
        return "I am a shape"

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        """Override: Replace parent's area method completely."""
        return self.width * self.height

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        """Override: Different calculation for circles."""
        import math
        return math.pi * self.radius ** 2

rect = Rectangle(5, 3)
circle = Circle(4)

print(f"   Rectangle area: {rect.area()}")
print(f"   Circle area: {circle.area():.2f}")
print(f"   Rectangle describe: {rect.describe()}")  # Inherited, not overridden
print()

# 2. Extending vs replacing methods
print("2. Extending vs Replacing:")

class Logger:
    def log(self, message):
        print(f"   LOG: {message}")

class TimestampLogger(Logger):
    def log(self, message):
        """Replace: Completely new implementation."""
        from datetime import datetime
        timestamp = datetime.now().strftime("%H:%M:%S")
        print(f"   [{timestamp}] {message}")

class PrefixLogger(Logger):
    def __init__(self, prefix):
        self.prefix = prefix

    def log(self, message):
        """Extend: Add prefix, then use parent."""
        prefixed = f"{self.prefix}: {message}"
        super().log(prefixed)

basic = Logger()
ts_logger = TimestampLogger()
prefix_logger = PrefixLogger("ERROR")

basic.log("Basic message")
ts_logger.log("With timestamp")
prefix_logger.log("Extended message")
print()

# 3. Calling parent method from override
print("3. Calling parent from override:")

class Vehicle:
    def __init__(self, brand):
        self.brand = brand

    def start(self):
        return f"{self.brand} engine starting..."

class ElectricCar(Vehicle):
    def __init__(self, brand, battery_capacity):
        super().__init__(brand)
        self.battery_capacity = battery_capacity

    def start(self):
        # First do parent's start, then add our own behavior
        parent_start = super().start()
        return f"{parent_start} Battery at {self.battery_capacity}%"

car = ElectricCar("Tesla", 85)
print(f"   {car.start()}")
print()

# 4. Override with different signature
print("4. Override can change method signature:")

class BaseNotifier:
    def notify(self, message):
        print(f"   Notification: {message}")

class EmailNotifier(BaseNotifier):
    def notify(self, message, recipient="user@example.com"):
        """Override with additional optional parameter."""
        print(f"   Emailing to {recipient}: {message}")

class SlackNotifier(BaseNotifier):
    def notify(self, message, channel="#general"):
        """Override with different default."""
        print(f"   Slack {channel}: {message}")

email = EmailNotifier()
slack = SlackNotifier()

email.notify("Hello!")
email.notify("Important!", "admin@example.com")
slack.notify("Team update", "#engineering")
print()

# 5. Preventing override (convention)
print("5. Convention: Use underscore to indicate 'private':")

class BankAccount:
    def __init__(self, balance):
        self._balance = balance  # Protected by convention

    def _validate_amount(self, amount):
        """Method that probably shouldn't be overridden."""
        return amount > 0

    def deposit(self, amount):
        if self._validate_amount(amount):
            self._balance += amount
            return True
        return False

print("   _method means: 'please don't override unless you know what you're doing'")
print("   Python doesn't enforce this, but it's a strong convention")
