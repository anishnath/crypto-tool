# Comparison Methods: __eq__, __lt__, __gt__, etc.

print("=== Comparison Methods ===\n")

# 1. __eq__ - equality (==)
print("1. __eq__ for equality (==):")

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other):
        """Compare equality based on coordinates."""
        if not isinstance(other, Point):
            return NotImplemented
        return self.x == other.x and self.y == other.y

    def __repr__(self):
        return f"Point({self.x}, {self.y})"

p1 = Point(3, 4)
p2 = Point(3, 4)
p3 = Point(5, 6)

print(f"   p1 == p2: {p1 == p2}")  # True (same coordinates)
print(f"   p1 == p3: {p1 == p3}")  # False
print(f"   p1 is p2: {p1 is p2}")  # False (different objects)
print()

# 2. __lt__ and __gt__ - less than, greater than
print("2. __lt__ for sorting (<, >, sorted()):")

class Student:
    def __init__(self, name, grade):
        self.name = name
        self.grade = grade

    def __lt__(self, other):
        """Compare by grade."""
        return self.grade < other.grade

    def __eq__(self, other):
        return self.grade == other.grade

    def __repr__(self):
        return f"{self.name}:{self.grade}"

students = [
    Student("Alice", 85),
    Student("Bob", 92),
    Student("Carol", 78)
]

print(f"   Unsorted: {students}")
print(f"   Sorted: {sorted(students)}")  # Uses __lt__
print(f"   Max: {max(students)}")        # Uses __lt__
print()

# 3. Using functools.total_ordering
print("3. @total_ordering - define only __eq__ and __lt__:")

from functools import total_ordering

@total_ordering
class Version:
    """Only define __eq__ and __lt__, get the rest free!"""

    def __init__(self, major, minor, patch):
        self.major = major
        self.minor = minor
        self.patch = patch

    def __eq__(self, other):
        return (self.major, self.minor, self.patch) == \
               (other.major, other.minor, other.patch)

    def __lt__(self, other):
        return (self.major, self.minor, self.patch) < \
               (other.major, other.minor, other.patch)

    def __repr__(self):
        return f"v{self.major}.{self.minor}.{self.patch}"

v1 = Version(1, 0, 0)
v2 = Version(1, 2, 0)
v3 = Version(2, 0, 0)

print(f"   {v1} < {v2}: {v1 < v2}")   # True
print(f"   {v1} <= {v2}: {v1 <= v2}") # True (from @total_ordering)
print(f"   {v3} > {v2}: {v3 > v2}")   # True (from @total_ordering)
print(f"   {v2} >= {v1}: {v2 >= v1}") # True (from @total_ordering)
print()

# 4. __hash__ - for use in sets and dict keys
print("4. __hash__ - required for sets/dict keys:")

class Color:
    def __init__(self, r, g, b):
        self.r = r
        self.g = g
        self.b = b

    def __eq__(self, other):
        return (self.r, self.g, self.b) == (other.r, other.g, other.b)

    def __hash__(self):
        """Must be consistent with __eq__."""
        return hash((self.r, self.g, self.b))

    def __repr__(self):
        return f"RGB({self.r},{self.g},{self.b})"

# Now can use in sets and as dict keys!
colors = {Color(255, 0, 0), Color(0, 255, 0), Color(255, 0, 0)}
print(f"   Color set: {colors}")  # Duplicates removed!

color_names = {Color(255, 0, 0): "Red", Color(0, 255, 0): "Green"}
print(f"   Color names: {color_names}")
print()

# 5. Important rules
print("5. Important rules:")
print("""
   - If you define __eq__, also define __hash__ (or set __hash__ = None)
   - Objects that compare equal MUST have the same hash
   - Mutable objects shouldn't be hashable (can't be dict keys)
   - Use @total_ordering to avoid implementing all 6 comparison methods
""")
