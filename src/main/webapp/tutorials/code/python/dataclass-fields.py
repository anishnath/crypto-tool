# Dataclass Fields

print("=== Dataclass Fields ===\n")

from dataclasses import dataclass, field
from typing import List

# 1. Default values must come after non-defaults
print("1. Field ordering rules:")

@dataclass
class Person:
    # Required fields first (no defaults)
    name: str
    age: int
    # Optional fields last (with defaults)
    email: str = ""
    active: bool = True

person = Person("Alice", 30)
print(f"   {person}")
print()

# 2. Mutable default values - use field(default_factory=...)
print("2. Mutable defaults with default_factory:")

# WRONG way (causes shared mutable default):
# @dataclass
# class WrongInventory:
#     items: list = []  # This would raise ValueError!

# CORRECT way:
@dataclass
class Inventory:
    name: str
    items: List[str] = field(default_factory=list)  # Each instance gets new list

inv1 = Inventory("Warehouse A")
inv2 = Inventory("Warehouse B")

inv1.items.append("Widget")
inv2.items.append("Gadget")

print(f"   inv1: {inv1}")
print(f"   inv2: {inv2}")
print("   Each instance has its own list!")
print()

# 3. Field options
print("3. Field options:")

@dataclass
class Employee:
    name: str
    employee_id: int
    # Don't include in repr
    password: str = field(repr=False)
    # Don't include in comparisons
    login_count: int = field(default=0, compare=False)
    # Don't include in __init__ (computed field)
    display_name: str = field(init=False)

    def __post_init__(self):
        self.display_name = f"{self.name} (ID: {self.employee_id})"

e1 = Employee("Alice", 1001, "secret123")
e2 = Employee("Alice", 1001, "different_pwd")

print(f"   {e1}")  # password hidden in repr
print(f"   Display name: {e1.display_name}")
print(f"   e1 == e2: {e1 == e2}")  # True! password and login_count not compared
print()

# 4. field() with default_factory for complex defaults
print("4. Complex default values:")

from datetime import datetime

@dataclass
class LogEntry:
    message: str
    level: str = "INFO"
    timestamp: datetime = field(default_factory=datetime.now)
    tags: List[str] = field(default_factory=list)
    metadata: dict = field(default_factory=dict)

log1 = LogEntry("Server started")
log2 = LogEntry("Error occurred", level="ERROR", tags=["critical"])

print(f"   Log 1: {log1.message} at {log1.timestamp}")
print(f"   Log 2: {log2.message} [{log2.level}] {log2.tags}")
print()

# 5. Metadata for custom processing
print("5. Field metadata:")

@dataclass
class Product:
    name: str = field(metadata={"db_column": "product_name"})
    price: float = field(metadata={"db_column": "unit_price", "currency": "USD"})
    quantity: int = field(default=0, metadata={"db_column": "stock_qty"})

from dataclasses import fields

product = Product("Widget", 9.99, 100)
print("   Field metadata:")
for f in fields(product):
    print(f"   - {f.name}: {f.metadata}")
