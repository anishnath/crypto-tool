# Inheritance Basics

print("=== Basic Inheritance ===\n")

# 1. Parent class (also called base class or superclass)
print("1. Parent class:")

class Animal:
    """Base class representing a generic animal."""

    def __init__(self, name):
        self.name = name

    def speak(self):
        return f"{self.name} makes a sound"

    def describe(self):
        return f"I am {self.name}"

# Create a parent class instance
generic = Animal("Generic")
print(f"   {generic.speak()}")
print(f"   {generic.describe()}")
print()

# 2. Child class (also called derived class or subclass)
print("2. Child classes inheriting from Animal:")

class Dog(Animal):
    """Dog inherits from Animal."""

    def speak(self):
        """Override parent method."""
        return f"{self.name} says: Woof!"

class Cat(Animal):
    """Cat inherits from Animal."""

    def speak(self):
        """Override parent method."""
        return f"{self.name} says: Meow!"

# Child classes automatically get parent's __init__ and describe()
dog = Dog("Buddy")
cat = Cat("Whiskers")

print(f"   {dog.speak()}")
print(f"   {dog.describe()}")  # Inherited from Animal
print(f"   {cat.speak()}")
print(f"   {cat.describe()}")  # Inherited from Animal
print()

# 3. isinstance() and issubclass()
print("3. Type checking with inheritance:")

print(f"   dog is Dog: {isinstance(dog, Dog)}")
print(f"   dog is Animal: {isinstance(dog, Animal)}")  # True - Dog inherits Animal
print(f"   cat is Dog: {isinstance(cat, Dog)}")

print(f"   Dog is subclass of Animal: {issubclass(Dog, Animal)}")
print(f"   Cat is subclass of Animal: {issubclass(Cat, Animal)}")
print(f"   Animal is subclass of Animal: {issubclass(Animal, Animal)}")  # True
print()

# 4. Inheritance chain
print("4. Inheritance chain (all classes inherit from object):")

print(f"   Dog MRO: {Dog.__mro__}")
print(f"   All Python classes inherit from 'object'")
print()

# 5. Adding new methods in child class
print("5. Child classes can add new methods:")

class Bird(Animal):
    """Bird with new method."""

    def speak(self):
        return f"{self.name} says: Tweet!"

    def fly(self):
        """New method only in Bird."""
        return f"{self.name} is flying!"

bird = Bird("Tweety")
print(f"   {bird.speak()}")
print(f"   {bird.fly()}")  # Only Bird has this
# print(dog.fly())  # Would raise AttributeError - Dog doesn't have fly()
