# Public Attributes and Methods

print("=== Public Access ===\n")

# 1. Public attributes - accessible from anywhere
print("1. Public attributes (no prefix):")

class Person:
    def __init__(self, name, age):
        self.name = name  # Public attribute
        self.age = age    # Public attribute

    def greet(self):  # Public method
        return f"Hello, I'm {self.name}!"

person = Person("Alice", 30)

# Directly access public attributes
print(f"   Name: {person.name}")
print(f"   Age: {person.age}")
print(f"   Greeting: {person.greet()}")

# Can modify directly
person.name = "Bob"
person.age = 25
print(f"   Modified: {person.name}, {person.age}")
print()

# 2. Problem with fully public attributes
print("2. The problem - no validation:")

class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius  # Public, no validation

temp = Temperature(25)
print(f"   Initial: {temp.celsius}°C")

# Anyone can set invalid values!
temp.celsius = -500  # Below absolute zero!
print(f"   Invalid value allowed: {temp.celsius}°C")
print()

# 3. When public is OK
print("3. When public attributes are fine:")
print("""
   Public attributes are appropriate when:
   - Simple data container (like namedtuple replacement)
   - No validation needed
   - Value can be any valid type
   - Internal implementation detail doesn't matter

   Example: Point(x, y), Rectangle(width, height)
""")

class Point:
    """Simple data container - public is fine."""
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def distance_from_origin(self):
        return (self.x ** 2 + self.y ** 2) ** 0.5

p = Point(3, 4)
print(f"   Point({p.x}, {p.y})")
print(f"   Distance: {p.distance_from_origin()}")
