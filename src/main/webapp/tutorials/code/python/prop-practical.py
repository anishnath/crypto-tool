# Practical Property Patterns

print("=== Practical Property Patterns ===\n")

# 1. Backward compatible refactoring
print("1. Refactoring without breaking API:")

# BEFORE: Direct attribute access
class PersonOld:
    def __init__(self, name):
        self.name = name  # Public attribute

# AFTER: Add validation without changing interface
class Person:
    def __init__(self, name):
        self._name = None
        self.name = name  # Uses setter

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        if not value or not value.strip():
            raise ValueError("Name cannot be empty")
        self._name = value.strip().title()

# Same API, but now with validation!
p = Person("  alice  ")
print(f"   Name: '{p.name}'")  # Cleaned: 'Alice'
print()

# 2. Dependent properties
print("2. Dependent properties (circle example):")

import math

class Circle:
    def __init__(self, radius):
        self._radius = radius

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value <= 0:
            raise ValueError("Radius must be positive")
        self._radius = value

    @property
    def diameter(self):
        """diameter = 2 * radius"""
        return self._radius * 2

    @diameter.setter
    def diameter(self, value):
        """Setting diameter updates radius."""
        self.radius = value / 2  # Uses radius setter for validation

    @property
    def area(self):
        return math.pi * self._radius ** 2

    @property
    def circumference(self):
        return 2 * math.pi * self._radius

c = Circle(5)
print(f"   radius={c.radius}, diameter={c.diameter}")
print(f"   area={c.area:.2f}, circumference={c.circumference:.2f}")

c.diameter = 20  # Set via diameter
print(f"   After diameter=20: radius={c.radius}")
print()

# 3. Property for lazy database loading
print("3. Lazy loading pattern:")

class User:
    def __init__(self, user_id):
        self.user_id = user_id
        self._profile = None  # Not loaded yet

    @property
    def profile(self):
        """Load profile only when needed."""
        if self._profile is None:
            print(f"   Loading profile for user {self.user_id}...")
            # Simulate database fetch
            self._profile = {"name": "Alice", "email": "alice@example.com"}
        return self._profile

user = User(123)
print(f"   User ID: {user.user_id}")
print(f"   Profile: {user.profile}")  # Loads now
print(f"   Profile again: {user.profile}")  # Uses cache
print()

# 4. Read-only after initialization
print("4. Write-once property (immutable after init):")

class Config:
    def __init__(self, api_key):
        self._api_key = api_key
        self._initialized = True

    @property
    def api_key(self):
        return self._api_key

    @api_key.setter
    def api_key(self, value):
        if hasattr(self, '_initialized'):
            raise AttributeError("api_key is read-only after initialization")
        self._api_key = value

config = Config("secret-key-123")
print(f"   API Key: {config.api_key}")

try:
    config.api_key = "new-key"
except AttributeError as e:
    print(f"   Cannot change: {e}")
print()

# 5. Property with logging/tracking
print("5. Property with access logging:")

class TrackedValue:
    def __init__(self, initial):
        self._value = initial
        self._access_count = 0
        self._change_count = 0

    @property
    def value(self):
        self._access_count += 1
        return self._value

    @value.setter
    def value(self, new_value):
        self._change_count += 1
        self._value = new_value

    @property
    def stats(self):
        return f"Accessed {self._access_count}x, Changed {self._change_count}x"

t = TrackedValue(100)
_ = t.value  # Access
_ = t.value  # Access
t.value = 200  # Change
_ = t.value  # Access
print(f"   Current value: {t.value}")
print(f"   Stats: {t.stats}")
