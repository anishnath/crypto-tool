# Frozen Dataclasses and __post_init__

print("=== Frozen Dataclasses & __post_init__ ===\n")

from dataclasses import dataclass, field

# 1. Frozen (immutable) dataclasses
print("1. Frozen dataclasses:")

@dataclass(frozen=True)
class Point:
    x: float
    y: float

p = Point(3.0, 4.0)
print(f"   Point: {p}")

# Attempting to modify raises FrozenInstanceError
try:
    p.x = 5.0
except Exception as e:
    print(f"   Cannot modify: {type(e).__name__}")
print()

# 2. Frozen dataclasses are hashable (can be dict keys, set members)
print("2. Frozen dataclasses are hashable:")

@dataclass(frozen=True)
class Color:
    r: int
    g: int
    b: int

# Use as dictionary keys
color_names = {
    Color(255, 0, 0): "Red",
    Color(0, 255, 0): "Green",
    Color(0, 0, 255): "Blue"
}

print(f"   Color(255, 0, 0) = {color_names[Color(255, 0, 0)]}")
print(f"   Colors in set: {len(set([Color(255, 0, 0), Color(255, 0, 0), Color(0, 255, 0)]))}")
print()

# 3. __post_init__ for computed fields
print("3. __post_init__ for computed values:")

@dataclass
class Rectangle:
    width: float
    height: float
    area: float = field(init=False)
    perimeter: float = field(init=False)

    def __post_init__(self):
        self.area = self.width * self.height
        self.perimeter = 2 * (self.width + self.height)

rect = Rectangle(5.0, 3.0)
print(f"   Rectangle: {rect}")
print()

# 4. __post_init__ for validation
print("4. Validation in __post_init__:")

@dataclass
class Temperature:
    celsius: float

    def __post_init__(self):
        if self.celsius < -273.15:
            raise ValueError(f"Temperature {self.celsius}°C is below absolute zero!")

temp = Temperature(25.0)
print(f"   Valid: {temp}")

try:
    invalid = Temperature(-300)
except ValueError as e:
    print(f"   Invalid: {e}")
print()

# 5. __post_init__ with InitVar for init-only variables
print("5. InitVar for init-only variables:")

from dataclasses import InitVar

@dataclass
class User:
    name: str
    password: InitVar[str]  # Passed to __init__ but NOT stored
    password_hash: str = field(init=False)

    def __post_init__(self, password):
        # Hash the password (simplified)
        self.password_hash = f"hash_{len(password)}_{password[:2]}***"

user = User("alice", "secret123")
print(f"   User: {user}")
print(f"   Has 'password' attribute: {hasattr(user, 'password')}")  # False!
print(f"   Has 'password_hash' attribute: {hasattr(user, 'password_hash')}")  # True
print()

# 6. Frozen with __post_init__
print("6. Frozen dataclass with computed fields:")

@dataclass(frozen=True)
class Vector:
    x: float
    y: float
    magnitude: float = field(init=False)

    def __post_init__(self):
        # For frozen, use object.__setattr__ in __post_init__
        object.__setattr__(self, 'magnitude', (self.x**2 + self.y**2)**0.5)

v = Vector(3.0, 4.0)
print(f"   Vector: {v}")
print(f"   Magnitude: {v.magnitude}")  # 5.0 (3-4-5 triangle)
