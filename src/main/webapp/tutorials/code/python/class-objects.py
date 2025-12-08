# Working with Objects

print("=== Working with Objects ===\n")

# 1. Creating and using objects
print("1. Creating and using objects:")

class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages
        self.current_page = 0

    def read(self, num_pages):
        self.current_page = min(self.current_page + num_pages, self.pages)
        return self.current_page

    def progress(self):
        return f"{self.current_page}/{self.pages} pages"

book = Book("Python Guide", "Alice", 300)
print(f"   Reading: {book.title} by {book.author}")
book.read(50)
print(f"   Progress: {book.progress()}")
book.read(100)
print(f"   Progress: {book.progress()}")
print()

# 2. Object identity vs equality
print("2. Identity vs Equality:")

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

p1 = Point(1, 2)
p2 = Point(1, 2)
p3 = p1  # Same object!

print(f"   p1 == p2: {p1 == p2}")  # False - different objects
print(f"   p1 is p2: {p1 is p2}")  # False - different objects
print(f"   p1 is p3: {p1 is p3}")  # True - same object
print(f"   id(p1): {id(p1)}")
print(f"   id(p2): {id(p2)}")
print(f"   id(p3): {id(p3)}")  # Same as p1
print()

# 3. Objects are mutable
print("3. Objects are mutable:")

class Container:
    def __init__(self, value):
        self.value = value

def modify(obj):
    obj.value = "modified"

c = Container("original")
print(f"   Before: {c.value}")
modify(c)  # Passes reference - modifies original!
print(f"   After: {c.value}")
print()

# 4. Adding attributes dynamically
print("4. Dynamic attributes:")

class Flexible:
    pass

obj = Flexible()
obj.name = "Dynamic"     # Add attribute
obj.count = 42           # Add another
obj.data = [1, 2, 3]     # And another

print(f"   obj.name: {obj.name}")
print(f"   obj.count: {obj.count}")
print(f"   obj.data: {obj.data}")
print(f"   __dict__: {obj.__dict__}")  # All attributes
print()

# 5. Checking attributes
print("5. Checking attributes:")

class Person:
    def __init__(self, name):
        self.name = name

p = Person("Alice")
p.age = 30  # Added dynamically

print(f"   hasattr(p, 'name'): {hasattr(p, 'name')}")
print(f"   hasattr(p, 'age'): {hasattr(p, 'age')}")
print(f"   hasattr(p, 'email'): {hasattr(p, 'email')}")
print(f"   getattr(p, 'name'): {getattr(p, 'name')}")
print(f"   getattr(p, 'email', 'N/A'): {getattr(p, 'email', 'N/A')}")
print()

# 6. Objects in collections
print("6. Objects in collections:")

class Task:
    def __init__(self, name, priority):
        self.name = name
        self.priority = priority
        self.done = False

    def complete(self):
        self.done = True

tasks = [
    Task("Write code", 1),
    Task("Test code", 2),
    Task("Deploy", 3),
]

# Work with objects in list
tasks[0].complete()
for task in tasks:
    status = "DONE" if task.done else "TODO"
    print(f"   [{status}] {task.name} (priority: {task.priority})")
