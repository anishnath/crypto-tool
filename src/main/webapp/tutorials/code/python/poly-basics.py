# Polymorphism Basics

print("=== Polymorphism Basics ===\n")

# 1. What is polymorphism?
print("1. Same method name, different classes:")

class Dog:
    def speak(self):
        return "Woof!"

    def move(self):
        return "Running on 4 legs"

class Cat:
    def speak(self):
        return "Meow!"

    def move(self):
        return "Prowling silently"

class Bird:
    def speak(self):
        return "Tweet!"

    def move(self):
        return "Flying through the air"

# Different classes, same interface
animals = [Dog(), Cat(), Bird()]

for animal in animals:
    print(f"   {animal.__class__.__name__}: {animal.speak()}, {animal.move()}")
print()

# 2. Polymorphism enables flexible code
print("2. Write code that works with ANY object having the right methods:")

def make_it_speak(thing):
    """Works with ANY object that has a speak() method."""
    print(f"   {thing.speak()}")

# Works with all our animals
make_it_speak(Dog())
make_it_speak(Cat())
make_it_speak(Bird())

# Would also work with any new class we create!
class Robot:
    def speak(self):
        return "Beep boop!"

make_it_speak(Robot())  # Works!
print()

# 3. Polymorphism with built-in functions
print("3. Python's built-in polymorphism:")

# len() works with different types
print(f"   len('hello'): {len('hello')}")
print(f"   len([1, 2, 3]): {len([1, 2, 3])}")
print(f"   len({{'a': 1}}): {len({'a': 1})}")

# + operator is polymorphic
print(f"   2 + 3 = {2 + 3}")           # Addition
print(f"   'a' + 'b' = {'a' + 'b'}")   # Concatenation
print(f"   [1] + [2] = {[1] + [2]}")   # List concat
print()

# 4. Why polymorphism matters
print("4. Benefits of polymorphism:")
print("""
   - Write more generic, reusable code
   - Add new types without changing existing code
   - Focus on WHAT objects can do, not WHAT they are
   - Makes code more flexible and extensible
""")

# Example: A function that processes any "file-like" object
class StringBuffer:
    def __init__(self, data):
        self.data = data
        self.position = 0

    def read(self, n=-1):
        if n == -1:
            result = self.data[self.position:]
            self.position = len(self.data)
        else:
            result = self.data[self.position:self.position + n]
            self.position += n
        return result

def process_readable(source):
    """Works with any object that has read() method."""
    return source.read(5)

# Works with our custom class
buffer = StringBuffer("Hello, World!")
print(f"   Custom buffer: {process_readable(buffer)}")
