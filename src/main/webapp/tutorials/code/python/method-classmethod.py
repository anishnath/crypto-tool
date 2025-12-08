# Class Methods with @classmethod

print("=== Class Methods ===\n")

# 1. Basic class method
print("1. Basic class method:")

class Dog:
    species = "Canis familiaris"
    count = 0

    def __init__(self, name):
        self.name = name
        Dog.count += 1

    @classmethod
    def get_species(cls):
        """Class method - receives class as first parameter."""
        return cls.species

    @classmethod
    def get_count(cls):
        """Class method to get count."""
        return cls.count

# Can call on class itself (no instance needed)
print(f"   Species: {Dog.get_species()}")
print(f"   Count before: {Dog.get_count()}")

dog1 = Dog("Buddy")
dog2 = Dog("Lucy")

print(f"   Count after: {Dog.get_count()}")
print()

# 2. Alternative constructors (factory methods)
print("2. Alternative constructors:")

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    @classmethod
    def from_birth_year(cls, name, birth_year):
        """Create Person from birth year instead of age."""
        from datetime import datetime
        age = datetime.now().year - birth_year
        return cls(name, age)  # Creates new instance

    @classmethod
    def from_string(cls, person_string):
        """Create Person from 'name-age' string."""
        name, age = person_string.split('-')
        return cls(name, int(age))

# Different ways to create Person
p1 = Person("Alice", 30)
p2 = Person.from_birth_year("Bob", 1990)
p3 = Person.from_string("Charlie-25")

print(f"   p1: {p1.name}, {p1.age}")
print(f"   p2: {p2.name}, {p2.age}")
print(f"   p3: {p3.name}, {p3.age}")
print()

# 3. Class method with inheritance
print("3. Class methods and inheritance:")

class Animal:
    @classmethod
    def create(cls, name):
        """Factory method - creates correct type."""
        print(f"   Creating {cls.__name__}")
        return cls(name)

class Cat(Animal):
    def __init__(self, name):
        self.name = name

    def speak(self):
        return "Meow"

class Dog(Animal):
    def __init__(self, name):
        self.name = name

    def speak(self):
        return "Woof"

# cls is the actual class being called
cat = Cat.create("Whiskers")  # cls is Cat
dog = Dog.create("Rex")       # cls is Dog

print(f"   {cat.name} says {cat.speak()}")
print(f"   {dog.name} says {dog.speak()}")
print()

# 4. Managing class-level state
print("4. Managing class state:")

class Database:
    _instance = None
    _connected = False

    def __init__(self, connection_string):
        self.connection_string = connection_string

    @classmethod
    def connect(cls, connection_string):
        """Singleton-like pattern."""
        if cls._instance is None:
            cls._instance = cls(connection_string)
            cls._connected = True
            print(f"   Connected to: {connection_string}")
        return cls._instance

    @classmethod
    def is_connected(cls):
        return cls._connected

db1 = Database.connect("localhost:5432")
db2 = Database.connect("localhost:5432")  # Returns same instance

print(f"   Same instance? {db1 is db2}")
print(f"   Connected? {Database.is_connected()}")
print()

# 5. When to use class methods
print("5. When to use class methods:")
print("""
   Use @classmethod for:
   - Alternative constructors (from_string, from_dict)
   - Factory methods that return instances
   - Methods that need class info but not instance
   - Managing class-level state
   - Methods that should work with inheritance
""")
