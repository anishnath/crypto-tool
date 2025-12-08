# Abstract Classes vs Duck Typing

print("=== Abstract Classes vs Duck Typing ===\n")

from abc import ABC, abstractmethod

# 1. Duck typing approach (no ABC)
print("1. Duck typing - no explicit interface:")

class DuckTypedDog:
    def speak(self):
        return "Woof!"

class DuckTypedCat:
    def speak(self):
        return "Meow!"

class DuckTypedRobot:
    def speak(self):
        return "Beep!"

def make_it_speak_duck(animal):
    """Works with anything that has speak() method."""
    print(f"   {animal.speak()}")

# Works with any object that has speak()
for obj in [DuckTypedDog(), DuckTypedCat(), DuckTypedRobot()]:
    make_it_speak_duck(obj)
print()

# 2. Abstract class approach
print("2. Abstract class - explicit interface:")

class Animal(ABC):
    @abstractmethod
    def speak(self):
        pass

class ABCDog(Animal):
    def speak(self):
        return "Woof!"

class ABCCat(Animal):
    def speak(self):
        return "Meow!"

# Robot doesn't inherit from Animal
class ABCRobot:
    def speak(self):
        return "Beep!"

def make_it_speak_abc(animal: Animal):
    """Type hint shows expected interface."""
    print(f"   {animal.speak()}")

for obj in [ABCDog(), ABCCat()]:
    make_it_speak_abc(obj)
# ABCRobot works too (Python doesn't enforce type hints)
# but it's clear it doesn't follow the Animal contract
print()

# 3. When to use each approach
print("3. When to use Abstract Classes:")
print("""
   USE ABC when:
   - Defining a formal API/contract
   - Working in a team that needs clear interfaces
   - Building a framework or library
   - Want compile-time-like errors for missing methods
   - Need abstract properties, not just methods
   - Using type checkers like mypy

   Example: Plugin systems, database drivers, payment processors
""")

print("4. When to use Duck Typing:")
print("""
   USE Duck Typing when:
   - Simple, informal interfaces
   - Working with built-in types (file-like, iterable)
   - Maximum flexibility needed
   - Following Python's "we're all consenting adults" philosophy
   - Objects from different libraries/sources

   Example: Anything with read(), anything with __iter__()
""")

# 4. Hybrid approach
print("5. Hybrid: Protocol (Python 3.8+):")
print("""
   from typing import Protocol

   class Speakable(Protocol):
       def speak(self) -> str: ...

   # Now you get:
   # - Type checking benefits
   # - No need to inherit from Protocol
   # - Best of both worlds!
""")

# 5. Practical comparison
print("6. Practical example:")

class FileWriter(ABC):
    """ABC for formal file writing interface."""

    @abstractmethod
    def write(self, data: str) -> None:
        pass

    @abstractmethod
    def close(self) -> None:
        pass

class CSVWriter(FileWriter):
    def __init__(self, filename):
        self.filename = filename
        self.buffer = []

    def write(self, data):
        self.buffer.append(data)
        print(f"   CSVWriter: wrote '{data}'")

    def close(self):
        print(f"   CSVWriter: saved {len(self.buffer)} rows to {self.filename}")

# Duck-typed version - no ABC needed
class SimpleLogger:
    """Follows same interface but doesn't inherit ABC."""
    def write(self, data):
        print(f"   SimpleLogger: {data}")

    def close(self):
        print("   SimpleLogger: closed")

def save_data(writer, data):
    """Works with any writer - ABC or duck-typed."""
    for item in data:
        writer.write(item)
    writer.close()

print("   Using ABC-based writer:")
save_data(CSVWriter("output.csv"), ["row1", "row2"])
print()
print("   Using duck-typed writer:")
save_data(SimpleLogger(), ["log1", "log2"])
