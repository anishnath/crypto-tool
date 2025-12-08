# Property Basics - The @property Decorator

print("=== @property Basics ===\n")

# 1. The problem with getter methods
print("1. Traditional getter methods are verbose:")

class CircleBad:
    def __init__(self, radius):
        self._radius = radius

    def get_radius(self):
        return self._radius

    def get_area(self):
        import math
        return math.pi * self._radius ** 2

c = CircleBad(5)
print(f"   radius: {c.get_radius()}")  # Verbose!
print(f"   area: {c.get_area()}")      # Verbose!
print()

# 2. Properties - access like attributes
print("2. Properties - cleaner attribute-like access:")

class Circle:
    def __init__(self, radius):
        self._radius = radius

    @property
    def radius(self):
        """Getter - called when you access circle.radius"""
        return self._radius

    @property
    def area(self):
        """Read-only computed property."""
        import math
        return math.pi * self._radius ** 2

c = Circle(5)
print(f"   radius: {c.radius}")  # Looks like an attribute!
print(f"   area: {c.area:.2f}")  # Computed on access!
print()

# 3. Properties under the hood
print("3. What @property does:")
print("""
   @property
   def radius(self):
       return self._radius

   Is equivalent to:

   def get_radius(self):
       return self._radius
   radius = property(get_radius)
""")

# 4. Read-only properties (getter only)
print("4. Read-only properties (no setter defined):")

class Employee:
    def __init__(self, first_name, last_name, salary):
        self._first_name = first_name
        self._last_name = last_name
        self._salary = salary

    @property
    def full_name(self):
        """Read-only: computed from first and last name."""
        return f"{self._first_name} {self._last_name}"

    @property
    def annual_salary(self):
        """Read-only: computed from monthly salary."""
        return self._salary * 12

emp = Employee("John", "Doe", 5000)
print(f"   full_name: {emp.full_name}")
print(f"   annual_salary: ${emp.annual_salary:,}")

# Try to set read-only property
try:
    emp.full_name = "Jane Doe"
except AttributeError as e:
    print(f"   Setting full_name failed: property 'full_name' has no setter")
print()

# 5. Why use properties?
print("5. Benefits of @property:")
print("""
   - Cleaner syntax: obj.value instead of obj.get_value()
   - Can add validation later without changing interface
   - Can create computed/derived attributes
   - Backward compatible: change implementation without API change
   - Pythonic: follows Python conventions
""")
