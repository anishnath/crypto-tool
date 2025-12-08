# Advanced Dataclass Features

print("=== Advanced Dataclass Features ===\n")

from dataclasses import dataclass, field, asdict, astuple

# 1. Ordering with order=True
print("1. Automatic ordering:")

@dataclass(order=True)
class Version:
    major: int
    minor: int
    patch: int

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"

versions = [
    Version(2, 0, 0),
    Version(1, 9, 5),
    Version(1, 10, 0),
    Version(2, 1, 0),
]

print(f"   Unsorted: {[str(v) for v in versions]}")
print(f"   Sorted: {[str(v) for v in sorted(versions)]}")
print()

# 2. Custom sort key with sort_index
print("2. Custom sort key:")

@dataclass(order=True)
class Student:
    sort_index: float = field(init=False, repr=False)
    name: str
    gpa: float

    def __post_init__(self):
        # Sort by GPA descending (negate for reverse)
        self.sort_index = -self.gpa

students = [
    Student("Alice", 3.8),
    Student("Bob", 3.5),
    Student("Charlie", 3.9),
]

print(f"   By GPA (descending): {[s.name for s in sorted(students)]}")
print()

# 3. Inheritance
print("3. Dataclass inheritance:")

@dataclass
class Animal:
    name: str
    age: int

@dataclass
class Dog(Animal):
    breed: str

    def bark(self):
        return f"{self.name} says Woof!"

dog = Dog("Buddy", 3, "Labrador")
print(f"   Dog: {dog}")
print(f"   {dog.bark()}")
print()

# 4. Converting to dict/tuple
print("4. Conversion utilities:")

@dataclass
class Config:
    host: str
    port: int
    debug: bool = False

config = Config("localhost", 8080, True)

# Convert to dictionary
config_dict = asdict(config)
print(f"   As dict: {config_dict}")

# Convert to tuple
config_tuple = astuple(config)
print(f"   As tuple: {config_tuple}")

# Create from dict (using unpacking)
new_config = Config(**config_dict)
print(f"   From dict: {new_config}")
print()

# 5. Slots for memory efficiency (Python 3.10+)
print("5. Using slots (Python 3.10+):")

@dataclass(slots=True)
class Coordinate:
    x: float
    y: float
    z: float

coord = Coordinate(1.0, 2.0, 3.0)
print(f"   Coordinate: {coord}")
print(f"   Has __slots__: {hasattr(Coordinate, '__slots__')}")
# Cannot add dynamic attributes with slots
try:
    coord.w = 4.0
except AttributeError as e:
    print(f"   Cannot add new attribute: {type(e).__name__}")
print()

# 6. kw_only for keyword-only arguments (Python 3.10+)
print("6. Keyword-only arguments (Python 3.10+):")

@dataclass(kw_only=True)
class DatabaseConfig:
    host: str
    port: int
    username: str
    password: str

# Must use keyword arguments
db = DatabaseConfig(host="localhost", port=5432, username="admin", password="secret")
print(f"   Config: DatabaseConfig(host='{db.host}', port={db.port}, ...)")
print()

# 7. Practical example: API response
print("7. Practical example - API Response:")

from typing import List, Optional
from datetime import datetime

@dataclass
class APIResponse:
    status: int
    data: dict = field(default_factory=dict)
    errors: List[str] = field(default_factory=list)
    timestamp: datetime = field(default_factory=datetime.now)
    request_id: Optional[str] = None

    @property
    def success(self) -> bool:
        return 200 <= self.status < 300

    def to_dict(self) -> dict:
        return {
            "status": self.status,
            "success": self.success,
            "data": self.data,
            "errors": self.errors,
            "timestamp": self.timestamp.isoformat(),
            "request_id": self.request_id
        }

response = APIResponse(200, {"user": "alice"}, request_id="abc-123")
print(f"   Success: {response.success}")
print(f"   Response dict keys: {list(response.to_dict().keys())}")
