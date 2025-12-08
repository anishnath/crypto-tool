# Class Basics - Defining Classes and Creating Objects

print("=== Class Basics ===\n")

# 1. Simplest possible class
print("1. Empty class (placeholder):")

class Empty:
    pass  # 'pass' means do nothing - placeholder

obj = Empty()
print(f"   Created: {obj}")
print(f"   Type: {type(obj)}")
print()

# 2. Class with attributes
print("2. Class with attributes:")

class Dog:
    # Class attribute - shared by all instances
    species = "Canis familiaris"

    def __init__(self, name, age):
        # Instance attributes - unique to each object
        self.name = name
        self.age = age

# Create objects (instances)
buddy = Dog("Buddy", 3)
lucy = Dog("Lucy", 5)

print(f"   {buddy.name} is {buddy.age} years old")
print(f"   {lucy.name} is {lucy.age} years old")
print(f"   Both are {buddy.species}")  # Class attribute
print()

# 3. Objects are independent
print("3. Objects are independent:")
buddy.age = 4  # Modify one object
print(f"   Buddy's age: {buddy.age}")
print(f"   Lucy's age: {lucy.age}")  # Unchanged!
print()

# 4. Classes are blueprints
print("4. Classes are blueprints:")
print("""
   Class = Blueprint (template)
   Object = Instance (actual thing)

   class Dog:        <- The blueprint
       ...

   buddy = Dog(...)  <- An instance
   lucy = Dog(...)   <- Another instance
""")

# 5. Everything in Python is an object
print("5. Everything is an object:")
print(f"   Type of 42: {type(42)}")
print(f"   Type of 'hello': {type('hello')}")
print(f"   Type of [1,2,3]: {type([1, 2, 3])}")
print(f"   Type of Dog class: {type(Dog)}")
print()

# 6. Checking types
print("6. Type checking:")
print(f"   isinstance(buddy, Dog): {isinstance(buddy, Dog)}")
print(f"   isinstance('hello', str): {isinstance('hello', str)}")
print(f"   type(buddy) == Dog: {type(buddy) == Dog}")
