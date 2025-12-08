# Instance vs Class Attributes

print("=== Instance vs Class Attributes ===\n")

# 1. Class attributes - shared by all instances
print("1. Class attributes (shared):")

class Dog:
    # Class attribute - defined outside __init__
    species = "Canis familiaris"
    count = 0  # Track number of dogs

    def __init__(self, name):
        self.name = name  # Instance attribute
        Dog.count += 1    # Modify class attribute

dog1 = Dog("Buddy")
dog2 = Dog("Lucy")
dog3 = Dog("Max")

print(f"   Total dogs created: {Dog.count}")
print(f"   All dogs are: {Dog.species}")
print(f"   dog1.species: {dog1.species}")  # Access via instance
print()

# 2. Instance attributes - unique per object
print("2. Instance attributes (unique):")

class Person:
    def __init__(self, name, age):
        self.name = name  # Instance attribute
        self.age = age    # Instance attribute

p1 = Person("Alice", 30)
p2 = Person("Bob", 25)

p1.age = 31  # Modify only p1
print(f"   p1: {p1.name}, {p1.age}")
print(f"   p2: {p2.name}, {p2.age}")  # Unchanged
print()

# 3. The shadowing trap
print("3. The shadowing trap:")

class Counter:
    value = 0  # Class attribute

c1 = Counter()
c2 = Counter()

print(f"   Initial - c1.value: {c1.value}, c2.value: {c2.value}")

# This creates an INSTANCE attribute, shadows class attribute!
c1.value = 10
print(f"   After c1.value = 10:")
print(f"   c1.value: {c1.value}")  # Instance attribute
print(f"   c2.value: {c2.value}")  # Still class attribute
print(f"   Counter.value: {Counter.value}")  # Class attribute unchanged!
print()

# 4. Mutable class attribute trap
print("4. Mutable class attribute trap:")

class BadStudent:
    grades = []  # DANGER! Shared mutable!

    def __init__(self, name):
        self.name = name

    def add_grade(self, grade):
        self.grades.append(grade)

s1 = BadStudent("Alice")
s2 = BadStudent("Bob")

s1.add_grade(90)
s2.add_grade(85)

print(f"   s1's grades: {s1.grades}")  # Has both!
print(f"   s2's grades: {s2.grades}")  # Has both!
print("   OOPS! They share the same list!")
print()

# 5. Correct way - mutable instance attributes
print("5. Correct way - instance attributes:")

class GoodStudent:
    def __init__(self, name):
        self.name = name
        self.grades = []  # Each student gets own list

    def add_grade(self, grade):
        self.grades.append(grade)

s1 = GoodStudent("Alice")
s2 = GoodStudent("Bob")

s1.add_grade(90)
s2.add_grade(85)

print(f"   s1's grades: {s1.grades}")
print(f"   s2's grades: {s2.grades}")
print("   Each has their own list!")
print()

# 6. When to use class attributes
print("6. When to use class attributes:")
print("""
   Class attributes are good for:
   - Constants: MAX_SIZE = 100
   - Counters: instance_count = 0
   - Default values (immutable): default_color = "blue"

   Always use instance attributes for:
   - Data unique to each object
   - Mutable data (lists, dicts)
   - Anything that changes per instance
""")
