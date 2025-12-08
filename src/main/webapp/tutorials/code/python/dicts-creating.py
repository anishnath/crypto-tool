# Creating Dictionaries in Python

# 1. Using curly braces with key:value pairs
print("=== Creating Dictionaries ===")
person = {
    "name": "Alice",
    "age": 30,
    "city": "New York"
}
print(f"Person dict: {person}")
print(f"Type: {type(person)}")
print()

# 2. Empty dictionary
print("=== Empty Dictionary ===")
empty = {}
also_empty = dict()
print(f"Empty dict: {empty}")
print(f"Using dict(): {also_empty}")
print()

# 3. Using dict() constructor
print("=== Using dict() Constructor ===")
# From keyword arguments
user = dict(name="Bob", age=25, active=True)
print(f"From kwargs: {user}")

# From list of tuples
pairs = [("a", 1), ("b", 2), ("c", 3)]
from_pairs = dict(pairs)
print(f"From tuples: {from_pairs}")

# From two lists using zip
keys = ["x", "y", "z"]
values = [10, 20, 30]
from_zip = dict(zip(keys, values))
print(f"From zip: {from_zip}")
print()

# 4. Keys can be any immutable type
print("=== Valid Key Types ===")
mixed_keys = {
    "string_key": 1,
    42: "integer key",
    (1, 2): "tuple key",
    3.14: "float key",
    True: "boolean key"
}
for k, v in mixed_keys.items():
    print(f"  {k!r}: {v}")
print()

# 5. Values can be anything
print("=== Values Can Be Anything ===")
complex_dict = {
    "list": [1, 2, 3],
    "dict": {"nested": "value"},
    "tuple": (4, 5, 6),
    "function": len,
    "none": None
}
print(f"List value: {complex_dict['list']}")
print(f"Nested dict: {complex_dict['dict']}")
print(f"Function value: {complex_dict['function']('hello')}")
print()

# 6. Dictionary properties
print("=== Dictionary Properties ===")
sample = {"a": 1, "b": 2, "c": 3}
print(f"Length: {len(sample)}")
print(f"Keys: {list(sample.keys())}")
print(f"Values: {list(sample.values())}")
print(f"Items: {list(sample.items())}")
