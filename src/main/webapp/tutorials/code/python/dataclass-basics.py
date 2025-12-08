# Dataclass Basics

print("=== Dataclass Basics ===\n")

from dataclasses import dataclass

# 1. Basic dataclass - no boilerplate needed!
print("1. Basic dataclass:")

@dataclass
class Product:
    name: str
    price: float
    quantity: int = 0  # Default value

# Auto-generated __init__
laptop = Product("Laptop", 999.99, 5)
mouse = Product("Mouse", 29.99)  # Uses default quantity=0

print(f"   {laptop}")
print(f"   {mouse}")
print()

# 2. Comparison with traditional class
print("2. Traditional class (lots of boilerplate):")

class TraditionalProduct:
    def __init__(self, name: str, price: float, quantity: int = 0):
        self.name = name
        self.price = price
        self.quantity = quantity

    def __repr__(self):
        return f"TraditionalProduct(name={self.name!r}, price={self.price}, quantity={self.quantity})"

    def __eq__(self, other):
        if not isinstance(other, TraditionalProduct):
            return NotImplemented
        return (self.name, self.price, self.quantity) == (other.name, other.price, other.quantity)

trad = TraditionalProduct("Keyboard", 79.99, 10)
print(f"   {trad}")
print("   (Required 15+ lines vs 4 lines with @dataclass)")
print()

# 3. Auto-generated __eq__
print("3. Auto-generated __eq__:")

p1 = Product("Phone", 699.99, 10)
p2 = Product("Phone", 699.99, 10)
p3 = Product("Phone", 699.99, 5)

print(f"   p1 == p2: {p1 == p2}")  # True - same values
print(f"   p1 == p3: {p1 == p3}")  # False - different quantity
print(f"   p1 is p2: {p1 is p2}")  # False - different objects
print()

# 4. Custom methods work normally
print("4. Custom methods in dataclasses:")

@dataclass
class Rectangle:
    width: float
    height: float

    def area(self):
        """Custom method - works as expected."""
        return self.width * self.height

    def perimeter(self):
        """Another custom method."""
        return 2 * (self.width + self.height)

rect = Rectangle(5.0, 3.0)
print(f"   Rectangle: {rect}")
print(f"   Area: {rect.area()}")
print(f"   Perimeter: {rect.perimeter()}")
print()

# 5. Type hints are required
print("5. Type hints are required (but not enforced at runtime):")

@dataclass
class User:
    name: str
    age: int
    email: str = ""

# Python doesn't enforce types at runtime
user = User("Alice", "thirty", 12345)  # Works! But not recommended
print(f"   User with wrong types: {user}")
print("   Note: Use type checkers like mypy for type enforcement")
