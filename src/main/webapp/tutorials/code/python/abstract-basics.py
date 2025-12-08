# Abstract Class Basics

print("=== Abstract Class Basics ===\n")

from abc import ABC, abstractmethod

# 1. Defining an abstract class
print("1. Abstract class with ABC:")

class Animal(ABC):
    """Abstract base class - cannot be instantiated."""

    def __init__(self, name):
        self.name = name

    @abstractmethod
    def speak(self):
        """Subclasses MUST implement this method."""
        pass

    @abstractmethod
    def move(self):
        """Another abstract method."""
        pass

    def describe(self):
        """Concrete method - inherited by subclasses."""
        return f"I am {self.name}"

# Try to instantiate abstract class
try:
    animal = Animal("Generic")
except TypeError as e:
    print(f"   Cannot instantiate Animal: {e}")
print()

# 2. Implementing abstract methods
print("2. Concrete classes implementing abstract methods:")

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

    def move(self):
        return f"{self.name} runs on four legs"

class Bird(Animal):
    def speak(self):
        return f"{self.name} says Tweet!"

    def move(self):
        return f"{self.name} flies through the air"

# These can be instantiated - all abstract methods implemented
dog = Dog("Buddy")
bird = Bird("Tweety")

print(f"   {dog.describe()}")
print(f"   {dog.speak()}")
print(f"   {dog.move()}")
print()
print(f"   {bird.describe()}")
print(f"   {bird.speak()}")
print()

# 3. Incomplete implementation fails
print("3. Must implement ALL abstract methods:")

class Fish(Animal):
    def speak(self):
        return f"{self.name} bubbles"
    # Missing move() method!

try:
    fish = Fish("Nemo")
except TypeError as e:
    print(f"   Cannot instantiate Fish: incomplete implementation")
print()

# 4. Abstract classes can have concrete methods
print("4. Mix of abstract and concrete methods:")

class Shape(ABC):
    def __init__(self, color):
        self.color = color

    @abstractmethod
    def area(self):
        """Must implement."""
        pass

    @abstractmethod
    def perimeter(self):
        """Must implement."""
        pass

    def describe(self):
        """Concrete method - uses abstract methods."""
        return f"A {self.color} shape with area {self.area():.2f}"

class Circle(Shape):
    def __init__(self, color, radius):
        super().__init__(color)
        self.radius = radius

    def area(self):
        import math
        return math.pi * self.radius ** 2

    def perimeter(self):
        import math
        return 2 * math.pi * self.radius

circle = Circle("red", 5)
print(f"   {circle.describe()}")
print(f"   Perimeter: {circle.perimeter():.2f}")
