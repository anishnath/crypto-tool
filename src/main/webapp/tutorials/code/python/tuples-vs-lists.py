# Tuples vs Lists - When to Use Which

# Key Difference: Tuples are IMMUTABLE

# 1. Immutability demonstration
print("=== Immutability ===")
my_list = [1, 2, 3]
my_tuple = (1, 2, 3)

my_list[0] = 100  # Works fine
print(f"Modified list: {my_list}")

# my_tuple[0] = 100  # TypeError: 'tuple' object does not support item assignment
print("Tuples cannot be modified after creation!")
print()

# 2. Tuples as dictionary keys (lists can't!)
print("=== Dictionary Keys ===")
locations = {
    (40.7128, -74.0060): "New York",
    (34.0522, -118.2437): "Los Angeles",
    (51.5074, -0.1278): "London"
}
print("Coordinates as dictionary keys:")
for coord, city in locations.items():
    print(f"  {coord} -> {city}")
print()

# 3. Performance comparison
print("=== Performance ===")
import sys
list_example = [1, 2, 3, 4, 5]
tuple_example = (1, 2, 3, 4, 5)
print(f"List size: {sys.getsizeof(list_example)} bytes")
print(f"Tuple size: {sys.getsizeof(tuple_example)} bytes")
print("Tuples use less memory!")
print()

# 4. When to use which
print("=== Use Cases ===")
print("USE TUPLES for:")
print("  - Fixed collections (coordinates, RGB colors)")
print("  - Dictionary keys")
print("  - Function return values")
print("  - Data that shouldn't change")
print()
print("USE LISTS for:")
print("  - Collections that need to grow/shrink")
print("  - When you need to modify elements")
print("  - When order and indexing matter")
print()

# 5. Real-world tuple examples
print("=== Real-World Examples ===")
# RGB color - shouldn't change
RED = (255, 0, 0)
print(f"Red color: {RED}")

# Coordinate point
origin = (0, 0)
print(f"Origin: {origin}")

# Database record (immutable row)
user = ("Alice", "alice@email.com", 25)
print(f"User record: {user}")

# Named tuples make this even better!
from collections import namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(3, 4)
print(f"Named tuple: {p}, x={p.x}, y={p.y}")
