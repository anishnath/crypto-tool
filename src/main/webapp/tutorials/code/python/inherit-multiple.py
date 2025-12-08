# Multiple Inheritance

print("=== Multiple Inheritance ===\n")

# 1. Basic multiple inheritance
print("1. Basic multiple inheritance:")

class Flyable:
    def fly(self):
        return "Flying through the air!"

class Swimmable:
    def swim(self):
        return "Swimming through water!"

class Duck(Flyable, Swimmable):
    """Duck inherits from both Flyable and Swimmable."""

    def quack(self):
        return "Quack!"

duck = Duck()
print(f"   {duck.fly()}")    # From Flyable
print(f"   {duck.swim()}")   # From Swimmable
print(f"   {duck.quack()}")  # Duck's own method
print()

# 2. The diamond problem and MRO
print("2. Method Resolution Order (MRO):")

class A:
    def method(self):
        return "A"

class B(A):
    def method(self):
        return "B"

class C(A):
    def method(self):
        return "C"

class D(B, C):
    pass

d = D()
print(f"   d.method() returns: '{d.method()}'")  # Returns 'B'
print(f"   MRO: {[cls.__name__ for cls in D.__mro__]}")
print("   Python uses C3 linearization to determine order")
print()

# 3. super() with multiple inheritance
print("3. super() follows MRO:")

class A:
    def greet(self):
        return "A"

class B(A):
    def greet(self):
        return f"B -> {super().greet()}"

class C(A):
    def greet(self):
        return f"C -> {super().greet()}"

class D(B, C):
    def greet(self):
        return f"D -> {super().greet()}"

d = D()
print(f"   d.greet(): {d.greet()}")
print("   Call chain: D -> B -> C -> A (follows MRO!)")
print()

# 4. Mixins - practical multiple inheritance
print("4. Mixins pattern:")

class JSONMixin:
    """Mixin that adds JSON serialization."""
    def to_json(self):
        import json
        return json.dumps(self.__dict__)

class LogMixin:
    """Mixin that adds logging capability."""
    def log(self, message):
        print(f"   [{self.__class__.__name__}] {message}")

class User(JSONMixin, LogMixin):
    def __init__(self, name, email):
        self.name = name
        self.email = email

user = User("Alice", "alice@example.com")
print(f"   JSON: {user.to_json()}")
user.log("User created successfully")
print()

# 5. When to use multiple inheritance
print("5. Multiple inheritance best practices:")
print("""
   USE for:
   - Mixins (small, focused functionality)
   - Interface-like classes (only methods, no __init__)
   - Composition of orthogonal features

   AVOID when:
   - Classes have complex __init__ logic
   - There are conflicting method names
   - Inheritance hierarchy gets confusing

   Alternative: Composition over inheritance
""")

# Example of composition alternative
print("6. Alternative - Composition:")

class Engine:
    def start(self):
        return "Engine started"

class Wheels:
    def __init__(self, count):
        self.count = count

    def roll(self):
        return f"Rolling on {self.count} wheels"

class Car:
    """Uses composition instead of multiple inheritance."""
    def __init__(self):
        self.engine = Engine()    # Has an engine
        self.wheels = Wheels(4)   # Has wheels

    def drive(self):
        return f"{self.engine.start()}... {self.wheels.roll()}"

car = Car()
print(f"   {car.drive()}")
