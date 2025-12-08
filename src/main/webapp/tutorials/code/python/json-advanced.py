# Advanced JSON - Custom Types and Encoders

import json
from datetime import datetime, date
from decimal import Decimal

# 1. The problem: non-serializable types
print("=== Non-Serializable Types ===")
try:
    data = {"date": datetime.now()}
    json.dumps(data)
except TypeError as e:
    print(f"Error: {e}")
print()

# 2. Custom encoder class
print("=== Custom JSONEncoder ===")

class CustomEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        if isinstance(obj, date):
            return obj.strftime("%Y-%m-%d")
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, set):
            return list(obj)
        if isinstance(obj, bytes):
            return obj.decode("utf-8")
        return super().default(obj)

data = {
    "timestamp": datetime.now(),
    "date": date.today(),
    "price": Decimal("19.99"),
    "tags": {"python", "json", "tutorial"},
    "data": b"hello"
}

result = json.dumps(data, cls=CustomEncoder, indent=2)
print(result)
print()

# 3. Using default parameter for simple cases
print("=== Using default Parameter ===")
def serialize_special(obj):
    if isinstance(obj, datetime):
        return {"__datetime__": obj.isoformat()}
    if isinstance(obj, set):
        return {"__set__": list(obj)}
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")

data = {"when": datetime(2024, 1, 15, 10, 30)}
result = json.dumps(data, default=serialize_special)
print(result)
print()

# 4. Custom decoder with object_hook
print("=== Custom Decoder (object_hook) ===")
def deserialize_special(obj):
    if "__datetime__" in obj:
        return datetime.fromisoformat(obj["__datetime__"])
    if "__set__" in obj:
        return set(obj["__set__"])
    return obj

json_str = '{"when": {"__datetime__": "2024-01-15T10:30:00"}}'
result = json.loads(json_str, object_hook=deserialize_special)
print(f"Type: {type(result['when'])}")
print(f"Value: {result['when']}")
print()

# 5. Serializing objects with __dict__
print("=== Serializing Custom Objects ===")

class User:
    def __init__(self, name, email, role):
        self.name = name
        self.email = email
        self.role = role

user = User("Alice", "alice@example.com", "admin")

# Using __dict__
print(f"Using __dict__: {json.dumps(user.__dict__)}")

# Using vars()
print(f"Using vars(): {json.dumps(vars(user))}")
print()

# 6. dataclass with asdict
print("=== Dataclass Serialization ===")
from dataclasses import dataclass, asdict

@dataclass
class Product:
    id: int
    name: str
    price: float
    in_stock: bool

product = Product(1, "Widget", 9.99, True)
print(json.dumps(asdict(product), indent=2))
print()

# 7. Round-trip: Python -> JSON -> Python
print("=== Round-Trip with Custom Types ===")

class DateTimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return {"_type": "datetime", "value": obj.isoformat()}
        return super().default(obj)

def datetime_decoder(obj):
    if "_type" in obj and obj["_type"] == "datetime":
        return datetime.fromisoformat(obj["value"])
    return obj

# Encode
original = {"created": datetime(2024, 1, 15, 10, 30, 0)}
encoded = json.dumps(original, cls=DateTimeEncoder)
print(f"Encoded: {encoded}")

# Decode
decoded = json.loads(encoded, object_hook=datetime_decoder)
print(f"Decoded: {decoded}")
print(f"Same type: {type(original['created']) == type(decoded['created'])}")
