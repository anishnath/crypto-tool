# The __init__ Method - Constructor

print("=== The __init__ Method ===\n")

# 1. Basic __init__
print("1. Basic __init__ (constructor):")

class Person:
    def __init__(self, name, age):
        print(f"   Creating Person: {name}")
        self.name = name
        self.age = age

alice = Person("Alice", 30)
print(f"   Created: {alice.name}, {alice.age}")
print()

# 2. self is the instance being created
print("2. Understanding 'self':")

class Counter:
    def __init__(self):
        print(f"   self is: {self}")
        self.count = 0

c1 = Counter()
c2 = Counter()
print(f"   c1 is: {c1}")
print(f"   c2 is: {c2}")
print("   Each 'self' refers to the instance being created!")
print()

# 3. Default parameter values
print("3. Default parameter values:")

class Rectangle:
    def __init__(self, width=1, height=1):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

r1 = Rectangle()           # Use defaults
r2 = Rectangle(5)          # width=5, height=default
r3 = Rectangle(4, 3)       # Both specified
r4 = Rectangle(height=10)  # Keyword argument

print(f"   r1 (defaults): {r1.width}x{r1.height} = {r1.area()}")
print(f"   r2 (width=5): {r2.width}x{r2.height} = {r2.area()}")
print(f"   r3 (4, 3): {r3.width}x{r3.height} = {r3.area()}")
print(f"   r4 (height=10): {r4.width}x{r4.height} = {r4.area()}")
print()

# 4. Validation in __init__
print("4. Validation in __init__:")

class BankAccount:
    def __init__(self, owner, balance=0):
        if not owner:
            raise ValueError("Owner name required")
        if balance < 0:
            raise ValueError("Initial balance cannot be negative")

        self.owner = owner
        self.balance = balance
        print(f"   Account created for {owner} with ${balance}")

account = BankAccount("Bob", 100)

try:
    bad_account = BankAccount("", 50)
except ValueError as e:
    print(f"   Error: {e}")
print()

# 5. __init__ returns None (always!)
print("5. __init__ returns None:")
print("""
   def __init__(self, name):
       self.name = name
       return self  # WRONG! Don't return from __init__

   # __init__ doesn't create the object - it initializes it
   # The object is created before __init__ runs
""")

# 6. Computing attributes in __init__
print("6. Computed attributes:")

class Circle:
    import math

    def __init__(self, radius):
        self.radius = radius
        # Computed once at creation
        self.diameter = radius * 2
        self.circumference = 2 * 3.14159 * radius

circle = Circle(5)
print(f"   Radius: {circle.radius}")
print(f"   Diameter: {circle.diameter}")
print(f"   Circumference: {circle.circumference:.2f}")
