# String Representation: __str__ and __repr__

print("=== __str__ and __repr__ ===\n")

# 1. The problem without them
print("1. Without __str__ or __repr__:")

class PointBad:
    def __init__(self, x, y):
        self.x = x
        self.y = y

p = PointBad(3, 4)
print(f"   print(p): {p}")  # Ugly: <__main__.PointBad object at 0x...>
print()

# 2. __str__ - for users
print("2. __str__ - human-readable output:")

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        """User-friendly string representation."""
        return f"({self.x}, {self.y})"

p = Point(3, 4)
print(f"   print(p): {p}")           # Calls __str__
print(f"   str(p): {str(p)}")        # Calls __str__
print(f"   f-string: Point is {p}")  # Calls __str__
print()

# 3. __repr__ - for developers
print("3. __repr__ - developer/debugging output:")

class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        """Developer-friendly, ideally valid Python code."""
        return f"Vector({self.x}, {self.y})"

v = Vector(3, 4)
print(f"   repr(v): {repr(v)}")
print(f"   In list: {[v]}")  # Lists use __repr__ for items
print()

# 4. Both __str__ and __repr__
print("4. Best practice - implement both:")

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __str__(self):
        """For end users - nice and readable."""
        return f"{self.name}, {self.age} years old"

    def __repr__(self):
        """For developers - shows how to recreate."""
        return f"Person('{self.name}', {self.age})"

alice = Person("Alice", 30)
print(f"   str:  {str(alice)}")    # Alice, 30 years old
print(f"   repr: {repr(alice)}")   # Person('Alice', 30)
print(f"   In list: {[alice]}")    # Uses repr
print()

# 5. The golden rule for __repr__
print("5. The golden rule:")
print("""
   __repr__ should ideally be valid Python code that recreates the object:

   >>> p = Person('Bob', 25)
   >>> repr(p)
   "Person('Bob', 25)"
   >>> eval(repr(p))  # Recreates the object!
   Person('Bob', 25)
""")

# 6. If only __repr__ is defined
print("6. If only __repr__ is defined:")

class Book:
    def __init__(self, title):
        self.title = title

    def __repr__(self):
        return f"Book('{self.title}')"
    # No __str__ defined!

book = Book("Python Guide")
print(f"   str(book): {str(book)}")   # Falls back to __repr__
print(f"   repr(book): {repr(book)}")
print()
print("   Tip: If you only implement one, implement __repr__!")
print("   Python uses __repr__ as fallback for __str__")
